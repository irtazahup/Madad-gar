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
                onPressed: () => showReviewDialog(serviceId, providerId),
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

  void showReviewDialog(String serviceId, String providerId) {
    int selectedRating = 5;
    final commentController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Rate Service"),
        // Use SingleChildScrollView to prevent keyboard/text overflow
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Wrap in FittedBox to stop 8-pixel overflow on smaller screens
              FittedBox(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          // Reduced padding to prevent horizontal overflow
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32, // Fixed size for consistency
                          ),
                          onPressed: () =>
                              setState(() => selectedRating = index + 1),
                        );
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3, // Better for "Experience" comments
                decoration: const InputDecoration(
                  hintText: "Share your experience...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(Get.overlayContext!).pop(), // Direct context pop
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Show a loading indicator so user doesn't click twice
              Get.showOverlay(
                asyncFunction: () => chatController.submitReview(
                  serviceId,
                  providerId,
                  selectedRating,
                  commentController.text,
                ),
                loadingWidget: const Center(child: CircularProgressIndicator()),
              );
              // Update the local state
              // Close the dialog after submission
              Navigator.of(Get.overlayContext!).pop();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
      barrierDismissible: false, // Prevents accidental closing during sync
    );
  }
}
