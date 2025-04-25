import 'package:flutter/material.dart';

class FirmCommunityScreen extends StatelessWidget {
  const FirmCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "NGO Information",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // NGO Name Field
          TextField(
            controller: TextEditingController(text: "Transparity NGO"),
            readOnly: true, // Non-editable
            decoration: const InputDecoration(
              labelText: "NGO Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          // NGO Mission Field
          TextField(
            controller: TextEditingController(
                text: "Our mission is to bring transparency in NGO donations."),
            readOnly: true, // Non-editable
            decoration: const InputDecoration(
              labelText: "Mission",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),

          // NGO Contact Info Field
          TextField(
            controller: TextEditingController(text: "contact@transparity.org"),
            readOnly: true, // Non-editable
            decoration: const InputDecoration(
              labelText: "Contact Info",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
