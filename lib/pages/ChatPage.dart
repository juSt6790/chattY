import "package:dash_chat_2/dash_chat_2.dart";
import "package:flutter/material.dart";
import "package:flutter_gemini/flutter_gemini.dart";

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'juSt');
  final ChatUser _gpt = ChatUser(id: '2', firstName: 'chattY');
  List<ChatMessage> _messages = [];
  final List<ChatUser> _typing = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 81, 125, 247),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'chattY',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: Color.fromARGB(255, 72, 101, 180),
      ),
      body: DashChat(
          currentUser: _currentUser,
          typingUsers: _typing,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Color.fromARGB(255, 255, 250, 183),
            currentUserTextColor: Color.fromARGB(255, 0, 0, 0),
            containerColor: Color.fromARGB(255, 255, 203, 223),
            textColor: Color.fromARGB(255, 0, 0, 0),
          ),
          onSend: _sendMessage,
          messages: _messages),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      _messages = [chatMessage, ..._messages];
      _typing.add(_gpt);
    });
    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = _messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == _gpt) {
          lastMessage = _messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  '', (previous, current) => "$previous ${current.text}") ??
              '';
          _typing;
          lastMessage.text += response;
          setState(() {
            _messages = [lastMessage!, ..._messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  '', (previous, current) => "$previous${current.text}") ??
              '';
          ChatMessage message = ChatMessage(
              user: _gpt, createdAt: DateTime.now(), text: response);
          setState(() {
            _messages = [message, ..._messages];
          });
        }
        setState(() {
          _typing.remove(_gpt);
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
