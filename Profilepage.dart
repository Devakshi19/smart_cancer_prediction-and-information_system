import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editprofile.dart';
import 'user_session.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ProfilePage({super.key, this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Loading...";
  String email = "Loading...";
  String age = "";
  String gender = "Female";
  String phone = "";
  String weight = "";
  String height = "";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final userData = await UserSession.getUser();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      name = firebaseUser?.displayName ?? userData['name'] ?? "Guest User";
      email = firebaseUser?.email ?? userData['email'] ?? "guest@example.com";
      phone = userData['phone'] ?? "+91 XXXXX XXXXX";
      age = userData['age'] ?? "21 Years";
      weight = userData['weight'] ?? "50 kg";
      height = userData['height'] ?? "165 cm";
    });
  }

  Widget buildTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_done, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Connected with Firebase",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildTile(Icons.person, "Name", name),
            buildTile(Icons.cake, "Age", age),
            buildTile(Icons.female, "Gender", gender),
            buildTile(Icons.phone, "Mobile", phone),
            buildTile(Icons.monitor_weight, "Weight", weight),
            buildTile(Icons.height, "Height", height),
            const SizedBox(height: 15),
            const Divider(),
            buildTile(Icons.analytics, "Total Scans", "08"),
            buildTile(Icons.check_circle, "Completed Tests", "08"),
            buildTile(Icons.calendar_today, "Last Scan", "12 July 2026"),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      name: name,
                      email: email,
                      phone: phone,
                      age: age,
                      weight: weight,
                      height: height, gender: '',
                    ),
                  ),
                );

                if (result != null) {
                  await UserSession.saveUser(
                    name: result["name"],
                    email: result["email"],
                    phone: result["phone"],
                    age: result["age"],
                    weight: result["weight"],
                    height: result["height"],
                  );
                  final firebaseUser = FirebaseAuth.instance.currentUser;
                  if (firebaseUser != null) {
                    try {
                      if (result["name"] != firebaseUser.displayName) {
                        await firebaseUser.updateDisplayName(result["name"]);
                      }
                      if (result["email"] != firebaseUser.email) {
                        await firebaseUser.verifyBeforeUpdateEmail(result["email"]);
                      }
                    } catch (e) {
                      debugPrint("Failed to update Firebase profile: $e");
                    }
                  }
                  _loadProfileData();
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
