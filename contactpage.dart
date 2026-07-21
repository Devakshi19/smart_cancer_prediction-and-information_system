import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Widget contactTile(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CONTACT US",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
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
          const SizedBox(height: 15),
          const Center(
            child: Text(
              "Contact Our Support Team",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text(
              "We're here to help you 24/7",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 25),
          contactTile(
            Icons.email,
            "Email",
            "cancerdetection26@gmail.com",
          ),
          contactTile(
            Icons.phone,
            "Phone",
            "+91 xxxxxxxxxx",
          ),
          contactTile(
            Icons.language,
            "Website",
            "www.cancerdetection.com",
          ),
          contactTile(
            Icons.local_hospital,
            "Emergency Helpline",
            "108",
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Our Cancer Detection application uses Artificial Intelligence "
                    "to assist users in identifying possible cancer risks from "
                    "medical images. This app is intended for educational and "
                    "screening support only and should not replace professional "
                    "medical advice.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: Color.fromARGB(255, 240, 236, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Icon(
                    Icons.code,
                    color: Colors.deepPurple,
                    size: 35,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Developed By",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "B.Tech IT Students\nIndus University",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
