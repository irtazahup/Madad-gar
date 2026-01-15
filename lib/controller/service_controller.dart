import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:as_pass/controller/profile_controller.dart'; // Import the ProfileController

class ServiceController extends GetxController {
  final supabase = Supabase.instance.client;
  var isLoading = false.obs;

  Future<void> uploadService({
    required String category,
    required String description,
    required int experience,
    required int age,
    required double lat,
    required double lng,
    required String addressName,
  }) async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // 1. Update user info
      await supabase.from('users').update({'age': age}).eq('id', user.id);

      // 2. Insert new service
      await supabase.from('services').insert({
        'user_id': user.id,
        'skill_category': category,
        'description': description,
        'experience_years': experience,
        'location_name': addressName,
        'location_coords': 'POINT($lng $lat)', // Standard format
      });

      // 3. THE KEY STEP: Update the Profile Page UI
      // We check if ProfileController is active in memory
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().fetchUserData();
      }

      Get.back(); // Go back to the previous screen
      Get.snackbar("Success", "Your skill has been added!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
