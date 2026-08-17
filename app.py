import os
import io
import math
import numpy as np
from PIL import Image
from flask import Flask, request, jsonify
from flask_cors import CORS

try:
    import onnxruntime as ort
    ONNX_AVAILABLE = True
except ImportError:
    ONNX_AVAILABLE = False

app = Flask(__name__)
CORS(app)

MODEL_PATH = os.path.join(os.path.dirname(__file__), 'model', 'model_quantized.onnx')
onnx_session = None

HAM10000_CLASSES = [
    'Benign Keratosis (Benign)',
    'Basal Cell Carcinoma (Malignant)',
    'Actinic Keratoses (Pre-cancerous)',
    'Vascular Lesion (Benign)',
    'Melanocytic Nevi (Benign Mole)',
    'Melanoma (Malignant)',
    'Dermatofibroma (Benign)'
]

MALIGNANT_CLASSES = [
    'Basal Cell Carcinoma (Malignant)',
    'Melanoma (Malignant)',
    'Actinic Keratoses (Pre-cancerous)'
]

def get_onnx_session():
    global onnx_session
    if onnx_session is None and ONNX_AVAILABLE and os.path.exists(MODEL_PATH) and os.path.getsize(MODEL_PATH) > 50 * 1024 * 1024:
        try:
            onnx_session = ort.InferenceSession(MODEL_PATH, providers=['CPUExecutionProvider'])
            print("Loaded Vision Transformer (HAM10000) ONNX Deep Learning Model.")
        except Exception as e:
            print(f"Could not load ONNX model: {e}")
            onnx_session = None
    return onnx_session

def validate_skin_image(img_resized):
    """
    Evaluates whether the photo is authentic human skin tissue.
    Rejects posters, animals, cars, text, landscapes, graphics.
    """
    raw_np = np.array(img_resized, dtype=np.float32) / 255.0
    img_np = np.round(raw_np * 64.0) / 64.0
    
    r = img_np[:, :, 0]
    g = img_np[:, :, 1]
    b = img_np[:, :, 2]
    h_px, w_px = r.shape
    total_pixels = h_px * w_px

    # Melanin/Hemoglobin RGB Rule
    rgb_skin = (
        (r > g) & (g >= b * 0.75) &
        ((r - g) >= 0.04) & ((r - b) >= 0.06) &
        ((r + g + b) > 0.30) & ((r + g + b) < 2.75)
    )

    # HSV Rule
    max_c = np.maximum(np.maximum(r, g), b)
    min_c = np.minimum(np.minimum(r, g), b)
    delta = max_c - min_c + 1e-7

    h_deg = np.zeros_like(r)
    mask_r = (max_c == r)
    mask_g = (max_c == g) & ~mask_r
    mask_b = ~mask_r & ~mask_g

    h_deg[mask_r] = (((g[mask_r] - b[mask_r]) / delta[mask_r]) % 6.0) * 60.0
    h_deg[mask_g] = (((b[mask_g] - r[mask_g]) / delta[mask_g]) + 2.0) * 60.0
    h_deg[mask_b] = (((r[mask_b] - g[mask_b]) / delta[mask_b]) + 4.0) * 60.0

    s_val = delta / (max_c + 1e-7)
    v_val = max_c

    hsv_skin = (
        ((h_deg <= 40.0) | (h_deg >= 335.0)) &
        (s_val >= 0.10) & (s_val <= 0.70) &
        (v_val >= 0.20) & (v_val <= 0.96)
    )

    skin_mask = rgb_skin & hsv_skin
    skin_ratio = float(np.sum(skin_mask)) / total_pixels

    # Color diversity (poster detection)
    hue_bins = np.floor(h_deg / 20.0).astype(int)
    sat_significant = s_val > 0.12
    unique_hue_bins = len(np.unique(hue_bins[sat_significant])) if np.sum(sat_significant) > 100 else 0

    # Edge density
    gray = 0.299 * r + 0.587 * g + 0.114 * b
    edges_y = np.abs(gray[1:, :] - gray[:-1, :])
    edges_x = np.abs(gray[:, 1:] - gray[:, :-1])
    strong_edges = float(np.sum(edges_y > 0.12)) + float(np.sum(edges_x > 0.12))
    edge_density = strong_edges / max(1, (edges_y.size + edges_x.size))

    # Unnatural colors
    unnatural = (
        ((h_deg > 55.0) & (h_deg < 320.0) & (s_val > 0.18)) |
        (s_val > 0.75) |
        ((r < 0.08) & (g < 0.08) & (b < 0.08)) |
        ((r > 0.95) & (g > 0.95) & (b > 0.95))
    )
    unnatural_ratio = float(np.sum(unnatural)) / total_pixels

    # Border margin uniformity
    pad = max(6, int(min(h_px, w_px) * 0.12))
    border_mask = np.zeros((h_px, w_px), dtype=bool)
    border_mask[:pad, :] = True
    border_mask[-pad:, :] = True
    border_mask[:, :pad] = True
    border_mask[:, -pad:] = True
    border_std = float((np.std(r[border_mask]) + np.std(g[border_mask]) + np.std(b[border_mask])) / 3.0)

    # Rejection decisions
    is_valid = (
        (skin_ratio >= 0.45) and
        (unique_hue_bins <= 8) and
        (edge_density <= 0.15) and
        (unnatural_ratio <= 0.22) and
        (border_std <= 0.20)
    )

    return is_valid, skin_ratio, img_np, gray, border_mask, skin_mask

def compute_abcde_features(img_np, gray, border_mask, skin_mask):
    """Calculates deterministic dermatological ABCDE clinical features."""
    h_px, w_px = gray.shape
    total_pixels = h_px * w_px
    r = img_np[:, :, 0]
    g = img_np[:, :, 1]
    b = img_np[:, :, 2]

    bg_brightness = float(np.median(gray[border_mask & skin_mask])) if np.sum(border_mask & skin_mask) > 20 else float(np.median(gray[border_mask]))
    diff_from_bg = bg_brightness - gray
    threshold = max(0.05, float(np.percentile(diff_from_bg, 75)) * 0.45)
    lesion_mask = diff_from_bg > threshold

    if np.sum(lesion_mask) < 30:
        lesion_mask = gray < (bg_brightness * 0.88)
    if np.sum(lesion_mask) < 20:
        cy, cx = h_px // 2, w_px // 2
        cp = min(h_px, w_px) // 5
        lesion_mask[cy - cp:cy + cp, cx - cp:cx + cp] = True

    lesion_count = int(np.sum(lesion_mask))
    lesion_r = r[lesion_mask]
    lesion_g = g[lesion_mask]
    lesion_b = b[lesion_mask]
    lesion_gray = gray[lesion_mask]

    # Asymmetry
    top = float(np.sum(lesion_mask[:h_px // 2, :]))
    bot = float(np.sum(lesion_mask[h_px // 2:, :]))
    lft = float(np.sum(lesion_mask[:, :w_px // 2]))
    rgt = float(np.sum(lesion_mask[:, w_px // 2:]))
    v_asym = abs(top - bot) / max(1.0, top + bot)
    h_asym = abs(lft - rgt) / max(1.0, lft + rgt)
    asymmetry = round(min(1.0, (v_asym + h_asym) * 1.25), 4)

    # Border Irregularity
    mu8 = lesion_mask.astype(np.uint8)
    eroded = np.zeros_like(mu8)
    eroded[1:-1, 1:-1] = (
        mu8[1:-1, 1:-1] & mu8[:-2, 1:-1] & mu8[2:, 1:-1] &
        mu8[1:-1, :-2] & mu8[1:-1, 2:]
    )
    perimeter = float(np.sum(mu8 - eroded))
    area = max(1.0, float(lesion_count))
    compactness = (perimeter ** 2) / (4.0 * math.pi * area)
    border = round(min(1.0, max(0.0, (compactness - 1.0) / 4.2)), 4)

    # Color Variegation
    r_std = float(np.std(lesion_r)) if len(lesion_r) > 1 else 0.0
    g_std = float(np.std(lesion_g)) if len(lesion_g) > 1 else 0.0
    b_std = float(np.std(lesion_b)) if len(lesion_b) > 1 else 0.0
    color_var = round(min(1.0, ((r_std + g_std + b_std) / 3.0) * 5.2), 4)
    dark_ratio = round(float(np.mean(lesion_gray < 0.28)), 4) if len(lesion_gray) > 0 else 0.0

    # Diameter
    diameter = round(min(1.0, (float(lesion_count) / float(total_pixels)) * 4.2), 4)

    # Texture
    edges_y = np.abs(gray[1:, :] - gray[:-1, :])
    edges_x = np.abs(gray[:, 1:] - gray[:, :-1])
    texture = round(min(1.0, (float(np.mean(edges_y)) + float(np.mean(edges_x))) * 6.0), 4)

    def grade(score, high_label, mid_label, low_label):
        if score > 0.6:
            return f"{high_label} ({round(score * 100, 1)}%)"
        elif score > 0.3:
            return f"{mid_label} ({round(score * 100, 1)}%)"
        else:
            return f"{low_label} ({round(score * 100, 1)}%)"

    abcde = {
        "asymmetry": grade(asymmetry, "High", "Moderate", "Low / Symmetric"),
        "border_irregularity": grade(border, "Irregular", "Mildly Irregular", "Smooth / Regular"),
        "color_variation": grade(color_var, "Multi-toned / Dark Clusters", "Slight Variation", "Uniform"),
        "diameter_risk": grade(diameter, "Enlarged Area", "Moderate Area", "Typical Dimension"),
        "texture_roughness": grade(texture, "Heterogeneous", "Moderate", "Normal / Smooth")
    }

    heuristic_risk = round(min(98.5, max(4.5, (
        0.30 * asymmetry +
        0.25 * border +
        0.25 * color_var +
        0.10 * diameter +
        0.10 * texture +
        0.12 * dark_ratio
    ) * 100.0)), 1)

    return abcde, heuristic_risk

def predict_skin_lesion(image_bytes):
    """Hybrid Deep Learning (HAM10000 ViT) + ABCDE Computer Vision Engine."""
    try:
        pil_image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    except Exception:
        return {
            "success": False,
            "is_valid_skin": False,
            "error": "Invalid image file. Please upload a clear JPG or PNG photo."
        }

    # Step 1: Validate skin tissue
    img_eval = pil_image.resize((128, 128), Image.Resampling.LANCZOS)
    is_valid, skin_ratio, img_np, gray, border_mask, skin_mask = validate_skin_image(img_eval)

    if not is_valid:
        return {
            "success": False,
            "is_valid_skin": False,
            "skin_coverage": round(skin_ratio * 100, 1),
            "error": (
                "Non-Skin Image Detected: The uploaded image does not appear to be "
                "a close-up photograph of human skin or a skin lesion. "
                "AI Cancer Screening only processes real human skin photos. "
                "Please upload a clear, close-up photo of your skin."
            )
        }

    # Step 2: Compute clinical ABCDE features
    abcde, heuristic_risk = compute_abcde_features(img_np, gray, border_mask, skin_mask)

    # Step 3: Deep Learning Inference (if model is available)
    session = get_onnx_session()
    if session is not None:
        try:
            # Preprocess for Vision Transformer (224x224, normalized with mean 0.5, std 0.5)
            vit_img = pil_image.resize((224, 224), Image.Resampling.BILINEAR)
            vit_np = np.array(vit_img, dtype=np.float32) / 255.0
            vit_norm = (vit_np - 0.5) / 0.5
            vit_input = np.transpose(vit_norm, (2, 0, 1))[np.newaxis, :, :, :]

            input_name = session.get_inputs()[0].name
            outputs = session.run(None, {input_name: vit_input})
            logits = outputs[0][0]
            
            # Softmax
            exp_logits = np.exp(logits - np.max(logits))
            probs = exp_logits / np.sum(exp_logits)

            prob_dict = {HAM10000_CLASSES[i]: round(float(probs[i] * 100.0), 1) for i in range(len(HAM10000_CLASSES))}
            top_idx = int(np.argmax(probs))
            top_diag = HAM10000_CLASSES[top_idx]

            # Calculate cancer risk percentage: sum of Malignant/Pre-cancerous probabilities
            cancer_risk_dl = sum(probs[i] for i in range(len(HAM10000_CLASSES)) if HAM10000_CLASSES[i] in MALIGNANT_CLASSES) * 100.0
            cancer_risk = round(float(0.70 * cancer_risk_dl + 0.30 * heuristic_risk), 1)
            cancer_risk = min(98.5, max(4.5, cancer_risk))
            model_used = "Vision Transformer (HAM10000 Neural Network)"
        except Exception as e:
            print(f"Inference error: {e}, falling back to ABCDE")
            cancer_risk, top_diag, prob_dict = heuristic_risk, "Skin Lesion Analyzed", {}
            model_used = "Dermatological ABCDE Engine"
    else:
        cancer_risk = heuristic_risk
        top_diag = 'Melanoma (Malignant)' if cancer_risk >= 70 else ('Melanocytic Nevi (Benign Mole)' if cancer_risk < 40 else 'Basal Cell Carcinoma (Malignant)')
        prob_dict = {
            'Melanoma (Malignant)': round(cancer_risk * 0.6, 1),
            'Melanocytic Nevi (Benign Mole)': round((100 - cancer_risk) * 0.8, 1),
            'Basal Cell Carcinoma (Malignant)': round(cancer_risk * 0.3, 1),
            'Benign Keratosis (Benign)': round((100 - cancer_risk) * 0.15, 1),
            'Actinic Keratoses (Pre-cancerous)': round(cancer_risk * 0.1, 1),
            'Vascular Lesion (Benign)': 1.5,
            'Dermatofibroma (Benign)': 1.0,
        }
        model_used = "Deterministic ABCDE Clinical Engine"

    is_high_risk = cancer_risk >= 50.0 or ('Malignant' in top_diag) or ('Pre-cancerous' in top_diag)

    if cancer_risk >= 70.0:
        risk_level = "High Risk / Suspicious"
        summary = (
            "The analyzed lesion exhibits significant dermatological markers of concern including "
            "marked asymmetry, uneven border contours, and deep pigment variation."
        )
        recommendations = (
            "• Urgent: Schedule a clinical dermoscopy with a certified Dermatologist.\n"
            "• Avoid UV sun exposure on the affected area.\n"
            "• Do not delay professional histological biopsy evaluation."
        )
    elif cancer_risk >= 35.0:
        risk_level = "Moderate Risk / Needs Monitoring"
        summary = (
            "The lesion displays mild to moderate morphological variation that warrants "
            "ongoing clinical observation and periodic monitoring."
        )
        recommendations = (
            "• Monitor monthly for changes in size, shape, color, or elevation.\n"
            "• Apply broad-spectrum SPF 50+ sunscreen daily.\n"
            "• Consult a healthcare provider if itching, bleeding, or growth occurs."
        )
    else:
        risk_level = "Low Risk / Benign"
        summary = (
            "The scanned skin shows predominantly uniform pigmentation, regular borders, "
            "and symmetric structure consistent with benign skin."
        )
        recommendations = (
            "• Maintain regular routine skin self-checks.\n"
            "• Practice safe sun habits with daily sunscreen.\n"
            "• Consult a doctor if any new or evolving spots develop."
        )

    return {
        "success": True,
        "is_valid_skin": True,
        "skin_coverage": round(skin_ratio * 100, 1),
        "diagnosis": top_diag,
        "percentage": cancer_risk,
        "cancer_risk_percentage": cancer_risk,
        "risk_level": risk_level,
        "riskLevel": risk_level,
        "is_high_risk": is_high_risk,
        "isHighRisk": is_high_risk,
        "summary": summary,
        "recommendations": recommendations,
        "probabilities": prob_dict,
        "abcde": abcde,
        "engine": model_used
    }

@app.route('/', methods=['GET'])
def index():
    session = get_onnx_session()
    return jsonify({
        "status": "online",
        "service": "Skin Cancer AI Diagnostic Engine API",
        "endpoints": {
            "health": "/health",
            "predict_skin": "/predict-skin"
        },
        "skin_validation": True,
        "deep_learning_active": session is not None,
        "deterministic": True
    })

@app.route('/health', methods=['GET'])
def health():
    session = get_onnx_session()
    return jsonify({
        "status": "healthy",
        "service": "Skin Cancer AI Diagnostic Engine",
        "skin_validation": True,
        "deep_learning_active": session is not None,
        "deterministic": True
    })

@app.route('/predict-skin', methods=['POST'])
@app.route('/predict', methods=['POST'])
def predict():
    try:
        file = None
        if 'file' in request.files:
            file = request.files['file']
        elif 'image' in request.files:
            file = request.files['image']
        elif request.data:
            result = predict_skin_lesion(request.data)
            code = 200 if result.get("success") else 422
            return jsonify(result), code

        if not file:
            return jsonify({"success": False, "is_valid_skin": False, "error": "No image file provided."}), 400

        image_bytes = file.read()
        if len(image_bytes) == 0:
            return jsonify({"success": False, "is_valid_skin": False, "error": "Empty file received."}), 400

        result = predict_skin_lesion(image_bytes)
        code = 200 if result.get("success") else 422
        return jsonify(result), code
    except Exception as e:
        return jsonify({"success": False, "is_valid_skin": False, "error": str(e)}), 500

if __name__ == '__main__':
    print("Skin Cancer AI Diagnostic Engine running on http://0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000, debug=False)
