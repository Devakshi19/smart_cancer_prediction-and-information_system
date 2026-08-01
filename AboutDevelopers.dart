import 'package:flutter/material.dart';

class AboutDevelopersPage extends StatelessWidget {
  const AboutDevelopersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        title: const Text(
          "ABOUT DEVELOPERS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF9C99E3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          DeveloperCard(
            image: "assets/Devuu.png",
            name: "Panchal Devakshi",
            college: "Indus University, Rancharda",
            branch: "Information Technology",
            email: "panchaldevakshi1909@gmail.com",
            about:
                "I am a final-year B.Tech IT student specializing in mobile UI design and Flutter frontend architecture. For this project, I focused on designing intuitive user interfaces, managing app routing, and building reusable widgets for screen navigation and medical specialist cards.",
          ),
          SizedBox(height: 18),
          DeveloperCard(
            image: "assets/rachana.jpeg",
            name: "Patel Rachana",
            college: "Indus University, Rancharda",
            branch: "Information Technology",
            email: "rachanait676@gmail.com",
            about:
                "I am a final-year B.Tech IT student passionate about mobile user experience. My main focus in this project involved developing responsive screen layouts, implementing interactive search and filter bars, and standardizing application themes for light and dark modes.",
          ),
          SizedBox(height: 18),
          DeveloperCard(
            image: "assets/Miral.jpg",
            name: "Prajapati Miral",
            college: "Indus University, Rancharda",
            branch: "Information Technology",
            email: "miralprajapati2005@gmail.com",
            about:
                "I am a final-year B.Tech IT student with a strong eye for visual detail. I contributed by building card views, styling medical information sections, integrating custom graphical assets, and ensuring consistent design layouts across various screen sizes.",
          ),
          SizedBox(height: 18),
          DeveloperCard(
            image: "assets/Upagana.jpg",
            name: "Shah Upangna",
            college: "Indus University, Rancharda",
            branch: "Information Technology",
            email: "upagnashah94@gmail.com",
            about:
                "I am a final-year B.Tech IT student focused on backend logic and state management. My key contributions included structuring local specialist database schemas, writing real-time filtering algorithms for search queries, and managing data flows across application screens.",
          ),
          SizedBox(height: 18),
          DeveloperCard(
            image: "assets/Vedashree.jpg",
            name: "Trivedi Vedashree",
            college: "Indus University, Rancharda",
            branch: "Information Technology",
            email: "Vedashreetrivedi123@gmail.com",
            about:
                "I am a final-year B.Tech IT student specializing in software integration and data management. I worked on back-end service integration, API communications, data validation, and handling backend logic for AI detection feature modules.",
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String image;
  final String name;
  final String college;
  final String branch;
  final String email;
  final String about;

  const DeveloperCard({
    super.key,
    required this.image,
    required this.name,
    required this.college,
    required this.branch,
    required this.email,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF9C99E3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        image,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality
                            .high, 
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.school, color: Color(0xFF9C99E3)),
              title: Text(college),
              subtitle: Text(branch),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email, color: Color(0xFF9C99E3)),
              title: Text(email),
            ),
            const SizedBox(height: 6),
            Text(
              about,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
