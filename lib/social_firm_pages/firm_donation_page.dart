import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FirmDonationScreen extends StatefulWidget {
  const FirmDonationScreen({super.key});

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
        .select('firm_name, ngo_name, target_donation, qr_code_image, status')
        .eq('status', 'approved');

    setState(() {
      donations = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firm Donations"),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : donations.isEmpty
              ? const Center(child: Text("No approved donations yet."))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      final donation = donations[index];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                donation["firm_name"] ?? "Firm Name",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text("NGO: ${donation["ngo_name"] ?? "NGO Name"}"),
                              const SizedBox(height: 5),
                              Text("Target Donation: ₹${donation["target_donation"] ?? "N/A"}"),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "Status: ${donation["status"] ?? "Unknown"}",
                                    style: TextStyle(
                                      color: (donation["status"] == "approved") ? Colors.green : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (donation["status"] == "approved" && (donation["qr_code_image"]?.isNotEmpty ?? false)) ...[
  ElevatedButton(
    onPressed: () {
      _showQRDialog(context, donation["qr_code_image"]);
    },
    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    child: const Text("See QR", style: TextStyle(color: Colors.white)),
  ),
  const SizedBox(width: 10),
  ElevatedButton(
    onPressed: () {
      _showQRDialog(context, donation["qr_code_image"]); // Same action for now
    },
    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    child: const Text("See QR (Again)", style: TextStyle(color: Colors.white)),
  ),
],

                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showQRDialog(BuildContext context, String qrData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("NGO QR Code"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 10),
              Text(qrData, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
