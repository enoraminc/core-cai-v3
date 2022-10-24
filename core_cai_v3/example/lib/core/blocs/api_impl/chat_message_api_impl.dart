import 'package:core_cai_v3/api/chat_message_api.dart';
import 'package:core_cai_v3/model/chat_message.dart';

class ChatMessageApiImpl extends ChatMessageApi {
  // final _firestore = FirebaseFirestore.instance;
  // final _storage = FirebaseStorage.instance;

  @override
  Stream<List<ChatMessage>> getChatMessages(String id) {
    // final collection = grainCollection
    //     .doc(id)
    //     .collection("message")
    //     .orderBy('createdAt', descending: true);

    // return collection.snapshots().map((event) =>
    //     event.docs.map((e) => ChatMessage.fromMap(e.data())).toList());

    return Stream.value([
      ChatMessage(id: "", text: "Test Message", msgType: "text"),
    ]);
  }

  @override
  Future<bool> createMesage(String contentId, ChatMessage message) async {
    try {
      // final collection = grainCollection.doc(contentId).collection("message");
      // await collection.doc(message.createdAt.toString()).set(message.toMap());
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
