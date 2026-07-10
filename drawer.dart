import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyDrawerPage()));
}

class MyDrawerPage extends StatelessWidget {
  const MyDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("smart cancer prediction")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(title: const Text('My Profile'), onTap: () {}),
            ListTile(title: const Text('About'), onTap: () {}),
            ListTile(title: const Text('Help & Feedback'), onTap: () {}),
            ListTile(title: const Text('Terms & Conditions'), onTap: () {}),
            ListTile(title: const Text('Log out'), onTap: () {}),
          ],
        ),
      ),
      body: const Center(child: Text("Home Page")),
    );
  }
}
