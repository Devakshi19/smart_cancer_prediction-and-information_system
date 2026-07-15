import 'package:flutter/material.dart';

class Help_Page extends StatelessWidget {
  const Help_Page({super.key});

  Widget helpCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.help, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: const Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          helpCard(
            "How to use the app?",
            "Upload an image and let AI analyze it.",
          ),
          helpCard(
            "Need Support?",
            "Email: support@cancerdetection.com",
          ),
          helpCard(
            "Frequently Asked Questions",
            "View answers to common questions.",
          ),
        ],
      ),
    );
  }
}
