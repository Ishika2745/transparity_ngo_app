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
  String? ngoName;

  @override
  void initState() {
    super.initState();
    loadNgoNameAndRequests();
  }

  Future<void> loadNgoNameAndRequests() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      // Handle no user logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    // 1. Fetch ngo_name from profiles table
    final profileResponse = await Supabase.instance.client
        .from('profiles')
        .select('ngo_name')
        .eq('id', user.id)
        .single();

    ngoName = profileResponse['ngo_name'] as String?;

    if (ngoName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NGO name not found')),
      );
      return;
    }

    // 2. After getting ngo_name, fetch forms related to this NGO
    await fetchQrRequests();
  }

  Future<void> fetchQrRequests() async {
    final response = await Supabase.instance.client
        .from('forms')
        .select('id, drive_purpose, start_date, end_date, submitted_by, status')
        .eq('ngo_name', ngoName!)   // ngoName will NOT be null now
        .eq('status', 'pending');

    final List<Map<String, dynamic>> enrichedRequests = [];

    for (var form in response) {
      final firmId = form['submitted_by'];

      final profile = await Supabase.instance.client
          .from('profiles')
          .select('firm_name')
          .eq('id', firmId)
          .single();

      enrichedRequests.add({
        ...form,
        'firm_name': profile['firm_name'],
      });
    }

    setState(() {
      requests = enrichedRequests;
      isLoading = false;
    });
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
              ? const Center(child: Text('No QR code requests yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final firmName = request['firm_name'] ?? 'Unknown Firm';
                    final drivePurpose = request['drive_purpose'] ?? 'No Purpose';
                    final startDate = request['start_date'] ?? '';
                    final endDate = request['end_date'] ?? '';

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
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
                            Text('Purpose: $drivePurpose'),
                            Text('Start Date: $startDate'),
                            Text('End Date: $endDate'),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    approveRequest(request['id']);
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Approve', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    rejectRequest(request['id']);
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Reject', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> approveRequest(int formId) async {
    await Supabase.instance.client
        .from('forms')
        .update({'status': 'approved'})
        .eq('id', formId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request Approved')),
    );

    await fetchQrRequests();
  }

  Future<void> rejectRequest(int formId) async {
    await Supabase.instance.client
        .from('forms')
        .update({'status': 'rejected'})
        .eq('id', formId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request Rejected')),
    );

    await fetchQrRequests();
  }
}
