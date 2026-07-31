import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/main.dart';
import 'signup.dart';
import 'user_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Email and Password are required", Colors.redAccent);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        if (!mounted) return;
        await _showUnverifiedDialog(user);
        await FirebaseAuth.instance.signOut();
        return;
      }
      final userName =
      (user?.displayName != null && user!.displayName!.isNotEmpty)
          ? user.displayName!
          : 'User';

      await UserSession.saveUser(
        name: userName,
        email: user?.email ?? email,
      );

      if (!mounted) return;
      _showSnackBar("Login Successful", Colors.green);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage = "Login Failed";
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMessage = "Incorrect email address or password.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is badly formatted.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "This account has been disabled.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many failed attempts. Please wait a few minutes before trying again.";
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      _showSnackBar(errorMessage, Colors.redAccent);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar("An unexpected error occurred: $e", Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showUnverifiedDialog(User user) async {
    int cooldownSeconds = 0;
    Timer? timer;
    bool isResending = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {

          void startCooldown() {
            setDialogState(() => cooldownSeconds = 60);
            timer?.cancel();
            timer = Timer.periodic(const Duration(seconds: 1), (t) {
              if (cooldownSeconds > 0) {
                setDialogState(() => cooldownSeconds--);
              } else {
                t.cancel();
              }
            });
          }

          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 28),
                SizedBox(width: 8),
                Text("Email Not Verified"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your email address has not been verified yet.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.mark_email_unread, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "⚠️ WARNING: Please check your SPAM, JUNK, or PROMOTIONS folder if you cannot find the verification link in your inbox.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Click the link inside that email to enable your account, then try logging in again.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: (isResending || cooldownSeconds > 0)
                    ? null
                    : () async {
                  setDialogState(() => isResending = true);
                  try {
                    await user.sendEmailVerification();
                    if (!ctx.mounted) return;
                    _showSnackBar(
                      "Verification email resent! Check your Inbox and SPAM folder.",
                      Colors.blue,
                    );
                    startCooldown(); // Lock button for 60 seconds
                  } on FirebaseAuthException catch (e) {
                    if (!ctx.mounted) return;
                    if (e.code == 'too-many-requests') {
                      _showSnackBar(
                        "Firebase rate-limit reached. An email was already sent recently — please wait 1–2 minutes before requesting another.",
                        Colors.redAccent,
                      );
                      startCooldown(); // Force cooldown on rate-limit
                    } else {
                      _showSnackBar(
                        e.message ?? "Failed to resend email.",
                        Colors.redAccent,
                      );
                    }
                  } catch (e) {
                    if (!ctx.mounted) return;
                    _showSnackBar("Error: $e", Colors.redAccent);
                  } finally {
                    if (ctx.mounted) {
                      setDialogState(() => isResending = false);
                    }
                  }
                },
                child: isResending
                    ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(
                  cooldownSeconds > 0
                      ? "Wait (${cooldownSeconds}s)"
                      : "Resend Email",
                  style: TextStyle(
                    color: cooldownSeconds > 0
                        ? Colors.grey
                        : const Color(0xFF9A95E8),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9A95E8),
                ),
                onPressed: () {
                  timer?.cancel();
                  Navigator.pop(ctx);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF9A95E8),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Color(0xFF9A95E8),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9A95E8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
