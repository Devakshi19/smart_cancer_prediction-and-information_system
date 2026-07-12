import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HELP & FEEDBACK",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Welcome to Help & Feedback Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
