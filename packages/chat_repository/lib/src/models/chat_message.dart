import 'package:equatable/equatable.dart';
import '../entities/chat_message_entity.dart';

class ChatMessage extends Equatable {
  final String id;
  final String message;
  final String to;
  final String from;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.to,
    required this.from,
    required this.timestamp,
  });

  static var empty = ChatMessage(
    id: '',
    message: '',
    to: '',
    from: '',
    timestamp: DateTime.now(),
  );

  ChatMessage copyWith({
    String? id,
    String? message,
    String? to,
    String? from,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      to: to ?? this.to,
      from: from ?? this.from,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      message: message,
      to: to,
      from: from,
      timestamp: timestamp,
    );
  }

  static ChatMessage fromEntity(ChatMessageEntity entity) {
    return ChatMessage(
      id: entity.id,
      message: entity.message,
      to: entity.to,
      from: entity.from,
      timestamp: entity.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, message, to, from, timestamp];

}