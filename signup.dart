import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/main.dart';
import 'login.dart';
import 'user_session.dart';
import 'user_details_input.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String _selectedGender = 'Female';
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Exact Lavender Color Palette
  static const Color primaryColor = Color(0xFF988AF1);
  static const Color darkTextColor = Color(0xFF231F40);
  static const Color subTextColor = Color(0xFF8E8CA3);
  static const Color backgroundColor = Color(0xFFF4F4FA);
  static const Color cardColor = Colors.white;
  static const Color inputFillColor = Color(0xFFF7F6FC);

  bool _isValidEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final age = _ageController.text.trim();
    final phone = _phoneController.text.trim();
    final weight = _weightController.text.trim();
    final height = _heightController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        age.isEmpty ||
        phone.isEmpty ||
        weight.isEmpty ||
        height.isEmpty) {
      _showSnackBar("Please fill in all fields", Colors.redAccent);
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar("Please enter a valid email address", Colors.redAccent);
      return;
    }

    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters long", Colors.redAccent);
      return;
    }

    if (int.tryParse(age) == null) {
      _showSnackBar("Please enter a valid age (numbers only)", Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(
        const Duration(seconds: 12),
        onTimeout: () => throw TimeoutException("Auth request timed out."),
      );

      final user = userCredential.user;

      if (user != null) {
        try {
          await user.updateDisplayName(name);
        } catch (e) {
          debugPrint("Display name failed: $e");
        }

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': name,
            'email': email,
            'phone': phone,
            'age': age,
            'weight': weight,
            'height': height,
            'gender': _selectedGender,
            'createdAt': FieldValue.serverTimestamp(),
          }).timeout(const Duration(seconds: 5));
        } catch (e) {
          debugPrint("Firestore write warning: $e");
        }

        try {
          await user.sendEmailVerification().timeout(const Duration(seconds: 5));
        } catch (e) {
          debugPrint("Email verification error: $e");
        }

        await FirebaseAuth.instance.signOut();
        await UserSession.logout();

        if (mounted) setState(() => _isLoading = false);
        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.mark_email_unread_rounded, color: primaryColor, size: 28),
                SizedBox(width: 10),
                Text("Verify Your Email",
                    style: TextStyle(
                        color: darkTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
            content: Text(
              "Account registered successfully!\n\nA verification link has been sent to:\n\n$email\n\nPlease check your inbox (or spam) and click the link to verify your email before logging in.",
              style: const TextStyle(fontSize: 14, height: 1.4, color: darkTextColor),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text("OK, GO TO LOGIN",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed.";
      if (e.code == 'invalid-email') {
        errorMessage = "The email address is invalid.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "An account already exists with this email.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      _showSnackBar(errorMessage, Colors.redAccent);
    } catch (e) {
      _showSnackBar("Error: $e", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleGoogleSignup() async {
    setState(() => _isLoading = true);
    try {
      UserCredential? userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          if (mounted) setState(() => _isLoading = false);
          return;
        }
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      User? user = userCredential.user;

      if (user != null) {
        final name = user.displayName ?? "User";
        final email = user.email ?? "";

        DocumentSnapshot? doc;
        try {
          doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get()
              .timeout(const Duration(seconds: 5));
        } catch (e) {
          debugPrint("Firestore check error: $e");
        }

        if (!mounted) return;

        if (doc != null && doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          await UserSession.saveUser(
            name: data['name'] ?? name,
            email: data['email'] ?? email,
            phone: data['phone'] ?? '',
            age: data['age'] ?? '',
            weight: data['weight'] ?? '',
            height: data['height'] ?? '',
            gender: data['gender'] ?? 'Female',
          );

          _showSnackBar("Account setup complete!", primaryColor);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => UserDetailsInputPage(
                isGoogleSignUp: true,
                name: name,
                email: email,
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Google Sign-In Failed", Colors.redAccent);
    } catch (e) {
      _showSnackBar("Google Sign-In Error: $e", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Circle Icon Badge
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.18),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 44,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header Titles
              const Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Fill your details to start AI Cancer Detection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 28),

              // White Form Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(fontSize: 15, color: darkTextColor),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            color: primaryColor, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: subTextColor,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: inputFillColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _ageController,
                      label: "Age (Years)",
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Gender Field with black floating label
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      style: const TextStyle(fontSize: 15, color: darkTextColor),
                      decoration: InputDecoration(
                        labelText: "Gender",
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: const Icon(Icons.female_rounded,
                            color: primaryColor, size: 20),
                        filled: true,
                        fillColor: inputFillColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.5),
                        ),
                      ),
                      items: ['Female', 'Male', 'Other']
                          .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _phoneController,
                      label: "Mobile Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _weightController,
                      label: "Weight (e.g. 50 kg)",
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _heightController,
                      label: "Height (e.g. 165 cm)",
                      icon: Icons.unfold_more_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleSignup,
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
                          "CREATE ACCOUNT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: subTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _handleGoogleSignup,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "G",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Continue with Google",
                        style: TextStyle(
                          color: darkTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: darkTextColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: primaryColor, size: 20),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
