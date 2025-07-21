import 'dart:io';
import 'package:apparence_kit/services/llm_service.dart';

void main() async {
  print('Testing TinyLLaMA Integration...');
  
  try {
    final llmService = LLMService();
    
    // Test basic medical prompt
    final testQuery = 'What should I do for a bleeding wound?';
    final testContext = 'Apply direct pressure to the wound with a clean cloth. Elevate the injured area if possible.';
    
    print('Query: $testQuery');
    print('Context: $testContext');
    print('\nGenerating response...');
    
    final response = await llmService.runTinyLlamaChat(testQuery, testContext);
    
    print('\nLLM Response:');
    print('=' * 50);
    print(response);
    print('=' * 50);
    
    print('\nTinyLLaMA integration test completed successfully!');
    
  } catch (e) {
    print('Error during LLM integration test: $e');
    exit(1);
  }
}