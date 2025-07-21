import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:apparence_kit/database/database.dart';
import 'package:apparence_kit/services/embedding_service.dart';
import 'package:apparence_kit/widgets/search_results_widget.dart';
import 'package:apparence_kit/widgets/document_upload_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class RagHomeScreen extends StatefulWidget {
  const RagHomeScreen({super.key});

  @override
  State<RagHomeScreen> createState() => _RagHomeScreenState();
}

class _RagHomeScreenState extends State<RagHomeScreen> {
  late final AppDatabase _database;
  late final EmbeddingService _embeddingService;
  
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  List<Document> _uploadedDocuments = [];
  bool _isSearching = false;
  bool _isUploading = false;
  String _statusMessage = '';
  bool _showDocuments = false;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      _database = AppDatabase();
      _embeddingService = EmbeddingService(_database);
      _initializeAndCheckPersistence();
    } else {
      _showPlatformError();
    }
  }
  
  Future<void> _initializeAndCheckPersistence() async {
    try {
      await _loadUploadedDocuments();
      final docCount = _uploadedDocuments.length;
      print('MiniLM: Loaded $docCount documents from persistent storage');
      
      if (docCount == 0) {
        setState(() {
          _statusMessage = 'No documents found. Upload documents to get started.';
        });
      } else {
        setState(() {
          _statusMessage = 'Loaded $docCount documents from storage.';
        });
      }
    } catch (e) {
      print('MiniLM: Error loading documents: $e');
      setState(() {
        _statusMessage = 'Error loading documents: $e';
      });
    }
  }
  
  Future<void> _loadUploadedDocuments() async {
    try {
      final documents = await _embeddingService.getAllDocuments();
      setState(() {
        _uploadedDocuments = documents;
      });
    } catch (e) {
      // Handle error silently or show a message
      print('Error loading documents: $e');
    }
  }

  @override
  void dispose() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _database.close();
    }
    _searchController.dispose();
    super.dispose();
  }

  void _showPlatformError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Platform Not Supported'),
        content: const Text(
          'This app is designed to run exclusively on Android devices. '
          'The MiniLM embedding functionality requires Android platform channels.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _performSearch() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      setState(() {
        _statusMessage = 'Search is only available on Android devices';
      });
      return;
    }
    
    if (_searchController.text.trim().isEmpty) return;
    
    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    try {
      final results = await _embeddingService.searchSimilar(
        _searchController.text.trim(),
        limit: 3,
      );
      setState(() {
        _searchResults = results;
        _statusMessage = 'Found ${results.length} relevant results';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Search failed: $e';
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _uploadDocument() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      setState(() {
        _statusMessage = 'Document upload is only available on Android devices';
      });
      return;
    }
    
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'md', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _isUploading = true;
          _statusMessage = 'Processing document...';
        });

        final file = File(result.files.first.path!);
        String content;
        String fileName = result.files.first.name;
        String fileType = result.files.first.extension ?? 'unknown';
        
        final fileNameLower = fileName.toLowerCase();
        if (fileNameLower.endsWith('.pdf')) {
          // Extract text from PDF
          final bytes = await file.readAsBytes();
          final document = PdfDocument(inputBytes: bytes);
          final textExtractor = PdfTextExtractor(document);
          String rawContent = textExtractor.extractText();
          document.dispose();
          
          // Clean up the extracted text for better readability
          content = _cleanExtractedText(rawContent);
        } else {
          // Read as plain text for .txt and .md files
          content = await file.readAsString();
        }
        
        await _embeddingService.addDocument(fileName, content, fileType);
        
        // Refresh the documents list
        await _loadUploadedDocuments();
        
        setState(() {
          _statusMessage = 'Document "$fileName" uploaded and processed successfully!';
        });
      }
    } catch (e) {
      setState(() {
        String errorMessage = 'Upload failed: $e';
        
        // Handle duplicate document case
        if (e.toString().contains('already exists')) {
          errorMessage = e.toString();
        }
        
        _statusMessage = errorMessage;
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  String _cleanExtractedText(String rawText) {
    if (rawText.isEmpty) return rawText;
    
    // Remove unwanted symbols like $1, $$1, etc.
    String cleaned = rawText.replaceAll(RegExp(r'\\\$+\d+'), '');
    
    // Remove other common PDF artifacts and control characters
    cleaned = cleaned.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');
    
    // Replace multiple whitespace characters with single spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    
    // More aggressive word separation for concatenated text
    // Add space between lowercase and uppercase letters
    cleaned = cleaned.replaceAll(RegExp(r'([a-z])([A-Z])'), r'\$1 \$2');
    
    // Add space between letters and numbers
    cleaned = cleaned.replaceAll(RegExp(r'([a-zA-Z])([0-9])'), r'\$1 \$2');
    cleaned = cleaned.replaceAll(RegExp(r'([0-9])([a-zA-Z])'), r'\$1 \$2');
    
    // Add space after common word endings before new words
    cleaned = cleaned.replaceAll(RegExp(r'(ing|ed|er|est|ly|tion|sion|ness|ment|able|ible)([A-Z][a-z])'), r'\$1 \$2');
    
    // Add space before common word beginnings
    cleaned = cleaned.replaceAll(RegExp(r'([a-z])(and|the|of|to|in|for|with|on|at|by|from|as|is|are|was|were|be|been|have|has|had|do|does|did|will|would|could|should|may|might|can|must)([A-Z])'), r'\$1 \$2 \$3');
    
    // Add space after periods if not followed by space
    cleaned = cleaned.replaceAll(RegExp(r'\.([a-zA-Z])'), r'. \$1');
    
    // Add space after commas if not followed by space
    cleaned = cleaned.replaceAll(RegExp(r',([a-zA-Z])'), r', \$1');
    
    // Add space after colons if not followed by space
    cleaned = cleaned.replaceAll(RegExp(r':([a-zA-Z])'), r': \$1');
    
    // Add space after semicolons if not followed by space
    cleaned = cleaned.replaceAll(RegExp(r';([a-zA-Z])'), r'; \$1');
    
    // Add space after closing parentheses if followed by letter
    cleaned = cleaned.replaceAll(RegExp(r'\)([a-zA-Z])'), r') \$1');
    
    // Add space before opening parentheses if preceded by letter
    cleaned = cleaned.replaceAll(RegExp(r'([a-zA-Z])\('), r'\$1 (');
    
    // Fix common medical/technical term patterns
    cleaned = cleaned.replaceAll(RegExp(r'([a-z])([A-Z][a-z]{2,})'), r'\$1 \$2');
    
    // Remove extra spaces and trim
    cleaned = cleaned.replaceAll(RegExp(r' +'), ' ').trim();
    
    return cleaned;
  }

  Future<void> _clearAllDocuments() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      setState(() {
        _statusMessage = 'Clear documents is only available on Android devices';
      });
      return;
    }
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Documents'),
        content: const Text('Are you sure you want to delete all documents? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _embeddingService.clearAllDocuments();
        setState(() {
          _searchResults = [];
          _statusMessage = 'All documents cleared successfully!';
        });
      } catch (e) {
        setState(() {
          _statusMessage = 'Failed to clear documents: $e';
        });
      }
    }
  }

  Future<void> _cleanCorruptedDocuments() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      setState(() {
        _statusMessage = 'Document cleanup is only available on Android devices';
      });
      return;
    }
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clean Corrupted Documents'),
        content: const Text('This will clean up documents with LaTeX artifacts (\$1, \$\$1, backslashes) that cause display issues. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clean Up'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final cleanedCount = await _embeddingService.cleanCorruptedDocuments();
        setState(() {
          _statusMessage = 'Cleaned $cleanedCount corrupted documents successfully!';
        });
      } catch (e) {
        setState(() {
          _statusMessage = 'Failed to clean documents: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MiniLM RAG System'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showDocuments ? Icons.search : Icons.folder),
            onPressed: () {
              setState(() {
                _showDocuments = !_showDocuments;
              });
            },
            tooltip: _showDocuments ? 'Show Search' : 'Show Documents',
          ),
          IconButton(
            onPressed: _cleanCorruptedDocuments,
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Clean Corrupted Documents',
          ),
          IconButton(
            onPressed: () async {
              await _clearAllDocuments();
              await _loadUploadedDocuments();
            },
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All Documents',
          ),
          IconButton(
            onPressed: _checkDatabaseIntegrity,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh & Check Database',
          ),
        ],
      ),
      body: _showDocuments ? _buildDocumentsView() : _buildSearchResultsView(),
    );
  }



  Widget _buildDocumentsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Uploaded Documents (${_uploadedDocuments.length})',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _uploadedDocuments.isEmpty
                ? const Center(
                    child: Text(
                      'No documents uploaded yet.\nUse the Upload tab to add documents.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _uploadedDocuments.length,
                    itemBuilder: (context, index) {
                      final doc = _uploadedDocuments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            doc.fileType == 'pdf' ? Icons.picture_as_pdf : Icons.description,
                            color: doc.fileType == 'pdf' ? Colors.red : Colors.blue,
                          ),
                          title: Text(doc.fileName),
                          subtitle: Text(
                             'Type: ${doc.fileType.toUpperCase()} • Size: ${doc.fileSize} bytes • Uploaded: ${doc.uploadedAt.toString().split(' ')[0]}',
                           ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteDocument(doc.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search documents',
                      hintText: 'Enter your question or search query...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSearching ? null : _performSearch,
                          child: _isSearching
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Searching...'),
                                  ],
                                )
                              : const Text('Search'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _isUploading ? null : _uploadDocument,
                        icon: _isUploading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.upload_file),
                        label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_statusMessage.isNotEmpty)
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_statusMessage)),
                  ],
                ),
              ),
            ),
          // Document persistence info
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.storage, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Documents: ${_uploadedDocuments.length} stored locally. Data persists across app restarts.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Search Results Section
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
                    child: Text(
                      'No search results yet.\nUpload documents and search to see results here.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SearchResultsWidget(results: _searchResults),
          ),
        ],
      ),
    );
  }

  Future<void> _checkDatabaseIntegrity() async {
    setState(() {
      _statusMessage = 'Checking database integrity...';
    });
    
    try {
      // Force reload from database
      await _loadUploadedDocuments();
      final docCount = _uploadedDocuments.length;
      
      // Get total chunks count for verification
      final allDocuments = await _embeddingService.getAllDocuments();
      int totalChunks = 0;
      for (final doc in allDocuments) {
        final chunks = await _database.select(_database.chunks)
          ..where((tbl) => tbl.documentId.equals(doc.id));
        totalChunks += (await chunks.get()).length;
      }
      
      setState(() {
        _statusMessage = 'Database check complete: $docCount documents, $totalChunks chunks found.';
      });
      
      print('MiniLM Database Check: $docCount documents, $totalChunks chunks');
    } catch (e) {
      setState(() {
        _statusMessage = 'Database check failed: $e';
      });
      print('MiniLM Database Check Error: $e');
    }
  }

   Future<void> _deleteDocument(int documentId) async {
     final confirmed = await showDialog<bool>(
       context: context,
       builder: (context) => AlertDialog(
         title: const Text('Delete Document'),
         content: const Text('Are you sure you want to delete this document? This will also remove all associated chunks.'),
         actions: [
           TextButton(
             onPressed: () => Navigator.of(context).pop(false),
             child: const Text('Cancel'),
           ),
           TextButton(
             onPressed: () => Navigator.of(context).pop(true),
             child: const Text('Delete'),
           ),
         ],
       ),
     );
 
     if (confirmed == true) {
       try {
         await _embeddingService.deleteDocument(documentId);
         await _loadUploadedDocuments();
         setState(() {
           _statusMessage = 'Document deleted successfully!';
         });
       } catch (e) {
         setState(() {
           _statusMessage = 'Failed to delete document: $e';
         });
       }
     }
   }
}