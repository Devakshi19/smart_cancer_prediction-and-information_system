import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../api_service.dart';
import '../skin_cancer_classifier.dart';
import '../lung_cancer_classifier.dart';
import '../breast_cancer_classifier.dart';
import '../uterine_cancer_classifier.dart';
import 'scan_service.dart';

class ScanPage extends StatefulWidget {
  final String? initialCategory;
  const ScanPage({Key? key, this.initialCategory}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _imageBytes;
  XFile? _pickedXFile;

  bool _isLoading = false;

  final List<String> _categories = [
    'Skin',
    'Lung',
    'Breast',
    'Uterine',
  ];

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? _categories.first;
  }

  String get _categoryDescription {
    switch (_selectedCategory) {
      case 'Skin':
        return 'Analyze skin lesions, moles, or discolored spots for melanoma and carcinoma risk using AI backend & ABCDE criteria.';
      case 'Lung':
        return 'Analyze chest X-rays (PA/AP) or thoracic CT scans for pulmonary nodules, masses, and lung cancer risk using AI backend.';
      case 'Breast':
        return 'Analyze Mammograms (CC/MLO view) & Breast Ultrasound scans for microcalcifications, masses, spiculation, and BI-RADS risk.';
      case 'Uterine':
        return 'Analyze Pelvic / Transvaginal Ultrasound (TVS) & Histopathology scans for endometrial stripe thickening, junctional invasion, and FIGO staging.';
      default:
        return 'Upload medical scan for AI analysis.';
    }
  }

  bool get _hasImage => kIsWeb ? _imageBytes != null : _imageFile != null;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );

      if (pickedFile != null) {
        _pickedXFile = pickedFile;
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageBytes = bytes;
            _imageFile = null;
          });
        } else {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageFile = File(pickedFile.path);
            _imageBytes = bytes;
          });
        }
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: $e', isError: true);
    }
  }

  Future<void> _runAIDetectionScan() async {
    if (!_hasImage) {
      _showSnackBar('Please select or capture an image first.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? downloadUrl;

    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String categoryFolder = _selectedCategory.toLowerCase();

      try {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('scans/$categoryFolder/$fileName');

        UploadTask uploadTask;
        if (kIsWeb && _imageBytes != null) {
          uploadTask = storageRef.putData(_imageBytes!);
        } else if (_imageFile != null) {
          uploadTask = storageRef.putFile(_imageFile!);
        } else if (_imageBytes != null) {
          uploadTask = storageRef.putData(_imageBytes!);
        } else {
          throw Exception('No image data found.');
        }

        final TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        debugPrint("Firebase Storage upload note: $e");
        downloadUrl = null;
      }
      Map<String, dynamic> aiResult;

      if (_selectedCategory == 'Uterine') {
        try {
          if (_imageFile != null && !kIsWeb) {
            aiResult = await ApiService.analyzeUterineWithPythonServer(_imageFile!);
          } else if (_imageBytes != null) {
            aiResult = await ApiService.analyzeUterineWithPythonServerBytes(_imageBytes!);
          } else {
            throw Exception('No valid image data available.');
          }
        } catch (backendError) {
          debugPrint('Backend server error/unreachable: $backendError. Using local uterine classifier.');
          if (_imageBytes != null) {
            aiResult = await UterineClassifierService.analyzeUterineImageBytes(_imageBytes!);
          } else if (_imageFile != null) {
            aiResult = await UterineClassifierService.analyzeUterineImage(_imageFile!);
          } else {
            rethrow;
          }
        }
      } else if (_selectedCategory == 'Breast') {
        try {
          if (_imageFile != null && !kIsWeb) {
            aiResult = await ApiService.analyzeBreastWithPythonServer(_imageFile!);
          } else if (_imageBytes != null) {
            aiResult = await ApiService.analyzeBreastWithPythonServerBytes(_imageBytes!);
          } else {
            throw Exception('No valid image data available.');
          }
        } catch (backendError) {
          debugPrint('Backend server error/unreachable: $backendError. Using local breast classifier.');
          if (_imageBytes != null) {
            aiResult = await BreastClassifierService.analyzeBreastImageBytes(_imageBytes!);
          } else if (_imageFile != null) {
            aiResult = await BreastClassifierService.analyzeBreastImage(_imageFile!);
          } else {
            rethrow;
          }
        }
      } else if (_selectedCategory == 'Lung') {
        try {
          if (_imageFile != null && !kIsWeb) {
            aiResult = await ApiService.analyzeLungWithPythonServer(_imageFile!);
          } else if (_imageBytes != null) {
            aiResult = await ApiService.analyzeLungWithPythonServerBytes(_imageBytes!);
          } else {
            throw Exception('No valid image data available.');
          }
        } catch (backendError) {
          debugPrint('Backend server error/unreachable: $backendError. Using local lung classifier.');
          if (_imageBytes != null) {
            aiResult = await LungClassifierService.analyzeLungImageBytes(_imageBytes!);
          } else if (_imageFile != null) {
            aiResult = await LungClassifierService.analyzeLungImage(_imageFile!);
          } else {
            rethrow;
          }
        }
      } else if (_selectedCategory == 'Skin') {
        try {
          if (_imageFile != null && !kIsWeb) {
            aiResult = await ApiService.analyzeSkinWithPythonServer(_imageFile!);
          } else if (_imageBytes != null) {
            aiResult = await ApiService.analyzeSkinWithPythonServerBytes(_imageBytes!);
          } else {
            throw Exception('No valid image data available.');
          }
        } catch (backendError) {
          debugPrint('Backend server error/unreachable: $backendError. Using local skin classifier.');
          if (_imageBytes != null) {
            aiResult = await SkinClassifierService.analyzeSkinImageBytes(_imageBytes!);
          } else if (_imageFile != null) {
            aiResult = await SkinClassifierService.analyzeSkinImage(_imageFile!);
          } else {
            rethrow;
          }
        }
      } else {
        aiResult = {
          'riskLevel': 'Low Risk / Normal',
          'diagnosis': 'Normal $_selectedCategory Scan',
          'percentage': 96.4,
          'cancer_risk_percentage': 3.6,
          'isHighRisk': false,
          'summary': 'Scanned image shows healthy tissue morphology with no abnormal focal masses or nodules.',
          'recommendations': '• Perform regular self-examinations.\n• Schedule annual clinical checkups.',
          'confidenceScore': 0.964,
        };
      }

      if (_selectedCategory == 'Uterine' && (aiResult['is_valid_uterine'] == false || aiResult['success'] == false)) {
        final String errorMsg = aiResult['error'] ??
            'Non-medical image detected. Please upload an authentic Pelvic Ultrasound (TVS) or H&E Histopathology scan.';
        _showInvalidScanDialog(errorMsg, category: 'Uterine');
        return;
      } else if (_selectedCategory == 'Breast' && (aiResult['is_valid_breast'] == false || aiResult['success'] == false)) {
        final String errorMsg = aiResult['error'] ??
            'Non-medical image detected. Please upload an authentic Mammogram or Breast Ultrasound image.';
        _showInvalidScanDialog(errorMsg, category: 'Breast');
        return;
      } else if (_selectedCategory == 'Lung' && (aiResult['is_valid_lung'] == false || aiResult['success'] == false)) {
        final String errorMsg = aiResult['error'] ??
            'Non-radiological image detected. Please upload an authentic Chest X-Ray or Thoracic CT scan.';
        _showInvalidScanDialog(errorMsg, category: 'Lung');
        return;
      } else if (_selectedCategory == 'Skin' && (aiResult['is_valid_skin'] == false || aiResult['success'] == false)) {
        final String errorMsg = aiResult['error'] ??
            'Non-skin image detected. Please upload a clear photo of human skin or a skin lesion.';
        _showInvalidScanDialog(errorMsg, category: 'Skin');
        return;
      }

      final String finalImageUrl = downloadUrl ?? (_imageFile?.path ?? 'scan_upload');
      await ScanService.saveScanRecord(
        cancerCategory: _selectedCategory,
        result: aiResult['riskLevel'] ?? aiResult['risk_level'] ?? 'Analyzed',
        confidence: (aiResult['confidenceScore'] ?? aiResult['confidence'] ?? 0.85).toDouble(),
        imageUrl: finalImageUrl,
        diagnosis: aiResult['diagnosis'] ?? '$_selectedCategory Scan',
        summary: aiResult['summary'] ?? '',
      );

      if (!mounted) return;
      _showSnackBar('Scan complete! $_selectedCategory Cancer Report generated.');
      _showResultsDialog(aiResult);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('An error occurred during scan: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInvalidScanDialog(String message, {String category = 'Skin'}) {
    String guideText;
    if (category == 'Uterine') {
      guideText = 'Requirements for AI Uterine Cancer Screening:\n'
          '• Must be a real Pelvic / Transvaginal Ultrasound (TVS) or H&E Histopathology biopsy scan\n'
          '• Avoid selfies, colorful drawings, text, or non-medical images\n'
          '• Ensure clear contrast and full endometrial/myometrial cavity visibility';
    } else if (category == 'Breast') {
      guideText = 'Requirements for AI Breast Cancer Screening:\n'
          '• Must be a real Mammogram (CC/MLO view) or Breast Ultrasound image\n'
          '• Avoid selfies, colorful drawings, text, or non-medical images\n'
          '• Ensure clear contrast and full fibroglandular quadrant visibility';
    } else if (category == 'Lung') {
      guideText = 'Requirements for AI Lung Cancer Screening:\n'
          '• Must be a real Chest X-Ray (PA or AP view) or Thoracic CT scan\n'
          '• Avoid selfies, natural scenery, text, or non-medical images\n'
          '• Ensure clear contrast and full bilateral lung field visibility';
    } else {
      guideText = 'Requirements for AI Skin Cancer Screening:\n'
          '• Must be a real, close-up photo of human skin, mole, or lesion\n'
          '• Avoid photos of objects, text, animals, or general backgrounds\n'
          '• Ensure good lighting and in-focus capture';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Invalid Image Rejected',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                guideText,
                style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9181F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showResultsDialog(Map<String, dynamic> aiResult) {
    final bool isHighRisk = aiResult['isHighRisk'] ?? aiResult['is_high_risk'] ?? false;
    final double cancerPercentage = (aiResult['cancer_risk_percentage'] ?? aiResult['percentage'] ?? 50.0).toDouble();
    final String riskLevel = aiResult['riskLevel'] ?? aiResult['risk_level'] ?? (isHighRisk ? 'High Risk' : 'Low Risk');
    final String diagnosis = aiResult['diagnosis'] ?? '$_selectedCategory Scan Analyzed';
    final String? birads = aiResult['birads'] ?? aiResult['birads_category'];
    final String? figo = aiResult['figo'] ?? aiResult['figo_stage'];
    final String summary = aiResult['summary'] ?? '';
    final String recommendations = aiResult['recommendations'] ?? '';
    final Map<String, dynamic>? abcde = aiResult['abcde'] != null ? Map<String, dynamic>.from(aiResult['abcde']) : null;
    final Map<String, dynamic>? radFeatures = (aiResult['radiological_features'] ?? aiResult['radiologicalFeatures']) != null
        ? Map<String, dynamic>.from(aiResult['radiological_features'] ?? aiResult['radiologicalFeatures'])
        : null;
    final Map<String, dynamic>? probabilities = aiResult['probabilities'] != null ? Map<String, dynamic>.from(aiResult['probabilities']) : null;

    Color statusColor = isHighRisk ? const Color(0xFFDC2626) : const Color(0xFF10B981);
    Color statusBgColor = isHighRisk ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5);
    Color statusBorderColor = isHighRisk ? const Color(0xFFFECACA) : const Color(0xFFA7F3D0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: statusBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isHighRisk ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                color: statusColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$_selectedCategory Cancer AI Report',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Risk Status Indicator
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusBorderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isHighRisk ? Icons.error_outline : Icons.shield_outlined,
                        color: statusColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          riskLevel,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '$_selectedCategory Cancer Risk / Chance:',
                              style: const TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${cancerPercentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (cancerPercentage / 100.0).clamp(0.0, 1.0),
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isHighRisk
                            ? (_selectedCategory == 'Uterine'
                            ? 'High probability of malignant endometrial neoplasm / suspicious atypical invasion.'
                            : (_selectedCategory == 'Breast'
                            ? 'High probability of malignant breast neoplasm / suspicious BI-RADS lesion.'
                            : (_selectedCategory == 'Lung'
                            ? 'High probability of malignant pulmonary neoplasm / suspicious cells.'
                            : 'High probability of malignant skin lesion / suspicious cells.')))
                            : (_selectedCategory == 'Uterine'
                            ? 'Low probability of malignancy. Findings consistent with benign / normal uterine endometrium.'
                            : (_selectedCategory == 'Breast'
                            ? 'Low probability of malignancy. Findings consistent with benign / normal breast tissue.'
                            : (_selectedCategory == 'Lung'
                            ? 'Low probability of malignancy. Findings consistent with normal lung scan.'
                            : 'Low probability of malignancy. Findings consistent with benign skin lesion.'))),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (figo != null && figo.isNotEmpty) ...[
                  const Text(
                    'FIGO Assessment / Clinical Staging:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF9C3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE047)),
                    ),
                    child: Text(
                      figo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF854D0E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (birads != null && birads.isNotEmpty) ...[
                  const Text(
                    'BI-RADS Assessment Category:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFBCFE8)),
                    ),
                    child: Text(
                      birads,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF9D174D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                const Text(
                  'Primary Diagnostic Classification:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  diagnosis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isHighRisk ? const Color(0xFF991B1B) : const Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 14),
                if (_selectedCategory == 'Uterine' && radFeatures != null && radFeatures.isNotEmpty) ...[
                  const Text(
                    'Pelvic Sonographic & Histopathology Features:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow('Endometrial Thickness', radFeatures['endometrial_thickness'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Junctional Infiltration', radFeatures['junctional_infiltration'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Glandular Crowding / Atypia', radFeatures['glandular_crowding'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Mass Heterogeneity', radFeatures['mass_heterogeneity'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Cavitary / Pelvic Fluid', radFeatures['cavitary_fluid'] ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (_selectedCategory == 'Breast' && radFeatures != null && radFeatures.isNotEmpty) ...[
                  const Text(
                    'Mammographic & Sonographic Features:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow('Microcalcifications', radFeatures['microcalcifications'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Margin Spiculation', radFeatures['margin_spiculation'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Mass Attenuation', radFeatures['mass_attenuation'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Architectural Distortion', radFeatures['architectural_distortion'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Texture & Shadowing', radFeatures['tissue_heterogeneity'] ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (_selectedCategory == 'Lung' && radFeatures != null && radFeatures.isNotEmpty) ...[
                  const Text(
                    'Radiological & CT Feature Metrics:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow('Nodule Attenuation', radFeatures['nodule_attenuation'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Spiculation Index', radFeatures['spiculation_index'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Mass / Opacity Ratio', radFeatures['mass_volume_ratio'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Internal Texture / Cavitation', radFeatures['tissue_heterogeneity'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('Bilateral Symmetry', radFeatures['bilateral_symmetry'] ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (_selectedCategory == 'Skin' && abcde != null && abcde.isNotEmpty) ...[
                  const Text(
                    'Dermatological ABCDE Criteria:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow('A (Asymmetry)', abcde['asymmetry'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('B (Border)', abcde['border_irregularity'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('C (Color)', abcde['color_variation'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('D (Diameter)', abcde['diameter_risk'] ?? 'N/A'),
                        const Divider(height: 10),
                        _buildFeatureRow('E (Evolution/Texture)', abcde['texture_roughness'] ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (probabilities != null && probabilities.isNotEmpty) ...[
                  const Text(
                    'Diagnostic Probabilities Breakdown:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  ...probabilities.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            e.key,
                            style: const TextStyle(fontSize: 11, color: Colors.black87),
                          ),
                        ),
                        Text(
                          '${e.value}%',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 14),
                ],
                if (summary.isNotEmpty) ...[
                  const Text(
                    'Key Clinical Findings & Observations:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    summary,
                    style: const TextStyle(color: Colors.black87, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                ],
                if (recommendations.isNotEmpty) ...[
                  const Text(
                    'Recommended Next Steps:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recommendations,
                    style: const TextStyle(color: Colors.black87, fontSize: 12, height: 1.4),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9181F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text('Close Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String get _uploadTitle {
    if (_selectedCategory == 'Lung') {
      return 'Upload Chest X-Ray or CT Scan';
    } else if (_selectedCategory == 'Skin') {
      return 'Upload Skin Photo for Screening';
    } else {
      return 'Upload $_selectedCategory Scan';
    }
  }

  String get _uploadSubtitle {
    if (_selectedCategory == 'Lung') {
      return 'Supported: Chest X-Ray (PA/AP), Thoracic CT Scan (JPG, PNG)';
    } else if (_selectedCategory == 'Skin') {
      return 'Supported: High-resolution clear skin lesion photo (JPG, PNG)';
    } else {
      return 'Supported: High-resolution medical scan (JPG, PNG)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_selectedCategory.toUpperCase()} CANCER AI DETECTION'),
        backgroundColor: const Color(0xFF9181F4),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Target Selection Dropdown
            Card(
              elevation: 0,
              color: const Color(0xFFF3EEFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Target Area:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9181F4)),
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              '$category Cancer',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9181F4),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                              _imageFile = null;
                              _imageBytes = null;
                              _pickedXFile = null;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: const Color(0xFFF8F5FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: const Color(0xFF9181F4).withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9181F4).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _selectedCategory == 'Lung' ? Icons.air : Icons.sanitizer_outlined,
                        color: const Color(0xFF9181F4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_selectedCategory.toUpperCase()} CANCER AI DETECTION',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _categoryDescription,
                            style: const TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFAFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEADBFF)),
              ),
              child: Column(
                children: [
                  if (!_hasImage) ...[
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 60,
                      color: Color(0xFF9181F4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _uploadTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _uploadSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb && _imageBytes != null
                          ? Image.memory(
                        _imageBytes!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : (_imageFile != null
                          ? Image.file(
                        _imageFile!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : (_imageBytes != null
                          ? Image.memory(
                        _imageBytes!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : const SizedBox.shrink())),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => setState(() {
                        _imageFile = null;
                        _imageBytes = null;
                        _pickedXFile = null;
                      }),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Change Image'),
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF9181F4)),
                    ),
                  ],
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          label: const Text('Camera', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9181F4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library, color: Color(0xFF9181F4)),
                          label: const Text('Gallery', style: TextStyle(color: Color(0xFF9181F4))),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFF9181F4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _runAIDetectionScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9181F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'AI Diagnostic Server Analyzing...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                    : const Text(
                  'Run AI Detection Scan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
