import 'package:flutter/material.dart';
import 'editprofile.dart';
import 'user_session.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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

  // Load user details from UserSession
  Future<void> _loadProfileData() async {
    final userData = await UserSession.getUser();
    setState(() {
      name = userData['name']!;
      email = userData['email']!;
      phone = userData['phone']!;
      age = userData['age']!;
      weight = userData['weight']!;
      height = userData['height']!;
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
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/profile.png"),
            ),
            const SizedBox(height: 10),
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
                      height: height,
                    ),
                  ),
                );

                if (result != null) {
                  // Save edited info to UserSession
                  await UserSession.saveUser(
                    name: result["name"],
                    email: result["email"],
                    phone: result["phone"],
                    age: result["age"],
                    weight: result["weight"],
                    height: result["height"],
                  );

                  // Update UI
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
