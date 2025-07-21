import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:apparence_kit/screens/rag_home_screen.dart';

void main() {
  runApp(const MiniLMApp());
}

class MiniLMApp extends StatelessWidget {
  const MiniLMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniLM RAG App - Web Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: kIsWeb 
        ? const WebDemoScreen()
        : const RagHomeScreen(),
    );
  }
}

class WebDemoScreen extends StatelessWidget {
  const WebDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MiniLM + TinyLLaMA RAG Demo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🧠 TinyLLaMA + MiniLM RAG Integration',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This is a web demo of the medical RAG system. The full functionality is available on Android devices.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Features implemented:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('✅ MiniLM embeddings for document search'),
                    Text('✅ TinyLLaMA integration for AI responses'),
                    Text('✅ SQLite database for document storage'),
                    Text('✅ PDF document upload and processing'),
                    Text('✅ Medical-focused prompt templates'),
                    Text('✅ Mock services for cross-platform testing'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📱 Android Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('• Real-time document embedding with MiniLM'),
                    Text('• TinyLLaMA chat for medical assistance'),
                    Text('• Offline operation for Gaza/Palestine context'),
                    Text('• PDF text extraction and chunking'),
                    Text('• Semantic search with cosine similarity'),
                    Text('• AI-enhanced medical responses'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ Web Limitations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Native Android features not available on web'),
                    Text('• SQLite FFI not supported in web browsers'),
                    Text('• TinyLLaMA requires native Android runtime'),
                    Text('• Full functionality requires Android APK build'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}