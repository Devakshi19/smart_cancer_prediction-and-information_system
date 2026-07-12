import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cancer Detection App"),
          backgroundColor: Colors.indigoAccent,
        ),
        drawer: Drawer(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.indigoAccent),
                    child: Text(
                      'Menu Options',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Feedback'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Terms & Conditions'),
                    onTap: () {},
                  ),
                  const Divider(), // Horizontal separator
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                    onTap: () {},
                  ),
                ],
              ),
            )));
  }
}
