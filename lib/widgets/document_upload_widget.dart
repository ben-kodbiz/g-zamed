import 'package:flutter/material.dart';

class DocumentUploadWidget extends StatelessWidget {
  final VoidCallback onUpload;
  final bool isUploading;

  const DocumentUploadWidget({
    super.key,
    required this.onUpload,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 64,
              color: isUploading 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              isUploading ? 'Processing Document...' : 'Upload Document',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUploading 
                  ? 'Please wait while we process and embed your document.'
                  : 'Select a text or markdown file to add to your knowledge base.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            if (isUploading)
              Column(
                children: [
                  const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'This may take a few moments depending on document size...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Choose File'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}