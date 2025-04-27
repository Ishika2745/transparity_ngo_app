import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirmDonationScreen extends StatefulWidget {
  const FirmDonationScreen({Key? key}) : super(key: key);

  @override
  State<FirmDonationScreen> createState() => _FirmDonationScreenState();
}

class _FirmDonationScreenState extends State<FirmDonationScreen> {
  List<Map<String, dynamic>> donations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApprovedDonations();
  }

  Future<void> fetchApprovedDonations() async {
    final data = await Supabase.instance.client
        .from('forms')
        .select('firm_name, ngo_name, target_donation, status')
        .eq('status', 'approved');

    setState(() {
      donations = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  Future<String?> fetchNGOQrImage(String ngoName) async {
    final response = await Supabase.instance.client
        .from('ngo_profiles')
        .select('qr_image_url') // <-- FIXED
        .eq('name', ngoName)
        .maybeSingle();

    if (response != null && response['qr_image_url'] != null) { // <-- FIXED
      return response['qr_image_url'] as String;
    }
    return null;
  }


  void _showQRDialog(BuildContext context, String qrImageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('NGO QR Code'),
        content: Image.network(
          qrImageUrl,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Failed to load QR Image.');
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firm Donations'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('Firm: ${donation['firm_name'] ?? "Unknown"}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NGO: ${donation['ngo_name'] ?? "Unknown"}'),
                  Text('Target Donation: ₹${donation['target_donation'] ?? 0}'),
                ],
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('See QR'),
                  onPressed: () async {
                    final ngoName = donation['ngo_name'];
                    print('Clicked See QR for NGO: $ngoName'); // 👈 Add print

                    if (ngoName != null) {
                      final qrUrl = await fetchNGOQrImage(ngoName);
                      print('Fetched QR URL: $qrUrl'); // 👈 Add print

                      if (qrUrl != null) {
                        _showQRDialog(context, qrUrl);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('QR Code not found for this NGO.')),
                        );
                      }
                    }
                  }

              ),
            ),
          );
        },
      ),
    );
  }
}
