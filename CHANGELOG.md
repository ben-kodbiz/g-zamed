# Changelog

All notable changes to the MiniLM RAG System - Offline Medical Survival Guide for Gaza/Palestine will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release preparation
- GitHub Actions CI/CD pipeline
- Release build scripts for Windows and Unix systems
- Comprehensive documentation and contribution guidelines
- Alpha version warnings and known issues documentation

## [0.1.0-alpha] - 2024-12-19

### ⚠️ Alpha Release Notes
**This is an early alpha version with known limitations. Use with caution in critical situations.**

### Known Issues
- PDF text extraction may produce garbled/corrupted text
- Document processing reliability varies across file formats
- UI elements may have inconsistent behavior
- Search accuracy is still being optimized
- Large documents may cause performance issues

### Added
- **Core Medical RAG System**
  - Medical document upload and processing (PDF, TXT, DOCX)
  - Text chunking with intelligent medical section detection
  - MiniLM-based semantic embeddings for medical content
  - Vector similarity search with cosine similarity for medical queries
  - Hybrid search combining semantic and keyword matching for medical terms
  - Specialized for war/trauma survival in Gaza/Palestine

- **User Interface**
  - Modern Material Design 3 UI
  - Document management with upload progress
  - Real-time search with instant results
  - Search results with relevance scoring
  - Responsive design for mobile and desktop

- **Database & Storage**
  - SQLite database with Drift ORM
  - Efficient vector storage and retrieval
  - Document metadata and content indexing
  - Automatic database migrations

- **Search Features**
  - Semantic similarity search
  - Keyword-based filtering
  - Configurable similarity thresholds
  - Search result ranking and scoring
  - Section title extraction and display

- **Performance Optimizations**
  - Lazy loading of search results
  - Efficient embedding computation
  - Background document processing
  - Memory-optimized vector operations

- **Developer Experience**
  - Comprehensive error handling
  - Detailed logging and debugging
  - Code generation for database models
  - Hot reload support for development

### Technical Details
- **Framework**: Flutter 3.32.7
- **Language**: Dart 3.5.7
- **Database**: SQLite with Drift ORM
- **ML Model**: MiniLM embeddings via native Android integration
- **Architecture**: Clean architecture with service layer separation
- **Status**: Alpha - Work in Progress

### Stability Notes
- Text files (.txt) work most reliably
- PDF processing is experimental and may fail
- Always verify extracted medical information
- Recommended for testing and development only

### Dependencies
- `flutter`: ^3.32.7
- `drift`: ^2.21.0
- `file_picker`: ^8.1.4
- `path_provider`: ^2.1.5
- `vector_math`: ^2.1.4
- And other supporting packages

### Platform Support
- ✅ Android (API 21+)
- ✅ iOS (iOS 12.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Windows (Windows 10+)
- ✅ macOS (macOS 10.14+)
- ✅ Linux (Ubuntu 18.04+)

### Known Issues
- Large PDF files (>50MB) may take longer to process
- Web version has limited file system access
- iOS build requires Xcode for development

### Security
- All document processing happens locally
- No data is sent to external servers
- Secure file handling and validation
- Input sanitization for search queries

---

## Release Notes Format

For future releases, please follow this format:

### Added
- New features and capabilities

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements and fixes

---

**Legend:**
- 🚀 New Feature
- 🐛 Bug Fix
- 📚 Documentation
- ⚡ Performance
- 🔒 Security
- 💥 Breaking Change