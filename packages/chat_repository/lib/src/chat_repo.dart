// import 'package:firebase_auth/firebase_auth.dart';
import 'models/models.dart';

abstract class ChatRepository {
  Future<void> sendMessage(String message, String forUserId, String fromUserId);
  Stream<List<ChatMessage>> messagesFor(String userId);
  //messages between
  Stream<List<ChatMessage>> messagesBetween(String userId1, String userId2);
  Future<String> getBrigadeUserId();
  Future<String> getNormalUserId();
}