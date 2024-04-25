import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';

import '../../blocs/chat_bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final bool isStudent = true;

  late final ChatBloc _chatBloc;


  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.add(InitializeChatEvent()); 
    _messages.add(SystemMessage(
      text: 'Connecting you with a brigadier...',
      timestamp: DateTime.now(),
    ));
  }

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(BubbleMessage(
          text: text,
          timestamp: DateTime.now(),
          isCurrentUser: true,
        ));
        _messageController.clear();
        
        _chatBloc.add(SendMessageEvent(text));

        // Add a system message when the chat starts
        if (_messages.length == 1) {
          _messages.add(SystemMessage(
            text: 'We are connecting you to a brigadier...',
            timestamp: DateTime.now(),
          ));
        }
      });
    }
  }

  void _brigadierJoined(String name) {
    setState(() {
      _messages.add(SystemMessage(
        text: '$name joined the chat',
        timestamp: DateTime.now(),
      ));
    });
  }

  List<Message> transformMessages(List<ChatMessage> messages) {
    List<Message> viewMessages = [];
    for (var message in messages) {
      var viewMessage = transformMessage(message);
      var alreadyRendered = false;
      for (var _message in _messages) {
        if (_message.text == viewMessage.text) {
          alreadyRendered = true;
          break;
        }
      }
      if (alreadyRendered) {
        continue;
      } else {
        viewMessages.add(viewMessage);
      }
    }
    return viewMessages;
  }

  Message transformMessage(ChatMessage message) {
    if (message.message == 'HELPISNEEDED') {
      return NoRenderMessessage(text: message.message, timestamp: message.timestamp);
    }
    return BubbleMessage(
      text: message.message,
      timestamp: message.timestamp,
      isCurrentUser: message.from == _chatBloc.currentUser?.uid,
    );
  }


  @override
  Widget build(BuildContext _context_) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatMessageReceivedState) {
          setState(() {
            _messages.addAll(transformMessages(state.messages));
          });
        } else if (state is ChatErrorState) {
          // Display the error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is ChatSecondUserFetchedState) {
          _brigadierJoined('Brigadier');
        } else if (state is ChatMessagesLoadedState) {
          setState(() {
            _messages.addAll(transformMessages(state.messages));
          });
        }

      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 38, 38), // Dark grey background
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title row
          children: [
            Icon(
              Icons.account_circle, // Icon above the text
              color: Colors.white, // Icon color
            ),
            SizedBox(width: 8), // Spacing between icon and text
            Text(
              'Student Brigade Uniandes',
              style: TextStyle(
                color: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_context_, _index_) {
                final message = _messages[_index_];
                if (message is SystemMessage) {
                  return SystemMessageWidget(message: message);
                } else if (message is BubbleMessage) {
                  return ChatBubble(message: message);
                } else {
                  return Container();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    )
  );
  }
}

abstract class Message{
  final String text;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.timestamp,
  });
}

class BubbleMessage extends Message {
  final bool isCurrentUser;

  BubbleMessage({
    required super.text,
    required super.timestamp,
    required this.isCurrentUser,
  });
}

class SystemMessage extends Message {
  SystemMessage({
    required super.text,
    required super.timestamp,
  });
}

class NoRenderMessessage extends Message {
  NoRenderMessessage({
    required super.text,
    required super.timestamp,
  });
}


class ChatBubble extends StatelessWidget {
  final BubbleMessage message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: message.isCurrentUser ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isCurrentUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class SystemMessageWidget extends StatelessWidget {
  final SystemMessage message;

  SystemMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          message.text,
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

