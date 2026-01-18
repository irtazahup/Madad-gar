import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController extends GetxController {
  final _supabase = Supabase.instance.client;
  SupabaseClient get supabase => _supabase;
  // Inside ChatController
  Future<String> getOrCreateRoom(String serviceId, String providerId) async {
    final myId = _supabase.auth.currentUser!.id;
    print('🔵 Current User ID: $myId');
    try {
      print('🔵 Initializing chat for service: $serviceId');
      print('🔵 Provider ID: $providerId');
      // 1. Check if a room already exists for this service + consumer
      final existingRoom = await _supabase
          .from('chat_rooms')
          .select('id')
          .eq('service_id', serviceId)
          .eq('consumer_id', myId)
          .maybeSingle();

      if (existingRoom != null) {
        print('✅ Existing chat room found: ${existingRoom['id']}');
        return existingRoom['id']; // Return existing room ID
      }

      // 2. If no room exists, create a new one
      final newRoom = await _supabase
          .from('chat_rooms')
          .insert({
            'service_id': serviceId,
            'consumer_id': myId,
            'provider_id': providerId,
          })
          .select('id')
          .single();

      return newRoom['id'];
    } catch (e) {
      print('❌ CHAT ERROR: $e');
      Get.snackbar("Error", "Could not initialize chat: $e");
      return "";
    }
  }

  // Inside ChatController
  Stream<List<Map<String, dynamic>>> getMessagesStream(String roomId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: true); // Show oldest first
  }

  // Inside ChatController
  Future<void> sendMessage(String roomId, String content) async {
    if (content.trim().isEmpty) return;

    try {
      final myId = _supabase.auth.currentUser!.id;

      await _supabase.from('messages').insert({
        'room_id': roomId,
        'sender_id': myId,
        'content': content.trim(),
      });
      // Note: We don't need to manually refresh the list!
      // The Stream we created earlier will "hear" this insert and update the UI.
    } catch (e) {
      print('❌ MESSAGE SEND ERROR: $e');
      Get.snackbar("Error", "Message failed to send");
    }
  }

  // Stream of all chat rooms for the current user
  // Inside ChatController
  Stream<List<Map<String, dynamic>>> getMyRoomsStream() {
    final myId = _supabase.auth.currentUser!.id;

    return _supabase
        .from('user_chat_links') // MUST match the view name exactly
        .stream(primaryKey: ['room_id']) // Use the alias defined in the view
        .map(
          (list) => list
              .where(
                (row) =>
                    row['consumer_id'] == myId || row['provider_id'] == myId,
              )
              .toList(),
        );
  }

  Future<void> submitReview(
    String serviceId,
    String providerId,
    int rating,
    String comment,
  ) async {
    try {
      final myId = supabase.auth.currentUser!.id;
      await supabase.from('reviews').insert({
        'service_id': serviceId,
        'consumer_id': myId,
        'provider_id': providerId,
        'rating': rating,
        'comment': comment,
      });
      Get.snackbar("Success", "Thank you for your review!");
    } catch (e) {
      Get.snackbar("Error", "Could not submit review: $e");
    }
  }

  Future<bool> checkIfReviewed(String serviceId) async {
    final myId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('reviews')
        .select()
        .eq('consumer_id', myId)
        .eq('service_id', serviceId)
        .maybeSingle();

    return response != null; // Returns true if a review already exists
  }
}
