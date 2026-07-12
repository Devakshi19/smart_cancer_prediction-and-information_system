import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: const Center(
        child: Text(
          "Welcome to Terms & Conditions Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
