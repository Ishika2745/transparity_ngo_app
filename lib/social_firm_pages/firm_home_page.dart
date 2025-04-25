import 'package:flutter/material.dart';
import 'add_request.dart';
//lder for the Home Screen
class FirmHomePage extends StatelessWidget {
  const FirmHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dotted Background
        Container(
          decoration: const BoxDecoration(

          ),
        ),
        // Main Content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large Request QR Code Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddRequestScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004B8D), // Peacock Blue Button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Requests QR ',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Illustration Image

          ],
        ),
      ],
    );
  }
}