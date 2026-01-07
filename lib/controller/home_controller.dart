import 'package:as_pass/models/service_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController {
  Future<List<ServiceProvider>> fetchServices() async {
    final response = await Supabase.instance.client
        .from('services')
        .select('''
          id,
          skill_category,
          description,
          experience_years,
          location_name,      
          location_coords,   
          user_id,
          users (
            full_name
          )
        ''')
        .neq('user_id', Supabase.instance.client.auth.currentUser!.id);

    final List data = response as List;
    return data.map((json) => ServiceProvider.fromMap(json)).toList();
  }
}
