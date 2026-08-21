import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Future<void> _dialNumber(BuildContext context, String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not dial $number')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF8C80E8);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
    isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FA);
    final cardColor =
    isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor =
    isDark ? Colors.white : Colors.black;
    final secondaryTextColor =
    isDark ? Colors.grey.shade400 : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'ABOUT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              cardColor: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Our Mission",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "At CANCER DETECTION, our mission is to redefine early "
                        "cancer screening by harmonizing advanced artificial "
                        "intelligence with expert clinical care.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "4+",
                    "Cancer Types Analyzed",
                    Icons.analytics,
                    primaryColor,
                    cardColor,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Ahmedabad",
                    "Primary Care Hub",
                    Icons.location_on,
                    primaryColor,
                    cardColor,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "24/7",
                    "AI Availability",
                    Icons.access_time_filled,
                    primaryColor,
                    cardColor,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Key Capabilities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureTile(
              icon: Icons.psychology_outlined,
              title: "Multi-Model AI Screening",
              subtitle:
              "Engineered for breast, lung, skin, and uterine analysis.",
              color: primaryColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardColor: cardColor,
              isDark: isDark,
            ),
            _buildFeatureTile(
              icon: Icons.local_hospital_outlined,
              title: "Oncologist Directory",
              subtitle:
              "Connecting users directly with specialists in Ahmedabad.",
              color: primaryColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardColor: cardColor,
              isDark: isDark,
            ),
            _buildFeatureTile(
              icon: Icons.security_outlined,
              title: "Privacy First",
              subtitle:
              "Your health images and questionnaire data are strictly encrypted.",
              color: primaryColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardColor: cardColor,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF332B10)
                    : Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade700,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Medical Disclaimer",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "This app provides preliminary AI-based risk "
                              "assessments for educational purposes. It is not "
                              "a clinical diagnosis. Always consult a certified "
                              "medical practitioner.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              cardColor: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Need Immediate Help?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Reach out to official helpline services for guidance:",
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _dialNumber(context, '1800221951'), // DIALS NOW
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "National Cancer Helpline (1800-22-1951)",
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

  Widget _buildSectionCard({
    required Widget child,
    required Color cardColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStatCard(
      String value,
      String label,
      IconData icon,
      Color color,
      Color cardColor,
      Color textColor,
      Color secondaryTextColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required Color secondaryTextColor,
    required Color cardColor,
    required bool isDark,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
