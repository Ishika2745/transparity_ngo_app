import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transparity_app/ngo_dashboard.dart';
import 'package:transparity_app/social_firm_pages/firm_dashboard.dart';
import 'package:transparity_app/roleselection.dart';
import 'package:transparity_app/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  // 🔥 Login Function
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // 🔑 Authenticate User
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        Fluttertoast.showToast(msg: "Invalid email or password");
        print("🔴 Auth Error: No user returned from Supabase");
        return;
      }

      print("✅ User logged in: ${response.user!.id}");
      String userId = response.user!.id;

      // Ensure session exists
      final user = supabase.auth.currentUser;
      if (user == null) {
        Fluttertoast.showToast(msg: "Session expired, please log in again.");
        print("🔴 Session Expired");
        return;
      }

      // Fetch user role
      final userData = await supabase
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .maybeSingle(); // Change `.single()` to `.maybeSingle()` for safer handling

      print("👤 Profile Data: $userData");

      if (userData == null || userData['role'] == null) {
        Fluttertoast.showToast(msg: "Select your role first!");
        print("⚠️ User has no role assigned. Redirecting to Role Selection.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
        );
        return;
      }

      String role = userData['role'];
      Fluttertoast.showToast(msg: "Login Successful");

      // Redirect based on role
      if (role == "ngo") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NgoDashboardScreen()),
        );
      } else if (role == "firm") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FirmDashboardScreen()),
        );
      } else {
        Fluttertoast.showToast(msg: "Unauthorized role");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Login failed: $e");
      print("🔴 Exception: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Login')),
    body: SingleChildScrollView( // ✅ Scrolls if needed
    child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/transparity_logo.png',
                  height: 250,
                ),
              ),
              const Text(
                'Log into your account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Email cannot be empty" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty ? "Password cannot be empty" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: const Text("Don’t have an account? Sign up"),
              ),
            ],
          ),
        ),
    ),),
    );
  }
}