import 'package:flutter/material.dart';

class DonationDetailsPage extends StatelessWidget {
  final String firmName;
  final Map<String, String> donor;

  const DonationDetailsPage({
    super.key,
    required this.firmName,
    required this.donor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Firm: $firmName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Donor Name: ${donor['name']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: ${donor['email']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Message:', style: const TextStyle(fontSize: 16)),
            Text(
              donor['message'] ?? '',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Text('Transaction Proof:', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Text(
                'No image uploaded',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
