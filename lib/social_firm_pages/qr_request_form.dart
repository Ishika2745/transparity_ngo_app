import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestQRFormScreen extends StatefulWidget {
  final String ngoName;

  const RequestQRFormScreen({super.key, required this.ngoName});

  @override
  _RequestQRFormScreenState createState() => _RequestQRFormScreenState();
}

class _RequestQRFormScreenState extends State<RequestQRFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _drivePurposeController = TextEditingController();
  final TextEditingController _briefAboutController = TextEditingController();
  final TextEditingController _helpGivenController = TextEditingController();
  final TextEditingController _g80AvailableController = TextEditingController();
  final TextEditingController _imagesController = TextEditingController();
  final TextEditingController _driveLocationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _donationGoalController = TextEditingController();
  final TextEditingController _volunteerCountController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate
        ? DateTime.now()
        : _startDate ?? DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          _startDateController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
          _endDateController.clear();
          _endDate = null;
        } else {
          if (_startDate == null || pickedDate.isBefore(_startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End date must be after start date')),
            );
            return;
          }
          _endDate = pickedDate;
          _endDateController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
        }
      });
    }
  }

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  final user = Supabase.instance.client.auth.currentUser;
  final userId = user?.id;

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not logged in')),
    );
    return;
  }

  try {
    await Supabase.instance.client.from('forms').insert({
      'drive_purpose': _drivePurposeController.text,
      'brief_about_the_drive': _briefAboutController.text,
      'help_given': _helpGivenController.text,
      '80G_available_ornot': _g80AvailableController.text,
      'images': _imagesController.text,
      'drive_locatin': _driveLocationController.text,
      'start_date': _startDate!.toIso8601String(),
      'end_date': _endDate!.toIso8601String(),
      'target_donation': int.tryParse(_donationGoalController.text),
      'volunteer_count': int.tryParse(_volunteerCountController.text),
      'activity_yesorno': _activityController.text.toLowerCase().contains("activity"),
      'ngo_name': widget.ngoName,          // ✅ correct
      'submitted_by': userId,               // ✅ ADD this
      'status': 'pending',                  // ✅ ADD this
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR Code Requested for ${widget.ngoName}')),
    );

    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    _startDate = null;
    _endDate = null;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting form: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request QR for ${widget.ngoName}'),
        backgroundColor: const Color(0xFF004B8D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTextField(_drivePurposeController, 'Drive Purpose'),
                _buildTextField(_briefAboutController, 'Brief about the drive'),
                _buildTextField(_helpGivenController, 'Brief about benefits / help given'),
                _buildTextField(_g80AvailableController, '80 G available or not'),
                _buildTextField(_imagesController, 'Images of campaign creatives'),
                _buildTextField(_driveLocationController, 'Drive Location'),
                _buildDateField(_startDateController, 'Start Date', true),
                _buildDateField(_endDateController, 'End Date', false),
                _buildTextField(_donationGoalController, 'Target Donation Goal (₹)', isNumeric: true),
                _buildTextField(_volunteerCountController, 'Volunteer Count', isNumeric: true),
                _buildTextField(_activityController, 'Would like to be involved in activity or only money donations'),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Request QR', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label, bool isStartDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _pickDate(context, isStartDate),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Select a $label' : null,
      ),
    );
  }
} 