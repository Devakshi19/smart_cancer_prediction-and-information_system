import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect theme mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme Color Palette
    const primaryAccent = Color.fromARGB(255, 156, 153, 227);
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E24) : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "CONTACT US",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color.fromARGB(255, 156, 153, 227),
            child: Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 45,
            ),
          ),
          Center(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "Contact Our Support Team",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "We're here to help you 24/7",
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 1. Email Tile
            _buildContactTile(
              icon: Icons.email,
              title: "Email",
              subtitle: "cancerdetection26@gmail.com",
              cardColor: cardColor,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              iconColor: primaryAccent,
            ),

            // 2. Phone Tile
            _buildContactTile(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "+91 xxxxxxxxxx",
              cardColor: cardColor,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              iconColor: primaryAccent,
            ),

            // 3. Website Tile
            _buildContactTile(
              icon: Icons.language,
              title: "Website",
              subtitle: "www.cancerdetection.com",
              cardColor: cardColor,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              iconColor: primaryAccent,
            ),

            // 4. Emergency Helpline Tile
            _buildContactTile(
              icon: Icons.medical_services,
              title: "Emergency Helpline",
              subtitle: "108",
              cardColor: cardColor,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              iconColor: primaryAccent,
            ),

            const SizedBox(height: 12),

            // About Us Card
            _buildAboutUsCard(
              cardColor: cardColor,
              titleColor: titleColor,
              textColor: subtitleColor,
            ),

            const SizedBox(height: 12),

            // Developed By Card
            _buildDevelopedByCard(
              cardColor: cardColor,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              iconColor: primaryAccent,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Contact Info Tile
  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
    required Color iconColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: About Us
  Widget _buildAboutUsCard({
    required Color cardColor,
    required Color titleColor,
    required Color textColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Us",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Our Cancer Detection application uses Artificial Intelligence to assist users in identifying possible cancer risks from medical images. This app is intended for educational and screening support only and should not replace professional medical advice.",
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Developed By
  Widget _buildDevelopedByCard({
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
    required Color iconColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.code,
                color: iconColor,
                size: 28,
              ),
              const SizedBox(height: 10),
              Text(
                "Developed By",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "B.Tech IT Students",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Indus University",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
