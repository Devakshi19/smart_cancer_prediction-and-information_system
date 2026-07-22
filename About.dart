import 'package:flutter/material.dart';
import 'package:project/main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle paragraphStyle = TextStyle(
      fontSize: 15.5,
      height: 1.6, // Improves readability and spacing between lines
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.87),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppState.tr('ABOUT'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: const Color(0xFF9A95E8),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "At CANCER DETECTION, our mission is profound: to redefine the paradigm of early cancer screening by harmonizing advanced artificial intelligence with the precision of expert clinical care. We believe that early intervention is the cornerstone of improved patient outcomes.",
              style: paragraphStyle,
            ),
            const SizedBox(height: 25),
            Text(
              "Our proprietary AI models are meticulously engineered to interpret complex health patterns across breast, lung, skin, and ovarian systems. By delivering immediate, data-driven insights, we offer a preliminary assessment that empowers users to make informed decisions regarding their health.",
              style: paragraphStyle,
            ),
            const SizedBox(height: 25),
            Text(
              "Rooted in the heart of Ahmedabad, our platform serves as a vital bridge between initial awareness and professional diagnosis, offering a curated directory of preeminent oncologists and specialists. We provide the clarity you need to navigate your health journey with confidence—ensuring that cutting-edge technology is always anchored by human medical expertise.",
              style: paragraphStyle,
            ),
          ],
        ),
      ),
    );
  }
}
