import 'package:as_pass/models/service_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController {
  final _supabase = Supabase.instance.client;

  Future<List<ServiceProvider>> fetchServices({
    required double userLat,
    required double userLng,
    required radiusInMeters,
  }) async {
    try {
      // Calling the SQL function we created in Supabase
      final List<dynamic> response = await _supabase.rpc(
        'get_nearby_services',
        params: {
          'user_lat': userLat,
          'user_long': userLng,
          'radius_meters': radiusInMeters,
        },
      );

      // Map the results to our ServiceProvider model
      return response.map((json) => ServiceProvider.fromMap(json)).toList();
    } catch (e) {
      print("Error fetching hyperlocal services: $e");
      return [];
    }
  }
}
