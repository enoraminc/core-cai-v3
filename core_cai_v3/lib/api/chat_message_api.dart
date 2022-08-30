import '../model/chat_message.dart';

abstract class ChatMessageApi {
  Stream<List<ChatMessage>> getChatMessages(String id);

  Future<bool> createMesage(String contentId, ChatMessage message);
}
