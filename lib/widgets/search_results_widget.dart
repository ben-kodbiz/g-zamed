import 'package:flutter/material.dart';
import 'package:apparence_kit/services/embedding_service.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<SearchResult> results;

  const SearchResultsWidget({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try uploading some documents first or refine your search query.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result.title != null && result.title!.isNotEmpty) ...[
                        Text(
                          result.title!,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      SelectableText(
                        _getPreview(result.content),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildSimilarityChip(result.similarity),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Content:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: SelectableText(
                        _formatContent(result.content),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Similarity: ${(result.similarity * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'ID: ${result.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getPreview(String content, {int maxLength = 100}) {
    final formatted = _formatContent(content);
    if (formatted.length <= maxLength) {
      return formatted;
    }
    return '${formatted.substring(0, maxLength)}...';
  }

  String _formatContent(String content) {
    if (content.isEmpty) return content;
    
    // Remove all line breaks and paragraph breaks
    String formatted = content.replaceAll(RegExp(r'\n+'), ' ');
    formatted = formatted.replaceAll(RegExp(r'\r+'), ' ');
    
    // Replace multiple spaces with single space
    formatted = formatted.replaceAll(RegExp(r'\s+'), ' ');
    
    // Trim whitespace
    formatted = formatted.trim();
    
    return formatted;
  }

  Widget _buildSimilarityChip(double similarity) {
    final percentage = (similarity * 100).round();
    Color chipColor;
    
    if (percentage >= 80) {
      chipColor = Colors.green;
    } else if (percentage >= 60) {
      chipColor = Colors.orange;
    } else {
      chipColor = Colors.red;
    }

    return Chip(
      label: Text(
        '${percentage}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}