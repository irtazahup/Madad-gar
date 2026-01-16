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

              // Determine the display name: show the one that IS NOT me
              String otherPersonName = room['consumer_id'] == myId
                  ? (room['provider_name'] ?? "Provider")
                  : (room['consumer_name'] ?? "User");
              // print(room['consumer_id']);
              // print(room['provider_id']);
              // print(room['created_at']);
              // print(room['room_id']);
              // print(room['consumer_name']);
              // print(room['provider_name']);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    otherPersonName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(otherPersonName),
                subtitle: Text(
                  "Created: ${room['created_at'].toString().substring(0, 10)}",
                ), // Clean date
                onTap: () => Get.to(
                  () => ChatMessagesScreen(
                    roomId: room['room_id'],
                    receiverName: otherPersonName,
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
