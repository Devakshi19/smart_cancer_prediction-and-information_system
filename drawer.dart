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
              onTap: () {
                // Add navigation to Profile screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                // Add navigation to About screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Feedback'),
              onTap: () {
                // Add navigation to Help screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms & Conditions'),
              onTap: () {
                // Add navigation to Terms screen
              },
            ),
            const Divider(), // Horizontal separator
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                // Add logout logic
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigoAccent,
        child: const Icon(Icons.call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.indigoAccent),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_rounded, color: Colors.indigoAccent),
            label: "CONTACT",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.indigoAccent),
            label: "SEARCH",
          ),
        ],
      ),
    );
  }
}
