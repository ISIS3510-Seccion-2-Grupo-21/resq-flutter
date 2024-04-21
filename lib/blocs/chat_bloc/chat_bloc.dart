import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/foundation.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class SendMessageEvent extends ChatEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageReceivedEvent extends ChatEvent {
  final List<ChatMessage> messages;

  const ChatMessageReceivedEvent(this.messages);

  @override
  List<Object?> get props => [messages];
}

class InitializeChatEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitialState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatSecondUserFetchedState extends ChatState {
  final String secondUserId;

  const ChatSecondUserFetchedState(this.secondUserId);

  @override
  List<Object?> get props => [secondUserId];
}

class ChatLoadingState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatMessageReceivedState extends ChatState {
  final List<ChatMessage> messages;
  final bool isInitialLoad;

  const ChatMessageReceivedState(this.messages, {this.isInitialLoad = false});

  @override
  List<Object?> get props => [messages, isInitialLoad];
}

class ChatErrorState extends ChatState {
  final String errorMessage;

  const ChatErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final FirebaseAuth _firebaseAuth;
  late final Stream<List<ChatMessage>> _messageStream;
  late final String secondUserId;

  ChatBloc({
    required ChatRepository chatRepository,
    required FirebaseAuth firebaseAuth,
  })  : _chatRepository = chatRepository,
        _firebaseAuth = firebaseAuth,
        super(ChatInitialState()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);
    on<ChatMessageReceivedEvent>(_onChatMessageReceived);
  }

  User? get currentUser => _firebaseAuth.currentUser;

  void _onInitializeChat(InitializeChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    await _getSecondUser();
    _chatRepository.sendMessage('HELPISNEEDED', secondUserId, currentUser?.uid ?? '');
    _loadMessages();
    
  }

  Future<void> _getSecondUser() async {
    var currentUserRole = await currentUser?.getIdTokenResult().then((value) => value.claims!['role']);
    print(currentUserRole);
    if (currentUserRole != 'brigadeStudent'){
      secondUserId = await _chatRepository.getBrigadeUserId();
    } else {
      secondUserId = await _chatRepository.getNormalUserId();
    }
    emit(ChatSecondUserFetchedState(secondUserId));
  }

  void _loadMessages() {
    _messageStream = _chatRepository.messagesBetween(currentUser?.uid ?? '', secondUserId);
    _messageStream.listen((messages) {
      add(ChatMessageReceivedEvent(messages));
    }, onError: (error) {
      emit(ChatErrorState('Failed to load chat history: $error'));
    });
  }

  void _onChatMessageReceived(ChatMessageReceivedEvent event, Emitter<ChatState> emit) {
    emit(ChatMessageReceivedState(event.messages, isInitialLoad: true));
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      await _chatRepository.sendMessage(event.message, secondUserId, currentUser?.uid ?? '');
      add(ChatMessageReceivedEvent([
        ChatMessage(
          id: UniqueKey().toString(),
          message: event.message,
          to: secondUserId,
          from: currentUser?.uid ?? '',
          timestamp: DateTime.now(),
        ),
      ]));
    } catch (e) {
      emit(ChatErrorState('Failed to send message: $e'));
    }
  }
}