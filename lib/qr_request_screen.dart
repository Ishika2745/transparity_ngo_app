import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'qr_upload_page.dart';

class QrRequestScreen extends StatefulWidget {
  const QrRequestScreen({super.key});

  @override
  State<QrRequestScreen> createState() => _QrRequestScreenState();
}

class _QrRequestScreenState extends State<QrRequestScreen> {
  List<String> firmNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSocialFirms();
  }

  Future<void> fetchSocialFirms() async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('firm_name')
        .eq('role', 'social_firm');

    setState(() {
      firmNames = response.map<String>((e) => e['firm_name'] as String).toList();
      isLoading = false;
    });
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
          : firmNames.isEmpty
              ? const Center(child: Text('No QR code requests yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: firmNames.length,
                  itemBuilder: (context, index) {
                    final firmName = firmNames[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Side: Firm Name + Check Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firmName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextButton(
                                    onPressed: () {
                                      _showFirmDetails(context, firmName);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                    ),
                                    child: const Text(
                                      'Check Details',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right Side: Approve & Reject Buttons (Stacked)
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QrUploadPage(
                                          firmName: firmName,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Approve', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$firmName Rejected')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Reject', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // Function to Show Firm Details in a Dialog Box
  void _showFirmDetails(BuildContext context, String firmName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Details of $firmName'),
          content: const Text('Here you can show more details about the firm, such as its mission, past donations, and other relevant info.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
