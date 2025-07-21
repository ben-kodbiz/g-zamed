import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:apparence_kit/database/tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Documents, Chunks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Create the new Documents table
        await m.createTable(documents);
        
        // Add documentId column to chunks table
        await m.addColumn(chunks, chunks.documentId);
      }
      if (from < 3) {
        // Add title column to chunks table
        await m.addColumn(chunks, chunks.title);
      }
    },
  );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'minilm_rag.db'));
      
      // Debug: Print database path for troubleshooting
      print('MiniLM Database path: ${file.path}');
      
      // Ensure the directory exists
      if (!await dbFolder.exists()) {
        await dbFolder.create(recursive: true);
      }
      
      return NativeDatabase.createInBackground(file);
    });
  }

  /// Generate SHA-256 hash for file content
  String _generateFileHash(String content) {
    final bytes = utf8.encode(content);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Check if document already exists by hash
  Future<Document?> getDocumentByHash(String fileHash) async {
    final query = select(documents)..where((tbl) => tbl.fileHash.equals(fileHash));
    final results = await query.get();
    return results.isNotEmpty ? results.first : null;
  }
  
  /// Insert a new document and return its ID
  Future<int> insertDocument(String fileName, String content, int fileSize, String fileType) async {
    final fileHash = _generateFileHash(content);
    
    // Check if document already exists
    final existingDoc = await getDocumentByHash(fileHash);
    if (existingDoc != null) {
      throw DocumentAlreadyExistsException(existingDoc.fileName, existingDoc.uploadedAt);
    }
    
    return await into(documents).insert(DocumentsCompanion(
      fileName: Value(fileName),
      fileHash: Value(fileHash),
      fileSize: Value(fileSize),
      fileType: Value(fileType),
    ));
  }
  
  /// Insert chunk with document reference and optional title
  Future<int> insertChunk(String content, List<double> embedding, int documentId, {String? title}) async {
    final embeddingBytes = Uint8List.fromList(_floatListToBytes(embedding));
    return await into(chunks).insert(ChunksCompanion(
      documentId: Value(documentId),
      content: Value(content),
      title: Value(title),
      embedding: Value(embeddingBytes),
    ));
  }
  
  /// Get all uploaded documents
  Future<List<Document>> getAllDocuments() async {
    return await select(documents).get();
  }
  
  /// Get chunks for a specific document
  Future<List<Chunk>> getChunksByDocumentId(int documentId) async {
    final query = select(chunks)..where((tbl) => tbl.documentId.equals(documentId));
    return await query.get();
  }
  
  /// Delete a document and all its associated chunks
  Future<void> deleteDocument(int documentId) async {
    // First delete all chunks associated with this document
    await (delete(chunks)..where((tbl) => tbl.documentId.equals(documentId))).go();
    
    // Then delete the document itself
    await (delete(documents)..where((tbl) => tbl.id.equals(documentId))).go();
  }

  Future<List<Chunk>> getAllChunks() async {
    return await select(chunks).get();
  }

  Future<void> clearAllDocuments() async {
    await delete(chunks).go();
    await delete(documents).go();
  }

  /// Clean up existing corrupted documents with LaTeX artifacts
  Future<int> cleanCorruptedDocuments() async {
    // Find documents with LaTeX artifacts
    final corruptedChunks = await (select(chunks)
      ..where((tbl) => tbl.content.like('%\$%') | 
                      tbl.content.like('%\\%') |
                      tbl.content.like('%\$\$%'))).get();
    
    int cleanedCount = 0;
    
    for (final chunk in corruptedChunks) {
      String cleanedContent = _cleanCorruptedText(chunk.content);
      
      // Skip if cleaned content is too short or empty
      if (cleanedContent.length < 10 || !cleanedContent.contains(RegExp(r'[a-zA-Z]{3,}'))) {
        // Delete the corrupted chunk
        await (delete(chunks)..where((tbl) => tbl.id.equals(chunk.id))).go();
        cleanedCount++;
        continue;
      }
      
      // Update with cleaned content
      await (update(chunks)..where((tbl) => tbl.id.equals(chunk.id)))
        .write(ChunksCompanion(content: Value(cleanedContent)));
      cleanedCount++;
    }
    
    return cleanedCount;
  }
  
  /// Clean corrupted text using similar logic to Android side
  String _cleanCorruptedText(String text) {
    String cleaned = text;
    
    // Remove LaTeX/markup artifacts
    cleaned = cleaned.replaceAll(RegExp(r'\$+\d+'), ''); // Remove $1, $$1, etc.
    cleaned = cleaned.replaceAll(RegExp(r'\$\{[^}]*\}'), ''); // Remove ${...} patterns
    cleaned = cleaned.replaceAll(RegExp(r'\\+'), ''); // Remove all backslashes
    cleaned = cleaned.replaceAll(RegExp(r'\$+[a-zA-Z]*\d*'), ''); // Remove $latero, $Riv, etc.
    
    // Remove non-printable characters
    cleaned = cleaned.replaceAll(RegExp(r'[^\x20-\x7E\x0A\x0D\x09]'), '');
    
    // Normalize spacing
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    cleaned = cleaned.trim();
    
    return cleaned;
  }

  List<int> _floatListToBytes(List<double> floats) {
    final bytes = <int>[];
    for (final float in floats) {
      final buffer = Float32List.fromList([float.toDouble()]);
      final byteData = buffer.buffer.asByteData();
      for (int i = 0; i < 4; i++) {
        bytes.add(byteData.getUint8(i));
      }
    }
    return bytes;
  }

  List<double> bytesToFloatList(List<int> bytes) {
    final floats = <double>[];
    for (int i = 0; i < bytes.length; i += 4) {
      final byteData = ByteData(4);
      for (int j = 0; j < 4; j++) {
        byteData.setUint8(j, bytes[i + j]);
      }
      floats.add(byteData.getFloat32(0, Endian.little));
    }
    return floats;
  }
}

/// Exception thrown when trying to upload a document that already exists
class DocumentAlreadyExistsException implements Exception {
  final String fileName;
  final DateTime uploadedAt;
  
  DocumentAlreadyExistsException(this.fileName, this.uploadedAt);
  
  @override
  String toString() {
    return 'Document "$fileName" already exists (uploaded on ${uploadedAt.toString().split('.')[0]})';
  }
}