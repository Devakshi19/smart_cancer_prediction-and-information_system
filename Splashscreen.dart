import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'user_session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      try {
        await FirebaseAuth.instance.signOut();
        await UserSession.logout();
        await GoogleSignIn().signOut();
      } catch (e) {
        debugPrint("Error signing out during splash screen: $e");
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 0, 174, 239),
              Color(0xFF8E8CF8),
              Color(0xFF5A78F5),
              Color(0xfcfc5b8f7)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/splash_screen.jpeg",
                            height: 180,
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          "CANCER DETECTION",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Early Detection, Better Tomorrow",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Consolas',
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 60),

                        const SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Initializing AI Model...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
