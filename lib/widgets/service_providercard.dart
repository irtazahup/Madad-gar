import 'package:as_pass/controller/chat_controller.dart';
import 'package:as_pass/models/service_provider.dart';
import 'package:as_pass/ui/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:as_pass/widgets/view_details.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get.dart';

class ServiceProviderCard extends StatelessWidget {
  final chatController = Get.put(
    ChatController(),
  ); // Use put instead of find to be safe
  final ServiceProvider provider;

  ServiceProviderCard({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Top Section - Profile Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image with verified badge
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: DecorationImage(
                        image: NetworkImage(provider.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Color(0xFF1877F2),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          provider.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          provider.role,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Address
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            provider.address,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Rating and Online Status
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        // Text(
                        //   '0  (${provider.reviews} reviews)',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: Colors.grey[700],
                        //   ),
                        // ),
                        const Spacer(),
                        // Container(
                        //   width: 10,
                        //   height: 10,
                        //   decoration: BoxDecoration(
                        //     color: provider.isOnline
                        //         ? Colors.green
                        //         : Colors.grey,
                        //     shape: BoxShape.circle,
                        //   ),
                        // ),
                        const SizedBox(width: 6),
                        // Text(
                        //   provider.isOnline ? 'Online' : 'Offline',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w500,
                        //     color: provider.isOnline ? Colors.green : Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Divider
          Divider(color: Colors.grey[300], height: 1),

          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              // View Detail Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to detail page
                    // Inside your ServiceProviderCard...
                    Get.to(() => ViewDetailsPage(provider: provider));
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 68, 123, 206),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View Detail',
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 144, 255),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Hire Now Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    print("Hire Now clicked...");

                    print("Getting or creating chat room...");
                    String roomId = await chatController.getOrCreateRoom(
                      provider.id,
                      provider.userId,
                    );
                    if (roomId.isNotEmpty) {
                      print("Navigating to chat room ID: $roomId");
                      Get.to(
                        () => ChatMessagesScreen(
                          roomId: roomId,
                          receiverName: provider.name,
                          serviceId: provider.id, // Pass it here
                          providerId: provider.userId, // Pass it here
                        ),
                      );
                    }
                  },

                  // Hire functionality
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 35, 141, 240),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Hire Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
