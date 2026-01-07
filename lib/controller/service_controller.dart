// service_controller.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceController {
  final supabase = Supabase.instance.client;
  Future<void> uploadService({
    required String category,
    required String description,
    required int experience,
    required int age,
    required double lat,
    required double lng,
    required String addressName, // The text location
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('users').update({'age': age}).eq('id', user.id);

    // We only insert into services now
    await supabase.from('services').insert({
      'user_id': user.id,
      'skill_category': category,
      'description': description,
      'experience_years': experience,
      'location_name': addressName,
      'location_coords': 'POINT($lng $lat)', // Standard Long/Lat format
    });
  }
}
