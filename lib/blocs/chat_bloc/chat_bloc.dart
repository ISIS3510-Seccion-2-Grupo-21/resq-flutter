import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_repository/chat_repository.dart';

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

class ChatWaitingEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class LoadingMessagesEvent extends ChatEvent {
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

class ChatMessagesLoadedState extends ChatState {
  final List<ChatMessage> messages;

  const ChatMessagesLoadedState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatMessageReceivedState extends ChatState {
  final List<ChatMessage> messages;

  const ChatMessageReceivedState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatMessageSentState extends ChatState {
  final ChatMessage message;

  const ChatMessageSentState(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatErrorState extends ChatState {
  final String errorMessage;

  const ChatErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ChatWaitingState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final FirebaseAuth _firebaseAuth;
  late final String secondUserId;
  late final String _currentUserRole;
  late List<ChatMessage> _messages;

  ChatBloc({
    required ChatRepository chatRepository,
    required FirebaseAuth firebaseAuth,
  })  : _chatRepository = chatRepository,
        _firebaseAuth = firebaseAuth,
        super(ChatInitialState()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);
    on<ChatMessageReceivedEvent>(_onChatMessageReceived);
    on<ChatWaitingEvent>(_onChatWaiting);
    on<LoadingMessagesEvent>(_loadMessages);
    
  }

  User? get currentUser => _firebaseAuth.currentUser;

  void _onInitializeChat(InitializeChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    await _getSecondUser(emit);
    if (_currentUserRole != 'brigadeStudent') {
      _chatRepository.sendMessage('HELPISNEEDED', currentUser?.uid ?? '', secondUserId);
    }
    add(LoadingMessagesEvent());
  }

  Future<void> _getSecondUser(Emitter<ChatState> emit) async {
    _currentUserRole = await _chatRepository.getUserRole(currentUser?.uid ?? '');

    if (_currentUserRole != 'brigadeStudent') {
      secondUserId = await _chatRepository.getBrigadeUserId();
    } else {
      secondUserId = await _chatRepository.getNormalUserId();
    }
    emit(ChatSecondUserFetchedState(secondUserId));
  }

  // void _loadMessages(Emitter<ChatState> emit) {
  //   _messageStream = _chatRepository.messagesBetween(currentUser?.uid ?? '', secondUserId);
  //   _messageStream.listen((messages) {
  //     emit(ChatMessagesLoadedState(messages));
  //     add(ChatMessageReceivedEvent(messages.where((message) => message.timestamp.isAfter(DateTime.now().subtract(const Duration(seconds: 1)))).toList()));
  //   }, onError: (error) {
  //     emit(ChatErrorState('Failed to load chat history: $error'));
  //   });
  // }
  void _loadMessages(LoadingMessagesEvent event, Emitter<ChatState> emit) async {
    _messages = await _chatRepository.messagesBetween(currentUser?.uid ?? '', secondUserId);
    emit(ChatMessagesLoadedState(_messages));
    add(ChatWaitingEvent());
  }

  void _onChatMessageReceived(ChatMessageReceivedEvent event, Emitter<ChatState> emit) {
    var newMessages = event.messages.where((message) => !_messages.contains(message)).toList();
    emit(ChatMessageReceivedState(newMessages));
    add(ChatWaitingEvent());
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      final sentMessage = await _chatRepository.sendMessage(event.message, currentUser?.uid ?? '', secondUserId);
      emit(ChatMessageSentState(sentMessage));
    } catch (e) {
      emit(ChatErrorState('Failed to send message: $e'));
    }
    add(ChatWaitingEvent());
  }

  void _onChatWaiting(ChatWaitingEvent event, Emitter<ChatState> emit) async {
    emit(ChatWaitingState());
    var newMessages = await _chatRepository.messagesBetween(currentUser?.uid ?? '', secondUserId);
    if (newMessages.length > _messages.length) {
      add(ChatMessageReceivedEvent(newMessages));
    } else {
      await Future.delayed(const Duration(seconds: 1));
      add(ChatWaitingEvent());
    }
  }
    
}