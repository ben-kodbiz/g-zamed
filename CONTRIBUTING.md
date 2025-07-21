# Contributing to MiniLM RAG System

Thank you for your interest in contributing to the MiniLM RAG System! This document provides guidelines for contributing to the project.

## Getting Started

### Prerequisites
- Flutter SDK 3.32.7 or later
- Dart SDK 3.5.7 or later
- Android Studio or VS Code with Flutter extensions
- Git

### Setting Up Development Environment

1. **Fork and Clone**
   ```bash
   git clone https://github.com/yourusername/minilm-rag-system.git
   cd minilm-rag-system
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   dart run build_runner build
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Development Workflow

### Branch Naming Convention
- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Critical fixes
- `docs/description` - Documentation updates

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format .` before committing
- Run `flutter analyze` to check for issues
- Maintain test coverage above 80%

### Commit Messages
Use conventional commit format:
```
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat(search): add semantic search with keyword filtering

Implemented hybrid search combining semantic similarity with keyword matching.
Added configurable similarity threshold and keyword boost parameters.

Closes #123
```

## Code Guidelines

### Architecture
- Follow the existing layered architecture:
  - `lib/screens/` - UI screens
  - `lib/widgets/` - Reusable UI components
  - `lib/services/` - Business logic and external integrations
  - `lib/database/` - Data persistence layer
  - `lib/models/` - Data models

### Database Changes
- Update schema in `lib/database/tables.dart`
- Run `dart run build_runner build` after schema changes
- Include migration scripts if needed

### Testing
- Write unit tests for all business logic
- Add widget tests for UI components
- Include integration tests for critical flows
- Run tests with `flutter test`

### Documentation
- Update README.md for user-facing changes
- Add inline documentation for complex functions
- Update API documentation for service changes

## Pull Request Process

1. **Before Submitting**
   - Ensure all tests pass
   - Run `flutter analyze` with no issues
   - Update documentation if needed
   - Rebase on latest main branch

2. **PR Description**
   - Clearly describe the changes
   - Reference related issues
   - Include screenshots for UI changes
   - List breaking changes if any

3. **Review Process**
   - PRs require at least one approval
   - Address all review comments
   - Maintain clean commit history

## Issue Reporting

### Bug Reports
Include:
- Flutter version (`flutter --version`)
- Device/OS information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs if applicable

### Feature Requests
Include:
- Clear description of the feature
- Use case and motivation
- Proposed implementation approach
- Potential impact on existing features

## Development Tips

### Hot Reload
- Use `r` for hot reload during development
- Use `R` for hot restart when needed
- Use `q` to quit the development server

### Debugging
- Use Flutter Inspector for widget debugging
- Add `debugPrint()` statements for logging
- Use breakpoints in your IDE

### Performance
- Profile app performance with `flutter run --profile`
- Use `flutter analyze --suggestions` for optimization hints
- Monitor memory usage during development

## Release Process

### Version Bumping
1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create release tag
4. GitHub Actions will handle building and deployment

### Release Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Version bumped
- [ ] Changelog updated
- [ ] Release notes prepared

## Getting Help

- **Documentation**: Check the README.md first
- **Issues**: Search existing issues before creating new ones
- **Discussions**: Use GitHub Discussions for questions
- **Code Review**: Tag maintainers for urgent reviews

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you are expected to uphold this code.

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing! 🚀