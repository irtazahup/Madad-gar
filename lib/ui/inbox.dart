import 'package:as_pass/controller/chat_controller.dart';
import 'package:as_pass/ui/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    final myId = chatController.supabase.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text("My Messages")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatController.getMyRoomsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No conversations yet."));
          }

          final rooms = snapshot.data!;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final String myId = chatController.supabase.auth.currentUser!.id;

              bool amIConsumer = room['consumer_id'] == myId;

              // Determine Title and Subtitle strings
              String displayName = amIConsumer
                  ? (room['provider_name'] ?? "Provider")
                  : (room['consumer_name'] ?? "Client");

              String displayRole = amIConsumer
                  ? (room['provider_role'] ?? "Service Provider")
                  : "Consumer / Client";

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    displayName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                // Displaying Name and Role together
                title: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  displayRole,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.to(
                  () => ChatMessagesScreen(
                    roomId: room['room_id'],
                    receiverName: displayName,
                    serviceId:
                        room['service_id'], // Now available from your view
                    providerId: room['provider_id'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
