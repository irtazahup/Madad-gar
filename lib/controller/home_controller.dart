import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:as_pass/models/service_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final _supabase = Supabase.instance.client;

  // Reactive variables
  var services = <ServiceProvider>[].obs;
  var isLoading = false.obs;
  var currentRadius = 1000.0.obs;

  /// Main function to handle permissions and fetch data
  Future<void> getHyperlocalServices({bool isRefresh = true}) async {
    try {
      isLoading.value = true;

      // 1. Handle Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Permission Denied",
            "We need location to find nearby workers.",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Settings Required",
          "Location is permanently disabled. Please enable it in settings.",
        );
        return;
      }

      // 2. Get Position
      Position position = await Geolocator.getCurrentPosition();

      // 3. Define the "Ring" (Differential fetching)
      double minRadius = isRefresh ? 0.0 : currentRadius.value;
      double maxRadius = isRefresh ? 1000.0 : currentRadius.value + 5000.0;

      // 4. Call Supabase
      final List<dynamic> response = await _supabase.rpc(
        'get_nearby_services_v2', // The optimized function with min_radius
        params: {
          'user_lat': position.latitude,
          'user_long': position.longitude,
          'min_radius_meters': minRadius,
          'max_radius_meters': maxRadius,
        },
      );

      final List<ServiceProvider> newResults = response
          .map((json) => ServiceProvider.fromMap(json))
          .toList();

      // 5. Update State
      if (isRefresh) {
        services.assignAll(newResults);
        currentRadius.value = 1000.0;
      } else {
        services.addAll(newResults);
        currentRadius.value = maxRadius;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
