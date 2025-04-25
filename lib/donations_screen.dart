import 'package:flutter/material.dart';
import 'donation_details_page.dart'; // Import the details page

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> donations = [
      {'name': 'Green Social Firm', 'amount': '\$500'},
      {'name': 'Aravind Social Firm', 'amount': '\$300'},
      {'name': 'Helping Hand Social Firm', 'amount': '\$450'},
      {'name': 'Reliance Social Firm', 'amount': '\$600'},
      {'name': 'TOMS Shoes', 'amount': '\$200'},
    ];

    final List<Map<String, String>> donorDetails = [
      {
        'name': 'Ishika Dumbre',
        'email': 'ishika@example.com',
        'message': 'Keep up the great work!',
      },
      {
        'name': 'Vandita Belani',
        'email': 'vandita@example.com',
        'message': 'Happy to support your cause.',
      },
      {
        'name': 'Tanisha Dembla',
        'email': 'tanisha@example.com',
        'message': 'Best wishes for your mission.',
      },
      {
        'name': 'Manasi Ghalsasi',
        'email': 'manasi@example.com',
        'message': 'Thank you for making a difference.',
      },
      {
        'name': 'Ishika Dumbre',
        'email': 'ishika@example.com',
        'message': 'Hope this helps someone in need.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations Received'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  donations[index]['name']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Donated: ${donations[index]['amount']}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DonationDetailsPage(
                        firmName: donations[index]['name']!,
                        donor: donorDetails[index],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
