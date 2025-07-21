
import 'package:flutter/material.dart';
import 'package:apparence_kit/screens/rag_home_screen.dart';
import 'package:apparence_kit/database/database.dart';
import 'package:apparence_kit/services/embedding_service.dart';

void main() {
  runApp(const MiniLMApp());
}

class MiniLMApp extends StatelessWidget {
  const MiniLMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniLM RAG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RagHomeScreen(),
    );
  }
}
