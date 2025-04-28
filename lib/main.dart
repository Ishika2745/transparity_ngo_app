import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transparity_app/social_firm_pages/firm_dashboard.dart';
import 'package:transparity_app/login_page.dart';
import 'package:transparity_app/roleselection.dart';
import 'package:transparity_app/signup_page.dart';
import 'package:transparity_app/ngo_dashboard.dart';
import 'package:transparity_app/social_firm_pages/firm_info_screen.dart';
import 'package:transparity_app/social_firm_pages/ngo_view_forms.dart'; // ✅ Import the new screen
import 'package:transparity_app/faq_screen.dart'; // ✅ Newly added import for FAQ screen
import 'package:transparity_app/social_firm_pages/donation_history_page.dart'; // Import the DonationHistoryPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url: 'https://mbkvtxzkdntxhieffcwy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ia3Z0eHprZG50eGhpZWZmY3d5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMzNDQwMTAsImV4cCI6MjA1ODkyMDAxMH0.ec87ggWtAmzhATA3PUb-YUYnTEqAu4Gqb8OXXpLU3uk',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final supabase = Supabase.instance.client;
  Widget _initialScreen = LoginPage(); // Default screen is Login

  @override
  void initState() {
    super.initState();
    _checkUserSession(); // ✅ Check session on app start
  }

  // ✅ Check if the user is logged in and fetch role
  Future<void> _checkUserSession() async {
    final session = supabase.auth.currentSession;

    if (session == null || session.user == null) {
      print("🔴 No active session found. Redirecting to login.");
      return;
    }

    final user = session.user!;
    final userId = user.id;
    print("✅ Logged-in User: $userId");

    // ✅ Ensure email is verified
    if (user.emailConfirmedAt == null) {
      print("⚠️ Email not verified. Redirecting to login.");
      supabase.auth.signOut();
      return;
    }

    // ✅ Fetch user role from profiles table
    final userData = await supabase
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();

    print("👤 User Data: $userData");

    if (userData != null && userData['role'] != null) {
      String role = userData['role'];
      print("🟢 Role found: $role");

      setState(() {
        _initialScreen = role == "ngo"
            ? const NgoDashboardScreen()
            : const FirmDashboardScreen();
      });
    } else {
      print("⚠️ Role missing. Redirecting to Role Selection.");
      setState(() {
        _initialScreen = const RoleSelectionScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transparity App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _initialScreen, // ✅ Starts with the correct screen
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/role_selection': (context) => const RoleSelectionScreen(),
        '/ngo_dashboard': (context) => const NgoDashboardScreen(),
        '/firm_dashboard': (context) => const FirmDashboardScreen(),
        '/firm_info': (context) => FirmInfoScreen(),
        '/ngo_view_forms': (context) => const NGOViewFormsScreen(),
        '/faq': (context) => const FaqScreen(), // ✅ Newly added FAQ route
        '/donation_history': (context) => const DonationHistoryPage(firmName: '',), // ✅ Add route for DonationHistoryPage
      },
    );
  }
}
