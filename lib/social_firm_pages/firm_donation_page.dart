import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FirmDonationScreen extends StatelessWidget {
  FirmDonationScreen({super.key});

  // Sample donation data
  final List<Map<String, dynamic>> donations = [
    {
      "firmName": "ABC Pvt Ltd",
      "amount": "₹10,000",
      "status": "Approved",
      "ngoQR": "https://example.com/ngo_qr_abc"
    },
    {
      "firmName": "XYZ Corp",
      "amount": "₹5,000",
      "status": "Pending",
      "ngoQR": ""
    },
    {
      "firmName": "LMN Industries",
      "amount": "₹15,000",
      "status": "Approved",
      "ngoQR": "https://example.com/ngo_qr_lmn"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firm Donations"),
        backgroundColor: const Color(0xFF004B8D), // Peacock Blue
      ),
      body: Padding(
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
                      donation["firmName"],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text("Amount: ${donation["amount"]}"),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Status: ${donation["status"]}",
                          style: TextStyle(
                            color: donation["status"] == "Approved" ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),

                        // Show "See QR" button only if approved
                        if (donation["status"] == "Approved")
                          ElevatedButton(
                            onPressed: () {
                              _showQRDialog(context, donation["ngoQR"]);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text("See QR", style: TextStyle(color: Colors.white)),
                          ),
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

  // Function to show QR code in a dialog
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
