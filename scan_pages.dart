import 'package:flutter/material.dart';

// Base widget template for Cancer Scan Pages
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
    required this.icon, required TextStyle style,
  });

  @override
  State<BaseCancerScanPage> createState() => _BaseCancerScanPageState();
}

class _BaseCancerScanPageState extends State<BaseCancerScanPage> {
  bool _isAnalyzing = false;
  bool _hasResult = false;

  void _runAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _hasResult = false;
    });

    // Simulate AI model inference delay
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
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
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
                            fontSize: 16,
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

            // Image Upload Box
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 50,
                    color: Color(0xFF9A95E8),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Upload Scan / Medical Image",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Supported: ${widget.acceptedFormats}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9A95E8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: const Text("Camera"),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.photo_library, size: 18),
                        label: const Text("Gallery"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Action Button
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

            // Analysis Results Section
            if (_hasResult) ...[
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.4)),
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

// 1. Skin Cancer Scan Screen
class SkinCancerScanPage extends StatelessWidget {
  const SkinCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "SKIN CANCER AI DETECTION",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      description: "Analyze skin lesions, moles, or discolored spots.",
      acceptedFormats: "JPG, PNG (Dermoscopic or High-res photo)",
      icon: Icons.clean_hands,
    );
  }
}

// 2. Lung Cancer Scan Screen
class LungCancerScanPage extends StatelessWidget {
  const LungCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "LUNG CANCER AI DETECTION",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      description: "Screen chest X-Rays or CT scans for pulmonary lesions.",
      acceptedFormats: "DICOM, PNG, JPG (Chest X-Ray)",
      icon: Icons.personal_injury,
    );
  }
}

// 3. Breast Cancer Scan Screen
class BreastCancerScanPage extends StatelessWidget {
  const BreastCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "BREAST CANCER AI DETECTION",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      description: "Analyze mammograms or breast ultrasound imaging.",
      acceptedFormats: "DICOM, PNG, JPG (Mammogram Scan)",
      icon: Icons.female,
    );
  }
}

// 4. Uterine Cancer Scan Screen
class UterineCancerScanPage extends StatelessWidget {
  const UterineCancerScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseCancerScanPage(
      title: "UTERINE CANCER AI DETECTION",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      description: "Analyze pelvic ultrasound (TVUS) or pelvic MRI scans.",
      acceptedFormats: "DICOM, PNG, JPG (Transvaginal Ultrasound / MRI)",
      icon: Icons.health_and_safety,
    );
  }
}