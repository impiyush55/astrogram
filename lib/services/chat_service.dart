import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = 'http://localhost:8080/api/chat';

  // Start a chat session or get existing one
  Future<String?> startChat(String userId, String astrologerId) async {
    final url = Uri.parse('$baseUrl/start');
    try {
      // Parse IDs as integers - backend expects numbers, not strings
      final userIdInt = int.tryParse(userId);
      final astrologerIdInt = int.tryParse(astrologerId);

      if (userIdInt == null || astrologerIdInt == null) {
        debugPrint(
          "ERROR: Invalid ID format. userId: $userId, astrologerId: $astrologerId",
        );
        debugPrint(
          "Backend expects integer IDs. Please ensure IDs are numeric.",
        );
        return null;
      }

      final body = jsonEncode({
        "userId": userIdInt,
        "astrologerId": astrologerIdInt,
      });

      debugPrint("Starting Chat: $url");
      debugPrint("Body: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      debugPrint("Start Chat Response: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Backend returns: {"id": 34, "userId": 2, "astrologerId": 2, ...}
        if (data is Map<String, dynamic>) {
          if (data.containsKey('id')) return data['id'].toString();
          if (data.containsKey('chatId')) return data['chatId'].toString();
          if (data.containsKey('_id')) return data['_id'].toString();
          // Sometimes wrapped in 'data'
          if (data.containsKey('data')) {
            final inner = data['data'];
            final val = inner['id'] ?? inner['_id'] ?? inner['chatId'];
            return val?.toString();
          }
        }
        return null;
      } else {
        debugPrint("Failed to start chat: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error starting chat: $e");
      return null;
    }
  }

  // Send a message
  Future<bool> sendMessage(
    String chatId,
    String senderId,
    String message,
  ) async {
    final url = Uri.parse('$baseUrl/send');
    try {
      // Backend expects sessionId (not chatId) and senderType (not senderId)
      final dynamic finalSessionId = int.tryParse(chatId) ?? chatId;

      final body = jsonEncode({
        "sessionId": finalSessionId, // Changed from chatId
        "senderType":
            "USER", // Changed from senderId - backend expects "USER" or "ASTROLOGER"
        "message": message,
      });
      debugPrint("Sending Message: $url");
      debugPrint("Body: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      debugPrint("Send Message Response: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Error sending message: $e");
      return false;
    }
  }

  // Get messages for a chat
  Future<List<dynamic>> getMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/messages/$chatId');
    try {
      debugPrint("Fetching Messages: $url");

      final response = await http.get(url);

      debugPrint("Get Messages Response: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Backend returns array directly: [{id, message, senderType, sessionId, createdAt}, ...]
        if (data is List) {
          debugPrint("Found ${data.length} messages");
          return data;
        } else if (data is Map && data.containsKey('messages')) {
          debugPrint(
            "Found ${data['messages'].length} messages in 'messages' key",
          );
          return data['messages'];
        }
      }
      debugPrint("No messages found or error occurred");
      return [];
    } catch (e) {
      debugPrint("Error fetching messages: $e");
      return [];
    }
  }

  /// End a chat session
  /// POST /api/chat/end/{sessionId}
  Future<bool> endChat(String sessionId) async {
    final url = Uri.parse('$baseUrl/end/$sessionId');
    try {
      debugPrint("Ending Chat Session: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
      );

      debugPrint("End Chat Response: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Chat session ended successfully");
        return true;
      } else {
        debugPrint("Failed to end chat: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error ending chat: $e");
      return false;
    }
  }
}
