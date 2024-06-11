import 'package:chatty/Const.dart';
import 'package:chatty/pages/ChatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  runApp(const MyApp());
  Gemini.init(apiKey: keyApi);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: ChatPage());
  }
}
