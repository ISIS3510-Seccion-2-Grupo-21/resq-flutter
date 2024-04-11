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

  Future<void> sendMessage(String message, String fromUserId, String toUserId) async {
    await _firestore.collection('chat_messages').add({
      'message': message,
      'from': fromUserId,
      'to': toUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
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

  Stream<List<ChatMessage>> messagesBetween(String userId1, String userId2) {
    var streamController = StreamController<List<ChatMessage>>();

    var stream1 = _firestore.collection('chat_messages')
      .where('to', isEqualTo: userId1)
      .where('from', isEqualTo: userId2)
      .orderBy('timestamp')
      .snapshots();

    var stream2 = _firestore.collection('chat_messages')
      .where('to', isEqualTo: userId2)
      .where('from', isEqualTo: userId1)
      .orderBy('timestamp')
      .snapshots();

    stream1.listen((snapshot) => streamController.add(_mapSnapshotToChatMessages(snapshot)));
    stream2.listen((snapshot) => streamController.add(_mapSnapshotToChatMessages(snapshot)));

    return streamController.stream;
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
}