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
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // 1. Update User Profile (Age and Location)
    // We use postgis format: 'POINT(longitude latitude)'
    await supabase
        .from('users')
        .update({'age': age, 'location_coords': 'POINT($lng $lat)'})
        .eq('id', user.id);

    // 2. Insert the specific Skill into Services table
    await supabase.from('services').insert({
      'user_id': user.id,
      'skill_category': category,
      'description': description,
      'experience_years': experience,
    });
  }
}
