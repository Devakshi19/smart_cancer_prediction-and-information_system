import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
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
            SizedBox(height: 30),
            Text(
              "At CANCER DETECTION, our mission is profound: to redefine the paradigm of early cancer screening by harmonizing advanced artificial intelligence with the precision of expert clinical care. We believe that early intervention is the cornerstone of improved patient outcomes.\n\n"
              "Our proprietary AI models are meticulously engineered to interpret complex health patterns across breast, lung, skin, and ovarian systems. By delivering immediate, data-driven insights, we offer a preliminary assessment that empowers users to make informed decisions regarding their health.\n\n"
              "Rooted in the heart of Ahmedabad, our platform serves as a vital bridge between initial awareness and professional diagnosis, offering a curated directory of preeminent oncologists and specialists. We provide the clarity you need to navigate your health journey with confidence—ensuring that cutting-edge technology is always anchored by human medical expertise.",
              style: TextStyle(
                fontSize: 17,
                height: 1.9,
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
