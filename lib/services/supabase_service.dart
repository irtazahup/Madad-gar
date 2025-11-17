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
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      rethrow;
    }
  }
}
