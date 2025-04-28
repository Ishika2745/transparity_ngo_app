import 'package:flutter/material.dart';

class DonationHistoryPage extends StatefulWidget {
  final String firmName;

  const DonationHistoryPage({Key? key, required this.firmName}) : super(key: key);

  @override
  _DonationHistoryPageState createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _proofController = TextEditingController();
  final TextEditingController _messagesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Proof for ${widget.firmName}'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proofController,
                decoration: const InputDecoration(labelText: 'Proof (URL or description)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide proof';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _messagesController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount Donated'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the donation amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the form data (send to database or API)
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Donation Proof')));
                    // For now, just print the values:
                    print('Name: ${_nameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Proof: ${_proofController.text}');
                    print('Message: ${_messagesController.text}');
                    print('Amount: ${_amountController.text}');
                    // Optionally, navigate back or show success
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
