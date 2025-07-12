// chat_service.dart// lib/services/chat_service.dart
class ChatService {
  Future<List<String>> getMessages(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    return ['Hi! Can I help you?', 'Yes, I need clothes.'];
  }
}
