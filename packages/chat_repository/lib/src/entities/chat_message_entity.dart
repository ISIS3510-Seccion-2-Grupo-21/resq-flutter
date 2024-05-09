import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String message;
  final String to;
  final String from;
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.id,
    required this.message,
    required this.to,
    required this.from,
    required this.timestamp,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'message': message,
      'to': to,
      'from': from,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static ChatMessageEntity fromDocument(Map<String, dynamic> doc) {
    return ChatMessageEntity(
      id: doc['id'] as String,
      message: doc['message'] as String,
      to: doc['to'] as String,
      from: doc['from'] as String,
      timestamp: DateTime.parse(doc['timestamp'] as String),
    );
  }

  @override
  List<Object?> get props => [id, message, to, from, timestamp];
}