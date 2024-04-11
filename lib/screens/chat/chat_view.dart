import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:shake/shake.dart';

import '../../blocs/chat_bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

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
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        print('Phone shook!');
        _shakeDialog();
        // Do stuff on phone shake
        },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
    // _brigadierJoined('Brigadier 1');
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
    return messages.map((message) {
      return BubbleMessage(
        text: message.message,
        timestamp: message.timestamp,
        isCurrentUser: message.from == _chatBloc.currentUser?.uid,
      );
    }).toList();
  }

  Future<void> _shakeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you ok?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The phone was shaken.'),
                Text('Help will be called if you do not respond.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('I am ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

abstract class Message {
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

