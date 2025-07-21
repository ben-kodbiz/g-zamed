import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:apparence_kit/database/database.dart';

class EmbeddingService {
  static const platform = MethodChannel('com.example.minilm/embedding');
  final AppDatabase _database;

  EmbeddingService(this._database);

  Future<List<double>> getEmbedding(String text) async {
    try {
      final result = await platform.invokeMethod('getEmbedding', {"text": text});
      return List<double>.from(result.map((x) => x.toDouble()));
    } on PlatformException catch (e) {
      throw Exception('Failed to get embedding: ${e.message}');
    }
  }

  Future<void> addDocument(String fileName, String content, String fileType) async {
    try {
      // Calculate file size
      final fileSize = utf8.encode(content).length;
      
      // Insert document and get its ID
      final documentId = await _database.insertDocument(fileName, content, fileSize, fileType);
      
      // Split content into chunks with titles and process each
      final chunksWithTitles = _splitIntoChunksWithTitles(content);
      
      for (final chunkData in chunksWithTitles) {
        if (chunkData['content']!.trim().isNotEmpty) {
          final embedding = await getEmbedding(chunkData['content']!);
          await _database.insertChunk(
            chunkData['content']!, 
            embedding, 
            documentId, 
            title: chunkData['title']
          );
        }
      }
    } catch (e) {
      // Re-throw the exception to be handled by the UI
      rethrow;
    }
  }

  Future<List<SearchResult>> searchSimilar(String query, {int limit = 5}) async {
    final queryEmbedding = await getEmbedding(query);
    final allChunks = await _database.getAllChunks();
    
    final results = <SearchResult>[];
    for (final chunk in allChunks) {
      final chunkEmbedding = _database.bytesToFloatList(chunk.embedding);
      final similarity = _cosineSimilarity(queryEmbedding, chunkEmbedding);
      results.add(SearchResult(
        content: chunk.content,
        similarity: similarity,
        id: chunk.id,
        title: chunk.title,
      ));
    }
    
    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    
    // Apply keyword filtering for better relevance
    final filteredResults = _applyKeywordFilter(results, query);
    
    return filteredResults.take(limit).toList();
  }

  /// Split text into chunks with extracted titles/section headings
  List<Map<String, String?>> _splitIntoChunksWithTitles(String text, {int maxChunkSize = 500}) {
    final lines = text.split('\n');
    final chunks = <Map<String, String?>>[];
    String currentChunk = '';
    String? currentTitle;
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;
      
      // Try to extract section titles (headings, numbered sections, etc.)
      final extractedTitle = _extractSectionTitle(trimmedLine);
      if (extractedTitle != null) {
        // Save previous chunk if it exists
        if (currentChunk.isNotEmpty) {
          chunks.add({
            'content': currentChunk.trim(),
            'title': currentTitle,
          });
          currentChunk = '';
        }
        currentTitle = extractedTitle;
        continue;
      }
      
      // Add line to current chunk
      if (currentChunk.length + trimmedLine.length > maxChunkSize) {
        if (currentChunk.isNotEmpty) {
          chunks.add({
            'content': currentChunk.trim(),
            'title': currentTitle,
          });
          currentChunk = '';
        }
      }
      currentChunk += trimmedLine + ' ';
    }
    
    // Add final chunk
    if (currentChunk.isNotEmpty) {
      chunks.add({
        'content': currentChunk.trim(),
        'title': currentTitle,
      });
    }
    
    return chunks;
  }
  
  /// Extract section titles from text lines
  String? _extractSectionTitle(String line) {
    // Match numbered sections (1., 2.1, etc.)
    if (RegExp(r'^\d+(\.\d+)*\.?\s+[A-Z]').hasMatch(line)) {
      return line.length > 100 ? line.substring(0, 100) + '...' : line;
    }
    
    // Match all caps headings
    if (RegExp(r'^[A-Z\s]{3,}$').hasMatch(line) && line.length < 50) {
      return line;
    }
    
    // Match medical/procedural keywords
    final medicalKeywords = [
      'bleeding', 'hemorrhage', 'wound', 'injury', 'treatment', 'procedure',
      'emergency', 'first aid', 'control', 'management', 'care', 'assessment'
    ];
    
    final lowerLine = line.toLowerCase();
    if (medicalKeywords.any((keyword) => lowerLine.contains(keyword)) && 
        line.length < 100 && 
        RegExp(r'^[A-Z]').hasMatch(line)) {
      return line;
    }
    
    return null;
  }
  
  /// Apply keyword filtering to improve search relevance
  List<SearchResult> _applyKeywordFilter(List<SearchResult> results, String query) {
    final queryWords = query.toLowerCase().split(' ');
    
    // Define medical action keywords for emergency queries
    final actionKeywords = {
      'bleeding': ['pressure', 'apply', 'direct', 'tourniquet', 'bandage', 'compress'],
      'wound': ['clean', 'dress', 'bandage', 'antiseptic', 'suture'],
      'emergency': ['immediate', 'urgent', 'call', 'help', 'ambulance'],
      'pain': ['relief', 'medication', 'ice', 'heat', 'rest'],
    };
    
    // Score results based on keyword relevance
    final scoredResults = results.map((result) {
      double keywordScore = 0.0;
      final contentLower = result.content.toLowerCase();
      final titleLower = result.title?.toLowerCase() ?? '';
      
      // Boost score for action-oriented content
      for (final queryWord in queryWords) {
        if (actionKeywords.containsKey(queryWord)) {
          for (final actionWord in actionKeywords[queryWord]!) {
            if (contentLower.contains(actionWord)) {
              keywordScore += 0.3;
            }
            if (titleLower.contains(actionWord)) {
              keywordScore += 0.2;
            }
          }
        }
        
        // Direct keyword matches
        if (contentLower.contains(queryWord)) {
          keywordScore += 0.1;
        }
        if (titleLower.contains(queryWord)) {
          keywordScore += 0.15;
        }
      }
      
      // Penalize anatomical/descriptive content for action queries
      final anatomicalTerms = ['anatomy', 'structure', 'muscle', 'bone', 'tissue', 'organ'];
      if (queryWords.any((word) => ['how', 'stop', 'treat', 'help'].contains(word))) {
        for (final term in anatomicalTerms) {
          if (contentLower.contains(term)) {
            keywordScore -= 0.2;
          }
        }
      }
      
      return {
        'result': result,
        'combinedScore': result.similarity + keywordScore,
      };
    }).toList();
    
    // Sort by combined score and return results
    scoredResults.sort((a, b) => (b['combinedScore']! as double).compareTo(a['combinedScore']! as double));
    return scoredResults.map((item) => item['result'] as SearchResult).toList();
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must have the same length');
    }
    
    double dot = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    
    if (normA == 0.0 || normB == 0.0) {
      return 0.0;
    }
    
    return dot / (sqrt(normA) * sqrt(normB));
  }

  Future<void> clearAllDocuments() async {
    await _database.clearAllDocuments();
  }
  
  /// Get all uploaded documents
  Future<List<Document>> getAllDocuments() async {
    return await _database.getAllDocuments();
  }
  
  /// Delete a document and all its associated chunks
  Future<void> deleteDocument(int documentId) async {
    await _database.deleteDocument(documentId);
  }

  /// Clean up existing corrupted documents with LaTeX artifacts
  Future<int> cleanCorruptedDocuments() async {
    return await _database.cleanCorruptedDocuments();
  }
}

class SearchResult {
  final String content;
  final double similarity;
  final int id;
  final String? title;
  final int? documentId;
  final String? fileName;

  SearchResult({
    required this.content,
    required this.similarity,
    required this.id,
    this.title,
    this.documentId,
    this.fileName,
  });
}