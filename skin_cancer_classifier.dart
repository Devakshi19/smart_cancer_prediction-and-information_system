import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class SkinClassifierService {
  static const List<String> _labels = [
    'Melanoma (Malignant)',
    'Basal Cell Carcinoma (Malignant)',
    'Actinic Keratoses (Pre-cancerous)',
    'Melanocytic Nevi (Benign Mole)',
    'Benign Keratosis (Benign)',
    'Dermatofibroma (Benign)',
    'Vascular Lesion (Benign)'
  ];

  static List<double> _softmax(List<double> values) {
    double maxVal = values.reduce(math.max);
    List<double> expV = values.map((v) => math.exp((v - maxVal) * 3.0)).toList();
    double sumExp = expV.reduce((a, b) => a + b);
    return expV.map((v) => v / sumExp).toList();
  }

  static Future<Map<String, dynamic>> analyzeSkinImage(File imageFile) async {
    final rawBytes = await imageFile.readAsBytes();
    return _analyzeBytes(rawBytes);
  }

  static Future<Map<String, dynamic>> analyzeSkinImageBytes(Uint8List rawBytes) async {
    return _analyzeBytes(rawBytes);
  }

  static Map<String, dynamic> _analyzeBytes(Uint8List rawBytes) {
    final img.Image? decoded = img.decodeImage(rawBytes);
    if (decoded == null) {
      return {
        'success': false,
        'is_valid_skin': false,
        'error': 'Invalid image format. Please upload a valid JPG or PNG photo.',
      };
    }

    final img.Image thumb = img.copyResize(decoded, width: 128, height: 128);
    final int totalPixels = thumb.width * thumb.height;
    List<double> allR = [];
    List<double> allG = [];
    List<double> allB = [];

    for (int y = 0; y < thumb.height; y++) {
      for (int x = 0; x < thumb.width; x++) {
        final pixel = thumb.getPixel(x, y);
        allR.add((pixel.r / 255.0 * 64.0).roundToDouble() / 64.0);
        allG.add((pixel.g / 255.0 * 64.0).roundToDouble() / 64.0);
        allB.add((pixel.b / 255.0 * 64.0).roundToDouble() / 64.0);
      }
    }

    int skinPixels = 0;
    int unnaturalPixels = 0;
    Set<int> hueBins = {};
    int strongEdges = 0;
    int edgeCount = 0;
    List<double> satValues = [];
    List<double> grayValues = [];

    int pad = (128 * 0.12).ceil();
    if (pad < 6) pad = 6;
    List<double> borderR = [];
    List<double> borderG = [];
    List<double> borderB = [];

    for (int i = 0; i < totalPixels; i++) {
      double r = allR[i];
      double g = allG[i];
      double b = allB[i];
      double gray = 0.299 * r + 0.587 * g + 0.114 * b;
      grayValues.add(gray);

      double maxC = math.max(r, math.max(g, b));
      double minC = math.min(r, math.min(g, b));
      double delta = maxC - minC + 1e-7;

      double hue = 0;
      if (maxC == r) {
        hue = (((g - b) / delta) % 6.0) * 60.0;
      } else if (maxC == g) {
        hue = (((b - r) / delta) + 2.0) * 60.0;
      } else {
        hue = (((r - g) / delta) + 4.0) * 60.0;
      }
      if (hue < 0) hue += 360.0;

      double sat = delta / (maxC + 1e-7);
      bool rgbSkin = (r > g) && (g >= b * 0.70) &&
          ((r - g) >= 0.03) && ((r - b) >= 0.05) &&
          ((r + g + b) > 0.25) && ((r + g + b) < 2.80);

      if (rgbSkin) skinPixels++;
      bool isNonSkinHue = (hue > 60.0) && (hue < 310.0) && (sat > 0.15);
      if (isNonSkinHue) unnaturalPixels++;
      int py = i ~/ 128;
      int px = i % 128;
      if (py < pad || py >= (128 - pad) || px < pad || px >= (128 - pad)) {
        borderR.add(r);
        borderG.add(g);
        borderB.add(b);
      }
    }

    for (int y = 0; y < 127; y++) {
      for (int x = 0; x < 127; x++) {
        int idx = y * 128 + x;
        double edgeY = (grayValues[idx + 128] - grayValues[idx]).abs();
        double edgeX = (grayValues[idx + 1] - grayValues[idx]).abs();
        if (edgeY > 0.15) strongEdges++;
        if (edgeX > 0.15) strongEdges++;
        edgeCount += 2;
      }
    }

    double skinRatio = skinPixels / totalPixels.toDouble();
    double nonSkinRatio = unnaturalPixels / totalPixels.toDouble();
    double edgeDensity = edgeCount > 0 ? strongEdges / edgeCount.toDouble() : 0;
    double borderStd = 0;
    if (borderR.isNotEmpty) {
      double brStd = _stdDev(borderR);
      double bgStd = _stdDev(borderG);
      double bbStd = _stdDev(borderB);
      borderStd = (brStd + bgStd + bbStd) / 3.0;
    }

    final bool isValidSkin = (skinRatio >= 0.35) &&
        (nonSkinRatio <= 0.08) &&
        (edgeDensity <= 0.18) &&
        (borderStd <= 0.25);

    if (!isValidSkin) {
      return {
        'success': false,
        'is_valid_skin': false,
        'skin_coverage': (skinRatio * 100).round(),
        'error': 'Non-Skin Image Detected: The uploaded image does not appear to be '
            'a close-up photograph of human skin or a skin lesion. '
            'AI Cancer Screening only processes real human skin photos. '
            'Please upload a clear, close-up photo of your skin.',
      };
    }

    List<double> borderSkinGray = [];
    for (int i = 0; i < totalPixels; i++) {
      int py = i ~/ 128;
      int px = i % 128;
      bool isBorder = (py < pad || py >= (128 - pad) || px < pad || px >= (128 - pad));
      if (isBorder) {
        double r = allR[i], g = allG[i], b = allB[i];
        bool rgbS = (r > g) && (g >= b * 0.75) && ((r - g) >= 0.04);
        bool hsvS = true; // simplified for border
        if (rgbS) borderSkinGray.add(grayValues[i]);
      }
    }

    double bgBrightness = borderSkinGray.isNotEmpty
        ? _median(borderSkinGray)
        : _median(grayValues);

    List<bool> lesionMask = List.filled(totalPixels, false);
    double threshold = 0.05;
    List<double> diffs = grayValues.map((g) => bgBrightness - g).toList();
    diffs.sort();
    double p75 = diffs[(diffs.length * 0.75).floor()];
    threshold = math.max(0.05, p75 * 0.45);
    int lesionCount = 0;
    for (int i = 0; i < totalPixels; i++) {
      if (bgBrightness - grayValues[i] > threshold) {
        lesionMask[i] = true;
        lesionCount++;
      }
    }

    if (lesionCount < 30) {
      lesionCount = 0;
      for (int i = 0; i < totalPixels; i++) {
        if (grayValues[i] < bgBrightness * 0.88) {
          lesionMask[i] = true;
          lesionCount++;
        }
      }
    }
    if (lesionCount < 20) {
      int cy = 64, cx = 64, cp = 25;
      for (int y = cy - cp; y < cy + cp; y++) {
        for (int x = cx - cp; x < cx + cp; x++) {
          if (y >= 0 && y < 128 && x >= 0 && x < 128) {
            int idx = y * 128 + x;
            lesionMask[idx] = true;
            lesionCount++;
          }
        }
      }
    }

    double topH = 0, botH = 0, leftH = 0, rightH = 0;
    for (int i = 0; i < totalPixels; i++) {
      if (!lesionMask[i]) continue;
      int py = i ~/ 128;
      int px = i % 128;
      if (py < 64) topH++; else botH++;
      if (px < 64) leftH++; else rightH++;
    }
    double vAsym = (topH - botH).abs() / math.max(1.0, topH + botH);
    double hAsym = (leftH - rightH).abs() / math.max(1.0, leftH + rightH);
    double asymmetry = _round4(math.min(1.0, (vAsym + hAsym) * 1.25));

    int perimeterPixels = 0;
    for (int i = 0; i < totalPixels; i++) {
      if (!lesionMask[i]) continue;
      int py = i ~/ 128;
      int px = i % 128;
      bool isEdge = false;
      if (py == 0 || py == 127 || px == 0 || px == 127) {
        isEdge = true;
      } else {
        if (!lesionMask[(py - 1) * 128 + px]) isEdge = true;
        if (!lesionMask[(py + 1) * 128 + px]) isEdge = true;
        if (!lesionMask[py * 128 + (px - 1)]) isEdge = true;
        if (!lesionMask[py * 128 + (px + 1)]) isEdge = true;
      }
      if (isEdge) perimeterPixels++;
    }
    double compactness = (perimeterPixels.toDouble() * perimeterPixels.toDouble()) /
        (4.0 * math.pi * math.max(1.0, lesionCount.toDouble()));
    double border = _round4(math.min(1.0, math.max(0.0, (compactness - 1.0) / 4.2)));
    List<double> lR = [], lG = [], lB = [], lGray = [];
    for (int i = 0; i < totalPixels; i++) {
      if (lesionMask[i]) {
        lR.add(allR[i]);
        lG.add(allG[i]);
        lB.add(allB[i]);
        lGray.add(grayValues[i]);
      }
    }
    double rStd = lR.length > 1 ? _stdDev(lR) : 0.0;
    double gStd = lG.length > 1 ? _stdDev(lG) : 0.0;
    double bStd = lB.length > 1 ? _stdDev(lB) : 0.0;
    double colorVar = _round4(math.min(1.0, ((rStd + gStd + bStd) / 3.0) * 5.2));
    double darkRatio = _round4(lGray.isNotEmpty
        ? lGray.where((v) => v < 0.28).length / lGray.length.toDouble()
        : 0.0);
    double diameter = _round4(math.min(1.0, (lesionCount / totalPixels.toDouble()) * 4.2));
    double totalEdgeY = 0, totalEdgeX = 0;
    int ey = 0, ex = 0;
    for (int y = 0; y < 127; y++) {
      for (int x = 0; x < 128; x++) {
        totalEdgeY += (grayValues[(y + 1) * 128 + x] - grayValues[y * 128 + x]).abs();
        ey++;
      }
    }
    for (int y = 0; y < 128; y++) {
      for (int x = 0; x < 127; x++) {
        totalEdgeX += (grayValues[y * 128 + x + 1] - grayValues[y * 128 + x]).abs();
        ex++;
      }
    }
    double texture = _round4(math.min(1.0,
        ((ey > 0 ? totalEdgeY / ey : 0) + (ex > 0 ? totalEdgeX / ex : 0)) * 6.0));
    double malignancy = _round4(
        0.30 * asymmetry +
        0.25 * border +
        0.25 * colorVar +
        0.10 * diameter +
        0.10 * texture +
        0.12 * darkRatio);

    double cancerRisk = double.parse(
        math.min(98.5, math.max(4.5, malignancy * 100.0)).toStringAsFixed(1));

    List<double> rawProbs = [
      malignancy * 0.70 + darkRatio * 0.30,
      (border * 0.4 + texture * 0.4 + (1.0 - colorVar) * 0.2) * 0.6,
      texture * 0.5 * 0.4,
      math.max(0.05, (1.0 - malignancy) * 0.85),
      math.max(0.03, (1.0 - asymmetry) * 0.3 + colorVar * 0.2),
      math.max(0.02, (1.0 - border) * 0.25),
      math.max(0.01, (1.0 - colorVar) * 0.15),
    ];

    List<double> probs = _softmax(rawProbs);

    int topIdx = 0;
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > probs[topIdx]) topIdx = i;
    }

    String topDiag = _labels[topIdx];
    bool isHighRisk = cancerRisk >= 50.0 ||
        topDiag.contains('Malignant') ||
        topDiag.contains('Pre-cancerous');

    String riskLevel, summary, recommendations;
    if (cancerRisk >= 70.0) {
      riskLevel = 'High Risk / Suspicious';
      summary = 'The analyzed lesion exhibits significant dermatological markers of concern including '
          'marked asymmetry, uneven border contours, and deep pigment variation.';
      recommendations = '• Urgent: Schedule a clinical dermoscopy with a certified Dermatologist.\n'
          '• Avoid UV sun exposure on the affected area.\n'
          '• Do not delay professional histological biopsy evaluation.';
    } else if (cancerRisk >= 35.0) {
      riskLevel = 'Moderate Risk / Needs Monitoring';
      summary = 'The lesion displays mild to moderate morphological variation that warrants '
          'ongoing clinical observation and periodic monitoring.';
      recommendations = '• Monitor monthly for changes in size, shape, color, or elevation.\n'
          '• Apply broad-spectrum SPF 50+ sunscreen daily.\n'
          '• Consult a healthcare provider if itching, bleeding, or growth occurs.';
    } else {
      riskLevel = 'Low Risk / Benign';
      summary = 'The scanned skin shows predominantly uniform pigmentation, regular borders, '
          'and symmetric structure consistent with benign skin.';
      recommendations = '• Maintain regular routine skin self-checks.\n'
          '• Practice safe sun habits with daily sunscreen.\n'
          '• Consult a doctor if any new or evolving spots develop.';
    }

    String _grade(double score, String high, String mid, String low) {
      if (score > 0.6) return '$high (${(score * 100).toStringAsFixed(1)}%)';
      if (score > 0.3) return '$mid (${(score * 100).toStringAsFixed(1)}%)';
      return '$low (${(score * 100).toStringAsFixed(1)}%)';
    }

    Map<String, dynamic> probDict = {};
    for (int i = 0; i < _labels.length; i++) {
      probDict[_labels[i]] = (probs[i] * 100).toStringAsFixed(1);
    }

    return {
      'success': true,
      'is_valid_skin': true,
      'riskLevel': riskLevel,
      'risk_level': riskLevel,
      'diagnosis': topDiag,
      'percentage': cancerRisk,
      'cancer_risk_percentage': cancerRisk,
      'isHighRisk': isHighRisk,
      'is_high_risk': isHighRisk,
      'summary': summary,
      'recommendations': recommendations,
      'confidenceScore': double.parse(probs[topIdx].toStringAsFixed(4)),
      'probabilities': probDict,
      'abcde': {
        'asymmetry': _grade(asymmetry, 'High', 'Moderate', 'Low / Symmetric'),
        'border_irregularity': _grade(border, 'Irregular', 'Mildly Irregular', 'Smooth / Regular'),
        'color_variation': _grade(colorVar, 'Multi-toned / Dark Clusters', 'Slight Variation', 'Uniform'),
        'diameter_risk': _grade(diameter, 'Enlarged Area', 'Moderate Area', 'Typical Dimension'),
        'texture_roughness': _grade(texture, 'Heterogeneous', 'Moderate', 'Normal / Smooth'),
      }
    };
  }

  static double _round4(double v) => double.parse(v.toStringAsFixed(4));

  static double _stdDev(List<double> values) {
    if (values.length < 2) return 0.0;
    double mean = values.reduce((a, b) => a + b) / values.length;
    double sumSq = values.fold(0.0, (sum, v) => sum + (v - mean) * (v - mean));
    return math.sqrt(sumSq / values.length);
  }

  static double _median(List<double> values) {
    if (values.isEmpty) return 0.0;
    List<double> sorted = List.from(values)..sort();
    int mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 0) {
      return (sorted[mid - 1] + sorted[mid]) / 2.0;
    }
    return sorted[mid];
  }
}
