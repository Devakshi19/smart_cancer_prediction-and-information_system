import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRIVACY POLICY",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Welcome to Privacy policy Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
