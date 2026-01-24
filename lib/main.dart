import 'package:as_pass/controller/login_controller.dart';
import 'package:as_pass/home/home.dart' show HomePage;
import 'package:as_pass/services/supabase_service.dart';
import 'package:flutter/material.dart';
// Use the fixed version
import 'package:get/get.dart';
import 'package:as_pass/ui/auth/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SupabaseService.initialize();
  Get.put(SupabaseService());
  Get.put(LoginController());
  // Check if a session exists
  final session = SupabaseService.client.auth.currentSession;

  runApp(MyApp(initialScreen: session != null ? HomePage() : LoginPage()));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maddad\'gar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Use the conditional screen
      home: initialScreen,
    );
  }
}
