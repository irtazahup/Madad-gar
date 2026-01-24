import 'package:as_pass/controller/login_controller.dart';
import 'package:as_pass/controller/profile_controller.dart';
import 'package:as_pass/widgets/add_service.dart';
import 'package:as_pass/widgets/edit_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.put(ProfileController());
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              loginController.logout();
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Get.to(() => const AddServicePage()),
      //   label: const Text("Add New Skill"),
      //   icon: const Icon(Icons.add),
      //   backgroundColor: const Color(0xFF1877F2),
      // ),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());

        return Column(
          children: [
            // User Header
            _buildUserHeader(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "My Registered Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Services List
            Expanded(
              child: ListView.builder(
                itemCount: controller.myServices.length,
                itemBuilder: (context, index) {
                  final service = controller.myServices[index];
                  return ListTile(
                    title: Text(service.role),
                    subtitle: Text(service.address ?? "No location set"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              Get.to(() => EditServicePage(service: service)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(service.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            onPressed: () => Get.to(() => const AddServicePage()),
            icon: const Icon(Icons.add),
            label: const Text("Add New Skill"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF1877F2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.userProfile['full_name'] ?? "User",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.userProfile['email'] ?? "",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: "Delete Service",
      middleText: "Are you sure you want to remove this skill?",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteService(id);
        Get.back();
      },
    );
  }
}
