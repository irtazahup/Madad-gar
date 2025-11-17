import 'package:as_pass/services/supabase_service.dart';
import 'package:flutter/material.dart';
// Use the fixed version
import 'package:get/get.dart';
import 'package:as_pass/ui/auth/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load from root directory
  await SupabaseService.initialize(); // Initialize Supabase first
  Get.put(SupabaseService()); // Put the service in GetX
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
    );
  }
}
