import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_session.dart';
import 'login.dart';
import '../main.dart';

class UserDetailsInputPage extends StatefulWidget {
  final bool isGoogleSignUp;
  final String name;
  final String email;

  const UserDetailsInputPage({
    super.key,
    required this.isGoogleSignUp,
    required this.name,
    required this.email,
  });

  @override
  State<UserDetailsInputPage> createState() => _UserDetailsInputPageState();
}

class _UserDetailsInputPageState extends State<UserDetailsInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _selectedGender = 'Female';
  bool _isLoading = false;

  void _handleSaveDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      final phone = _phoneController.text.trim();
      final age = _ageController.text.trim();
      final weight = _weightController.text.trim();
      final height = _heightController.text.trim();

      // 1. Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': widget.name,
        'email': widget.email,
        'phone': phone,
        'age': age,
        'weight': weight,
        'height': height,
        'gender': _selectedGender,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Save to Local Session
      await UserSession.saveUser(
        name: widget.name,
        email: widget.email,
        phone: phone,
        age: age,
        weight: weight,
        height: height,
        gender: _selectedGender,
      );

      if (!mounted) return;

      if (widget.isGoogleSignUp) {
        // For Google Signup, navigate directly to HomePage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      } else {
        // For Manual Email/Password Signup:
        // Send verification email
        await user.sendEmailVerification();
        
        // Log out immediately
        await FirebaseAuth.instance.signOut();
        await UserSession.logout();

        if (!mounted) return;

        // Show verification instructions dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.mark_email_unread, color: Color(0xFF9A95E8), size: 28),
                SizedBox(width: 8),
                Text("Verify Your Email"),
              ],
            ),
            content: Text(
              "Profile details saved successfully!\n\nA verification link has been sent to:\n\n${widget.email}\n\nPlease check your inbox (or spam) and click the link to verify your email before logging in.",
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9A95E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text("OK, GO TO LOGIN", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving details: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "COMPLETE PROFILE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF9A95E8),
        elevation: 0,
        automaticallyImplyLeading: false, // Prevent backing out to sign up page
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Icon(
                  Icons.assignment_ind_rounded,
                  size: 90,
                  color: Color(0xFF9A95E8),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We need a few more details to set up your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Age Field
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Age (Years)",
                    prefixIcon: const Icon(Icons.cake, color: Color(0xFF9A95E8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9A95E8), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender Field (Dropdown)
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    prefixIcon: Icon(
                      _selectedGender == 'Female'
                          ? Icons.female
                          : _selectedGender == 'Male'
                              ? Icons.male
                              : Icons.wc,
                      color: const Color(0xFF9A95E8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9A95E8), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ['Female', 'Male', 'Other']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value ?? 'Female';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Mobile Number Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.trim().length < 8) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Mobile Number",
                    prefixIcon: const Icon(Icons.phone, color: Color(0xFF9A95E8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9A95E8), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Weight Field
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Weight (e.g., 50 kg)",
                    prefixIcon: const Icon(Icons.monitor_weight, color: Color(0xFF9A95E8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9A95E8), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Height Field
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Height (e.g., 165 cm)",
                    prefixIcon: const Icon(Icons.height, color: Color(0xFF9A95E8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9A95E8), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9A95E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _isLoading ? null : _handleSaveDetails,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "SAVE DETAILS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
