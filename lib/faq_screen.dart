import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'What is Transparity?',
        'answer': 'Transparity is a platform that connects donors with NGOs transparently and efficiently.',
      },
      {
        'question': 'How do I make a donation?',
        'answer': 'Go to the Donations page, select a cause, and proceed with your payment method.',
      },
      {
        'question': 'Is my donation tax-deductible?',
        'answer': 'Yes, donations made through Transparity are eligible for tax deductions.',
      },
      {
        'question': 'How can I join the NGO community?',
        'answer': 'Click on the Community tab and follow the steps to register as an NGO partner.',
      },
      {
        'question': 'How do I get support?',
        'answer': 'You can contact us via the Help & FAQ section or email us at support@transparity.org.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqs[index]['question']!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  faqs[index]['answer']!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
