import 'package:flutter/material.dart';

class QrUploadPage extends StatelessWidget {
  final String firmName;

  const QrUploadPage({super.key, required this.firmName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload QR for $firmName'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload QR Code for:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              firmName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // You can integrate image picker functionality here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('QR Code uploaded for $firmName')),
                  );
                },
                icon: Icon(Icons.upload),
                label: Text('Upload QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
