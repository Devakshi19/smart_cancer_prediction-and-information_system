import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    const primaryColor = Color.fromARGB(255, 156, 153, 227);
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E24) : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "HELP & FEEDBACK",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.favorite_outline,
              title: "Our Commitment",
              content:
              "We recognize that health-related concerns can be both sensitive and complex. Our support ecosystem is designed to provide you with seamless guidance throughout your journey.",
              cardColor: cardColor,
              titleColor: titleColor,
              textColor: textColor,
              accentColor: primaryColor,
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.lightbulb_outline,
              title: "Immediate Assistance",
              content:
              "For immediate assistance with our AI assessment tools, account synchronization, or report generation, please refer to the in-app guidance and FAQs available throughout the application.",
              cardColor: cardColor,
              titleColor: titleColor,
              textColor: textColor,
              accentColor: primaryColor,
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.email_outlined,
              title: "Personalized Support",
              content:
              "Should you require personalized support or wish to report a technical concern, please reach out to us. Our team is dedicated to responding to all inquiries within 24–48 business hours.",
              cardColor: cardColor,
              titleColor: titleColor,
              textColor: textColor,
              accentColor: primaryColor,
              actionWidget: Container(
                margin: const EdgeInsets.only(top: 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline, size: 18, color: primaryColor),
                    SizedBox(width: 8),
                    Text(
                      "cancerdetection26@gmail.com",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.rate_review_outlined,
              title: "Continuous Evolution",
              content:
              "We are in a continuous state of evolution, constantly refining our algorithms and interfaces. Your insights are essential; we welcome your feedback via the 'Feedback' portal to help us maintain the gold standard of care that you deserve.",
              cardColor: cardColor,
              titleColor: titleColor,
              textColor: textColor,
              accentColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
    required Color cardColor,
    required Color titleColor,
    required Color textColor,
    required Color accentColor,
    Widget? actionWidget,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: textColor,
              ),
            ),
            if (actionWidget != null) actionWidget,
          ],
        ),
      ),
    );
  }
}
