import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help & Feedback",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "We recognize that health-related concerns can be both sensitive and complex. Our support ecosystem is designed to provide you with seamless guidance throughout your journey.\n\n"
              "For immediate assistance with our AI assessment tools, account synchronization, or report generation, please refer to the in-app guidance and FAQs available throughout the application.\n\n"
              "Should you require personalized support or wish to report a technical concern, please reach out to us at cancerdetection26@gmail.com Our team is dedicated to responding to all inquiries within 24–48 business hours.\n\n"
              "We are in a continuous state of evolution, constantly refining our algorithms and interfaces. Your insights are essential to this process; we welcome your feedback via the 'Feedback' portal to help us maintain the gold standard of care that you deserve.",
              style: TextStyle(
                fontSize: 18,
                height: 1.7,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
