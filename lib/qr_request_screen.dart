import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QrRequestScreen extends StatefulWidget {
  const QrRequestScreen({super.key});

  @override
  State<QrRequestScreen> createState() => _QrRequestScreenState();
}

class _QrRequestScreenState extends State<QrRequestScreen> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final data = await Supabase.instance.client
        .from('forms')
        .select('id, firm_name, drive_purpose, submitted_by')
        .eq('status', 'pending');

    setState(() {
      requests = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  Future<void> updateStatus(int id, String status) async {
    await Supabase.instance.client
        .from('forms')
        .update({'status': status})
        .eq('id', id);

    fetchRequests(); // Refresh after update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Requests'),
        backgroundColor: const Color(0xFF004B8D), // Your blue
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text('No pending requests'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          final firmName = request['firm_name'] ?? 'Firm Name'; // changed ngoName to firmName

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side
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
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            _showDetailsDialog(context, request);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                          child: const Text('Check Details'),
                        ),
                      ],
                    ),
                  ),
                  // Right Side (Approve + Reject Buttons)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await updateStatus(request['id'], 'approved');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await updateStatus(request['id'], 'rejected');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(request['firm_name'] ?? 'Firm Name'), // still firm_name here
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Drive Purpose: ${request['drive_purpose'] ?? 'No Purpose'}'),
            ],
          ),
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
