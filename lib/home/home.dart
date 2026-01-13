import 'package:as_pass/controller/home_controller.dart';
import 'package:as_pass/models/service_category.dart';
import 'package:as_pass/models/service_provider.dart';
import 'package:as_pass/ui/profile_page.dart';
import 'package:as_pass/widgets/service_providercard.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:as_pass/widgets/add_service.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // Call once on load
    controller.getHyperlocalServices(isRefresh: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false, // Professional left-aligned look
        title: const Text(
          "Maddad'gar",
          style: TextStyle(
            color: Color(0xFF1877F2), // Primary Brand Color
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          // Add Service Button
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black87),
            tooltip: 'Add Service',
            onPressed: () => Get.to(() => const AddServicePage()),
          ),
          // Profile Button
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black87,
            ),
            tooltip: 'My Profile',
            onPressed: () => Get.to(() => ProfilePage()),
          ),
          const SizedBox(width: 8), // Padding at the end
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.services.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.services.isEmpty) {
          return _if_Noservice();
        }
        return ListView.builder(
          itemCount: controller.services.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.services.length) {
              return _expandButton();
            }

            return ServiceProviderCard(provider: controller.services[index]);
          },
        );
      }),
    );
  }

  Widget _expandButton() {
    return Obx(() {
      bool isMax = controller.currentRadius.value >= 50000;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isMax ? Colors.grey[800] : const Color(0xFF1877F2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: controller.isLoading.value
              ? null // Disable button while loading to prevent double-clicks
              : () => controller.handleSearchAction(),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  isMax
                      ? "Reset to 1 KM"
                      : "Expand Search (+5km) :Current Radius(${controller.currentRadius / 1000} km)",
                ),
        ),
      );
    });
  }

  Widget _if_Noservice() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          const Icon(Icons.location_off_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "No service providers found nearby(${controller.currentRadius / 1000} KM).\nTry expanding your search radius.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          _expandButton(),
        ],
      ),
    );
  }
}
