import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TERMS & CONDITION",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold
            )),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
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
