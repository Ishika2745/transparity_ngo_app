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
        .select('id, firm_name, drive_purpose, brief_about_the_drive, help_given, 80G_available_ornot, images, drive_locatin, start_date, end_date, target_donation, volunteer_count, activity_yesorno, submitted_by')
        .eq('status', 'pending');

    setState(() {
      requests = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  Future<void> updateStatus(int id, String status) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    await Supabase.instance.client
        .from('forms')
        .update({
      'status': status,
      'reviewed_by': userId,
      'reviewed_at': DateTime.now().toIso8601String(),
    })
        .eq('id', id);

    fetchRequests(); // Refresh after update
  }
  Future<String?> getCurrentUserFirmName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final userId = user.id;

    final response = await Supabase.instance.client
        .from('profiles') // <-- or your user table
        .select('firm_name')
        .eq('id', userId)
        .single();

    if (response != null && response['firm_name'] != null) {
      return response['firm_name'] as String;
    } else {
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Requests'),
        backgroundColor: const Color(0xFF004B8D),
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
          final firmName = (request['firm_name'] != null && request['firm_name'].toString().isNotEmpty)
              ? request['firm_name']
              : 'Unnamed Firm'; // Updated fallback

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
          title: Text(request['firm_name'] ?? 'Firm Name'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Drive Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text('Drive Purpose: ${request['drive_purpose'] ?? 'N/A'}'),
                Text('Brief About Drive: ${request['brief_about_the_drive'] ?? 'N/A'}'),
                Text('Help Given: ${request['help_given'] ?? 'N/A'}'),
                Text('Drive Location: ${request['drive_locatin'] ?? 'N/A'}'),
                Text('Activity Planned: ${request['activity_yesorno'] == true ? 'Yes' : 'No'}'),
                const Divider(height: 24),
                const Text(
                  'Donation Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text('Target Donation: ${request['target_donation']?.toString() ?? 'N/A'}'),
                Text('Volunteer Count: ${request['volunteer_count']?.toString() ?? 'N/A'}'),
                Text('80G Available: ${request['80G_available_ornot'] ?? 'N/A'}'),
                const Divider(height: 24),
                const Text(
                  'Timing',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text('Start Date: ${request['start_date'] ?? 'N/A'}'),
                Text('End Date: ${request['end_date'] ?? 'N/A'}'),
                const Divider(height: 24),
                const Text(
                  'Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(request['images'] ?? 'No image link provided'),
              ],
            ),
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
