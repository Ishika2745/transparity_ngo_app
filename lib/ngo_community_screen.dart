import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';


class NgoCommunityScreen extends StatefulWidget {
  const NgoCommunityScreen({super.key});

  @override
  _NgoCommunityScreenState createState() => _NgoCommunityScreenState();
}

class _NgoCommunityScreenState extends State<NgoCommunityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _missionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isEditing = false;
  String? _qrImageUrl;
  File? _pickedQrImageFile;

  @override
  void initState() {
    super.initState();
    fetchNgoProfile();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> fetchNgoProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('ngo_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();


    if (response != null) {
      setState(() {
        _nameController.text = response['name'] ?? '';
        _missionController.text = response['mission'] ?? '';
        _contactController.text = response['contact_info'] ?? '';
        _qrImageUrl = response['qr_image_url'];
      });
    }
  }

  Future<void> saveProfileChanges() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final existingProfile = await Supabase.instance.client
        .from('ngo_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (existingProfile == null) {
      // No profile exists, insert a new one
      await Supabase.instance.client
          .from('ngo_profiles')
          .insert({
        'id': userId, // important!
        'name': _nameController.text,
        'mission': _missionController.text,
        'contact_info': _contactController.text,
      });
    } else {
      // Profile exists, update it
      await Supabase.instance.client
          .from('ngo_profiles')
          .update({
        'name': _nameController.text,
        'mission': _missionController.text,
        'contact_info': _contactController.text,
      })
          .eq('id', userId);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("NGO Information Saved!")),
    );
  }


  Future<void> _pickAndUploadQRImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();  // <-- get the bytes!

      final qrUrl = await uploadQRImage(bytes); // pass bytes instead of File!

      if (qrUrl != null) {
        await saveQrUrlToDatabase(qrUrl);
        setState(() {
          _qrImageUrl = qrUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("QR Image Uploaded Successfully!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected!")),
      );
    }
  }

  Future<String?> uploadQRImage(Uint8List fileBytes) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'qr_${userId}_$timestamp.png';  // <-- now filename is unique!

    final storageResponse = await Supabase.instance.client.storage
        .from('ngo-qr-codes')
        .uploadBinary(
      fileName,
      fileBytes,
      fileOptions: const FileOptions(upsert: true),
    );

    if (storageResponse.isNotEmpty) {
      final publicUrl = Supabase.instance.client.storage
          .from('ngo-qr-codes')
          .getPublicUrl(fileName);
      return publicUrl;
    }
    return null;
  }

  Future<void> saveQrUrlToDatabase(String qrUrl) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    await Supabase.instance.client
        .from('ngo_profiles')
        .upsert({
      'id': userId,
      'name': _nameController.text.isNotEmpty ? _nameController.text : 'Default Name',
      'mission': _missionController.text.isNotEmpty ? _missionController.text : 'Default Mission',
      'contact_info': _contactController.text.isNotEmpty ? _contactController.text : 'Default Contact',
      'qr_image_url': qrUrl,
    }, onConflict: 'id');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NGO Community"),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
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
                  onPressed: () async {
                    if (_isEditing) {
                      await saveProfileChanges();
                    }
                    _toggleEditing();
                  },
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
              onPressed: _pickAndUploadQRImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Upload QR Image", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            if (_qrImageUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Uploaded QR Image:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    _qrImageUrl!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
