import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:as_pass/models/service_provider.dart';

class ProfileController extends GetxController {
  final _supabase = Supabase.instance.client;

  var userProfile = {}.obs; // Stores name and email
  var myServices = <ServiceProvider>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser!.id;

      // 1. Fetch User Info (Full Name & Email)
      final userResponse = await _supabase
          .from('users')
          .select('full_name, email')
          .eq('id', userId)
          .single();
      userProfile.value = userResponse;

      // 2. Fetch Services posted by this user
      final servicesResponse = await _supabase
          .from('services')
          .select()
          .eq('user_id', userId);

      final List<ServiceProvider> loadedServices = (servicesResponse as List)
          .map((json) => ServiceProvider.fromMap(json))
          .toList();

      myServices.assignAll(loadedServices);
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE Service
  Future<void> deleteService(String serviceId) async {
    try {
      await _supabase.from('services').delete().eq('id', serviceId);
      myServices.removeWhere((s) => s.id == serviceId);
      Get.snackbar("Success", "Service deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Delete failed: $e");
    }
  }

  // Inside ProfileController
  Future<void> updateService({
    required String serviceId,
    required String category,
    required String description,
    required int experience,
  }) async {
    try {
      isLoading.value = true;

      await _supabase
          .from('services')
          .update({
            'skill_category': category,
            'description': description,
            'experience_years': experience,
          })
          .eq('id', serviceId);

      // Refresh the local list so the UI updates immediately
      await fetchUserData();

      Get.back(); // Return to Profile Page
      Get.snackbar("Success", "Service updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Update failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
