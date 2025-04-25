import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NGOViewFormsScreen extends StatefulWidget {
  const NGOViewFormsScreen({super.key});

  @override
  State<NGOViewFormsScreen> createState() => _NGOViewFormsScreenState();
}

class _NGOViewFormsScreenState extends State<NGOViewFormsScreen> {
  late Future<List<Map<String, dynamic>>> _formsFuture;

  Future<List<Map<String, dynamic>>> _fetchForms() async {
    final response = await Supabase.instance.client
        .from('forms')
        .select('*')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  void initState() {
    super.initState();
    _formsFuture = _fetchForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Requests by Social Firms'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _formsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No QR requests found.'));
          }

          final forms = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _info('Drive Purpose', form['drive_purpose']),
                      _info('Brief About Drive', form['brief_about_the_drive']),
                      _info('Help Given', form['help_given']),
                      _info('80G Available', form['80G_available_ornot']),
                      _info('Drive Location', form['drive_locatin']),
                      _info('Start Date', form['start_date']),
                      _info('End Date', form['end_date']),
                      _info('Target Donation (₹)', form['target_donation'].toString()),
                      _info('Volunteer Count', form['volunteer_count'].toString()),
                      _info('Activity / Donation', form['activity_yesorno'].toString()),
                      _info('NGO Name', form['ngo_name']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
