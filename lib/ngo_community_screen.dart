import 'package:flutter/material.dart';

class NgoCommunityScreen extends StatefulWidget {
  const NgoCommunityScreen({super.key});

  @override
  _NgoCommunityScreenState createState() => _NgoCommunityScreenState();
}

class _NgoCommunityScreenState extends State<NgoCommunityScreen> {
  final TextEditingController _nameController =
  TextEditingController(text: "Transparity NGO");
  final TextEditingController _missionController = TextEditingController(
      text: "Our mission is to bring transparency in NGO donations.");
  final TextEditingController _contactController =
  TextEditingController(text: "contact@transparity.org");

  bool _isEditing = false;

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "NGO Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.save : Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: _toggleEditing,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // NGO Name Field
          TextField(
            controller: _nameController,
            enabled: _isEditing,
            decoration: const InputDecoration(labelText: "NGO Name"),
          ),
          const SizedBox(height: 10),

          // NGO Mission Field
          TextField(
            controller: _missionController,
            enabled: _isEditing,
            decoration: const InputDecoration(labelText: "Mission"),
            maxLines: 3,
          ),
          const SizedBox(height: 10),

          // NGO Contact Info Field
          TextField(
            controller: _contactController,
            enabled: _isEditing,
            decoration: const InputDecoration(labelText: "Contact Info"),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("NGO Information Updated!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004B8D), // Peacock Blue
            ),
            child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
