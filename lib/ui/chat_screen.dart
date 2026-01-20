import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:as_pass/controller/chat_controller.dart';

class ChatMessagesScreen extends StatelessWidget {
  final String roomId;
  final String receiverName;
  final TextEditingController _messageController = TextEditingController();
  final ChatController chatController = Get.find<ChatController>();
  final String serviceId; // You need to set this appropriately
  final String providerId; // You need to set this appropriately

  ChatMessagesScreen({
    super.key,
    required this.roomId,
    required this.receiverName,
    required this.serviceId,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    chatController.checkInitialReviewStatus(serviceId);
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: () =>
                    showReviewDialog(context, serviceId, providerId),
                icon: Icon(
                  chatController.hasReviewed.value
                      ? Icons.edit_note
                      : Icons.star_rate,
                  color: Colors.amber,
                  size: 20,
                ),
                label: Text(
                  chatController.hasReviewed.value ? "Edit" : "Rate",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // 1. Live Message List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatController.getMessagesStream(roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Say Hi! 👋"));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true, // Latest messages at the bottom
                  itemCount: messages.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    // We reverse the logic for reverse list
                    final message = messages[messages.length - 1 - index];
                    final isMe =
                        message['sender_id'] ==
                        chatController.supabase.auth.currentUser!.id;

                    return _buildMessageBubble(message['content'], isMe);
                  },
                );
              },
            ),
          ),

          // 2. Message Input Field
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String content, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1877F2) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          content,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[100],
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF1877F2),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  print("Sending message: ${_messageController.text}");
                  chatController.sendMessage(roomId, _messageController.text);
                  _messageController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Update the signature to accept context
  void showReviewDialog(
    BuildContext context,
    String serviceId,
    String providerId,
  ) {
    final existingData = chatController.existingReviews[serviceId];
    int selectedRating = existingData?['rating'] ?? 5;
    final commentController = TextEditingController(
      text: existingData?['comment'] ?? "",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        // Use a separate context for the dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existingData != null ? "Edit Your Review" : "Rate Service",
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () => setDialogState(
                              () => selectedRating = index + 1,
                            ),
                          );
                        }),
                      ),
                    ),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Your experience...",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  // Native way to close the dialog
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await chatController.submitReview(
                        serviceId,
                        providerId,
                        selectedRating,
                        commentController.text,
                      );

                      // Native way to close the dialog after success
                      if (context.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
