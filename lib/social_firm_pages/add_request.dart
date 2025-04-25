import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transparity_app/social_firm_pages/qr_request_form.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  List<String> ngoNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNGONames();
  }

  Future<void> fetchNGONames() async {
    final supabase = Supabase.instance.client;

    try {
      // Fetch ngo_name where role is 'ngo'
      final response = await supabase
          .from('profiles')
          .select('name')
          .eq('role', 'ngo');

      setState(() {
        ngoNames = response
            .map<String>((profile) => profile['name'] ?? 'Unnamed NGO')
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching NGO names: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Requests'),
        backgroundColor: const Color(0xFF004B8D), // Peacock Blue
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ngoNames.isEmpty
              ? const Center(child: Text('No NGO users found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: ngoNames.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(
                          ngoNames[index],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing:
                            const Icon(Icons.arrow_forward, color: Colors.blue),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestQRFormScreen(
                                ngoName: ngoNames[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
