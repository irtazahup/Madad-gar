import 'package:as_pass/controller/home_controller.dart';
import 'package:as_pass/models/service_category.dart';
import 'package:as_pass/models/service_provider.dart';
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
      appBar: AppBar(title: const Text("Maddad'gar")),
      body: Obx(() {
        if (controller.isLoading.value && controller.services.isEmpty) {
          return const Center(child: CircularProgressIndicator());
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => controller.getHyperlocalServices(isRefresh: false),
        child: Obx(
          () => Text(
            controller.isLoading.value
                ? "Searching..."
                : "Explore up to ${(controller.currentRadius.value + 5000) / 1000}km",
          ),
        ),
      ),
    );
  }
}
