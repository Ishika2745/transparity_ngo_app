import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transparity_app/social_firm_pages/firm_info_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> updateRole(BuildContext context, String role) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
      return;
    }

    try {
      // 🟢 **Check if user exists in profiles table**
      final userProfile = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (userProfile == null) {
        // 🆕 **Insert new user profile with role**
        await supabase.from('profiles').insert({
          'id': user.id,
          'role': role,
        });
        print("✅ Profile created for user ${user.id} with role $role");
      } else {
        // 📝 **Update role if user exists**
        await supabase.from('profiles').update({'role': role}).eq('id', user.id);
        print("🔄 Role updated for user ${user.id} to $role");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role updated to $role!')),
      );

      // 🚀 **Navigate based on role**
      if (role == 'ngo') {
        Navigator.pushReplacementNamed(context, '/ngo_dashboard');
      } else if (role == 'firm') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirmInfoScreen()), // 🆕 Redirect here
        );
      }
    } catch (e) {
      print("❌ Error updating role: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating role: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => updateRole(context, 'ngo'),
            child: const Text('I am an NGO'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => updateRole(context, 'firm'),
            child: const Text('I am a Social Firm'),
          ),
        ],
      ),
    );
  }
}
