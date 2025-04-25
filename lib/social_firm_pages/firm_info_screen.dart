import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transparity_app/social_firm_pages/firm_dashboard.dart';

class FirmInfoScreen extends StatefulWidget {
  @override
  _FirmInfoScreenState createState() => _FirmInfoScreenState();
}

class _FirmInfoScreenState extends State<FirmInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firmNameController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _saveFirmInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
      return;
    }

    try {
      await supabase.from('profiles').update({
        'firm_name': _firmNameController.text.trim(),
        'industry': _industryController.text.trim(),
        'contact': _contactController.text.trim(),
        'address': _addressController.text.trim(),
      }).eq('id', user.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firm information saved successfully!')),
      );

      // Redirect to Firm Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirmDashboardScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving firm information: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firm Information')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter Firm Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _firmNameController,
                decoration: const InputDecoration(labelText: 'Firm Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter firm name' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _industryController,
                decoration: const InputDecoration(labelText: 'Industry', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter industry' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Contact Number', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter contact number' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter address' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveFirmInfo,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save & Proceed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
