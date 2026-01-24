import 'package:as_pass/ui/auth/login.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService extends GetxService {
  static SupabaseClient get client => Supabase.instance.client;

  // Static method to initialize Supabase (called from main)
  static Future<void> initialize() async {
    print('=== SUPABASE INITIALIZATION ===');
    print('URL: ${dotenv.env['SUPABASE_URL']}');
    print('ANON_KEY: ${dotenv.env['SUPABASE_ANON_KEY']?.substring(0, 20)}...');

    try {
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );
      print('✅ Supabase initialized successfully');
      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        if (event == AuthChangeEvent.signedOut) {
          Get.offAll(() => LoginPage()); // Redirect to login on logout
        }
      });
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      rethrow;
    }
  }

  // ignore: empty_constructor_bodies
}
