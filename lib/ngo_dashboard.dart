import 'package:flutter/material.dart';
import 'donations_screen.dart';
import 'ngo_community_screen.dart';
import 'home_page.dart';

class NgoDashboardScreen extends StatefulWidget {
  const NgoDashboardScreen({super.key});

  @override
  _NgoDashboardScreenState createState() => _NgoDashboardScreenState();
}

class _NgoDashboardScreenState extends State<NgoDashboardScreen> {
  int _selectedIndex = 1; // Default to 'Home'

  final List<Widget> _pages = [
    const DonationsScreen(),
    const HomeScreen(),
    const NgoCommunityScreen(),
  ];


  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Row(
          children: [

            const SizedBox(width: 10),
            const Text(
              'Transparity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF004B8D), // Peacock Blue
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification click
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Change screens dynamically

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF004B8D),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
        ],
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Ngo Foundation", style: TextStyle(fontSize: 18)),
            accountEmail: const Text("ngofoundation@gmail.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF004B8D),
            ),
          ),
          _buildDrawerButton(context, Icons.history, "History"),
          _buildDrawerButton(context, Icons.event, "Activity"),
          _buildDrawerButton(context, Icons.settings, "Settings"),
          _buildDrawerButton(context, Icons.help, "Help & FAQ"),

          const Spacer(), // Push Logout Button to Bottom

          // Logout Button at Bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red logout button
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Logout Function
  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }


  Widget _buildDrawerButton(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context); // Close drawer
          // TODO: Add navigation logic for respective pages
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF004B8D),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
