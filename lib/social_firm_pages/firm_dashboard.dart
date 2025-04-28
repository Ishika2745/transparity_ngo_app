import 'package:flutter/material.dart';
import 'package:transparity_app/social_firm_pages/firm_community_screen.dart';
import 'package:transparity_app/social_firm_pages/firm_donation_page.dart';
import 'package:transparity_app/social_firm_pages/firm_home_page.dart';

class FirmDashboardScreen extends StatefulWidget {
  const FirmDashboardScreen({super.key});

  @override
  _FirmDashboardScreenState createState() => _FirmDashboardScreenState();
}

class _FirmDashboardScreenState extends State<FirmDashboardScreen> {
  int _selectedIndex = 1; // Default to 'Home'

  final List<Widget> _pages = [
    FirmDonationScreen(),
    const FirmHomePage(),
    const FirmCommunityScreen(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: const Text('Transparity', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF004B8D),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF004B8D),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Donations'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
        ],
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Social Firm", style: TextStyle(fontSize: 18)),
            accountEmail: const Text("firm@gmail.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            decoration: const BoxDecoration(color: Color(0xFF004B8D)),
          ),
          _buildDrawerButton(context, Icons.history, "History"),
          _buildDrawerButton(context, Icons.help, "Help & FAQ"),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  Widget _buildDrawerButton(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: () => Navigator.pop(context), // Close drawer
    );
  }
}