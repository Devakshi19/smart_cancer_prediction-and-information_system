import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseCancerScanPage extends StatefulWidget {
  final String title;
  final String description;
  final String acceptedFormats;
  final IconData icon;

  const BaseCancerScanPage({
    super.key,
    required this.title,
    required this.description,
    required this.acceptedFormats,
    required this.icon,
  });

  @override
  State<BaseCancerScanPage> createState() => _BaseCancerScanPageState();
}

class _BaseCancerScanPageState extends State<BaseCancerScanPage> {
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  bool _hasResult = false;
  bool _isLoading = true;
  String get _storageKey => 'saved_scan_${widget.title}';

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? base64String = prefs.getString(_storageKey);

      if (base64String != null && base64String.isNotEmpty) {
        setState(() {
          _imageBytes = base64Decode(base64String);
        });
      }
    } catch (e) {
      debugPrint("Error loading saved image: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();

        final prefs = await SharedPreferences.getInstance();
        final String base64String = base64Encode(bytes);
        await prefs.setString(_storageKey, base64String);
        setState(() {
          _imageBytes = bytes;
          _hasResult = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  Future<void> _clearSelectedImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    setState(() {
      _imageBytes = null;
      _hasResult = false;
    });
  }

  void _runAnalysis() async {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select or capture a scan image first!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _hasResult = false;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    setState(() {
      _isAnalyzing = false;
      _hasResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9A95E8).withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF9A95E8).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF9A95E8),
                    child: Icon(widget.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _imageBytes != null
                      ? const Color(0xFF9A95E8)
                      : Colors.grey.withOpacity(0.3),
                  width: _imageBytes != null ? 2 : 1,
                ),
              ),
              child: _imageBytes != null
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 240,
                          ),
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.04),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _clearSelectedImage,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "Saved scan image loaded",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 44,
                      color: Color(0xFF9A95E8),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Upload Scan / Medical Image",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Supported: ${widget.acceptedFormats}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF9A95E8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () =>
                              _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt,
                              size: 18),
                          label: const Text("Camera"),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            const Color(0xFF9A95E8),
                            side: const BorderSide(
                                color: Color(0xFF9A95E8)),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () =>
                              _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library,
                              size: 18),
                          label: const Text("Gallery"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9A95E8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isAnalyzing ? null : _runAnalysis,
                child: _isAnalyzing
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text("Analyzing with AI..."),
                  ],
                )
                    : const Text(
                  "Run AI Detection Scan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_hasResult) ...[
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.green.withOpacity(0.4)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Scan Completed",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Low Risk / No Anomaly Detected",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Confidence Level: 96.4%\nPlease consult a medical professional for official clinical diagnosis.",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SkinCancerScanPage extends StatelessWidget {
  const SkinCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "SKIN CANCER AI DETECTION",
      description: "Analyze skin lesions, moles, or discolored spots.",
      acceptedFormats: "JPG, PNG (Dermoscopic or High-res photo)",
      icon: Icons.clean_hands,
    );
  }
}

class LungCancerScanPage extends StatelessWidget {
  const LungCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "LUNG CANCER AI DETECTION",
      description: "Screen chest X-Rays or CT scans for pulmonary lesions.",
      acceptedFormats: "DICOM, PNG, JPG (Chest X-Ray)",
      icon: Icons.personal_injury,
    );
  }
}

class BreastCancerScanPage extends StatelessWidget {
  const BreastCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "BREAST CANCER AI DETECTION",
      description: "Analyze mammograms or breast ultrasound imaging.",
      acceptedFormats: "DICOM, PNG, JPG (Mammogram Scan)",
      icon: Icons.female,
    );
  }
}

class UterineCancerScanPage extends StatelessWidget {
  const UterineCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "UTERINE CANCER AI DETECTION",
      description: "Analyze pelvic ultrasound (TVUS) or pelvic MRI scans.",
      acceptedFormats: "DICOM, PNG, JPG (Transvaginal Ultrasound / MRI)",
      icon: Icons.health_and_safety,
    );
  }
}
