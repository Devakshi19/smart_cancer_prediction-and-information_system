import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cancer Detection App"),
        backgroundColor: Colors.indigoAccent,
      ),

      // The Drawer goes here
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {},
            ),
          ],
        ),
      ),

      body: Center(child: Text('Selected Index: $_selectedIndex')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigoAccent,
        child: const Icon(Icons.call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_rounded),
            label: "CONTACT",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "SEARCH"),
        ],
      ),
    );
  }
}
