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
        title: const Text("Contact Us"),
        backgroundColor: const Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          contactTile(Icons.email, "Email", "support@cancerdetection.com"),
          contactTile(Icons.phone, "Phone", "+91 9876543210"),
          contactTile(
              Icons.location_on, "Address", "Indus University, Ahmedabad"),
        ],
      ),
    );
  }
}
