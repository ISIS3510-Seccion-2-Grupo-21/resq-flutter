import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_repo.dart';
import 'models/models.dart';

class FirebaseChatRepository implements ChatRepository{
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirebaseChatRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  Future<ChatMessage> sendMessage(String message, String fromUserId, String toUserId) async {
    final docRef = await _firestore.collection('chat_messages').add({
      'message': message,
      'from': fromUserId,
      'to': toUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    return ChatMessage(
      id: docRef.id,
      message: message,
      from: fromUserId,
      to: toUserId,
      timestamp: DateTime.now(),
    );
  }

  Stream<List<ChatMessage>> messagesFor(String userId) {
    return _firestore.collection('chat_messages')
          .where('to', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                return ChatMessage(
                  id: doc.id,
                  message: data['message'] as String,
                  to: data['to'] as String,
                  from: data['from'] as String,
                  timestamp: (data['timestamp'] as Timestamp).toDate(),
                );
              }).toList());
  }

  Future<List<ChatMessage>> messagesBetween(String userId1, String userId2) async{
    var query1 = await _firestore.collection('chat_messages')
      .where('to', isEqualTo: userId1)
      .where('from', isEqualTo: userId2)
      .orderBy('timestamp')
      .get();

    var query2 = await _firestore.collection('chat_messages')
      .where('to', isEqualTo: userId2)
      .where('from', isEqualTo: userId1)
      .orderBy('timestamp')
      .get();

    var messages = <ChatMessage>[];
    for (var doc in query1.docs) {
      messages.add(objectToChatMessage(doc.data()));
    }
    for (var doc in query2.docs) {
      messages.add(objectToChatMessage(doc.data()));
    }

    return messages;
  }

  List<ChatMessage> _mapSnapshotToChatMessages(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      final Map<String, dynamic>? data = doc.data();
      if (data != null) {
        return ChatMessage(
          id: doc.id,
          message: data['message'] as String,
          to: data['to'] as String,
          from: data['from'] as String,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      } else {
        return ChatMessage.empty;
      }
    }).toList();
  } 

  Future<String> getBrigadeUserId() {
    return _firestore.collection('users').where('role', isEqualTo: 'brigadeStudent').get().then((value) => value.docs.first.id);
  }

  Future<String> getNormalUserId() async {
    var messages = await _firestore.collection('chat_messages').where('message', isEqualTo: 'HELPISNEEDED').get();
    var firstMessage = messages.docs.first;
    return firstMessage.data()['from'];    
  }

  Future<String> getUserRole(String userId) {
    return _firestore.collection('users').doc(userId).get().then((value) => value.data()?['role'] as String);
  }

  ChatMessage objectToChatMessage(Map<String,dynamic> object) {
    return ChatMessage(
      id: "placeholder",
      message: object['message'] as String,
      to: object['to'] as String,
      from: object['from'] as String,
      timestamp: (object['timestamp'] as Timestamp).toDate(),
    );
  }
}