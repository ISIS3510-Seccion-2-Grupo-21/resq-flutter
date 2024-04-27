// import 'package:firebase_auth/firebase_auth.dart';
import 'models/models.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage(String message, String fromUserId, String toUserId);
  Stream<List<ChatMessage>> messagesFor(String userId);
  //messages between
  Future<List<ChatMessage>> messagesBetween(String userId1, String userId2);
  Future<String> getBrigadeUserId();
  Future<String> getNormalUserId();

  Future<String> getUserRole(String userId);
}