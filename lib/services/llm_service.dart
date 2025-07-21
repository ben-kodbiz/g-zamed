import 'package:fllama/fllama.dart';

class LLMService {
  static const String _modelPath = "assets/models/llm/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf";
  
  /// Builds a medical prompt template for emergency/trauma scenarios
  String buildMedicalPrompt(String userQuery, String context) {
    return '''
You are an offline emergency medical assistant for Gaza/Palestine trauma survival.

Medical Context:
$context

Question: $userQuery

Provide clear, step-by-step medical guidance for emergency situations. Focus on immediate life-saving actions.
''';
  }

  /// Runs TinyLLaMA chat with medical context and returns the complete response
  Future<String> runTinyLlamaChat(String query, String context) async {
    try {
      final prompt = buildMedicalPrompt(query, context);
      String response = '';

      final request = OpenAiRequest(
        modelPath: _modelPath,
        messages: [
          Message(Role.system, "You are a helpful emergency medical assistant specialized in trauma care and field medicine for Gaza/Palestine."),
          Message(Role.user, prompt),
        ],
        maxTokens: 256,
        temperature: 0.7,
      );

      await fllamaChat(request, (chunk, messageId, done) {
        if (!done) {
          response += chunk;
        }
      });
      
      return response.trim();
    } catch (e) {
      throw Exception('Error generating LLM response: $e');
    }
  }

  /// Builds specialized prompts for different medical scenarios
  String buildSpecializedPrompt(String userQuery, String context, MedicalScenario scenario) {
    String systemPrompt;
    switch (scenario) {
      case MedicalScenario.trauma:
        systemPrompt = "You are a trauma specialist for Gaza/Palestine. Focus on immediate life-saving interventions with limited resources.";
        break;
      case MedicalScenario.triage:
        systemPrompt = "You are a triage expert for Gaza/Palestine. Prioritize patients based on severity and survivability in mass casualty situations.";
        break;
      case MedicalScenario.burns:
        systemPrompt = "You are a burn specialist for Gaza/Palestine. Focus on burn assessment and treatment with limited supplies.";
        break;
      case MedicalScenario.infectious:
        systemPrompt = "You are an infectious disease specialist for Gaza/Palestine. Focus on containment and treatment in crowded conditions.";
        break;
      case MedicalScenario.general:
      default:
        systemPrompt = "You are a general emergency medical assistant for Gaza/Palestine.";
        break;
    }

    return '''
$systemPrompt

Medical Context:
$context

Question: $userQuery

Provide clear, actionable medical guidance for emergency situations in Gaza/Palestine.
''';
  }

  /// Runs specialized medical chat and returns the complete response
  Future<String> runSpecializedChat(
    String query,
    String context,
    MedicalScenario scenario,
  ) async {
    try {
      final prompt = buildSpecializedPrompt(query, context, scenario);
      String response = '';

      final request = OpenAiRequest(
        modelPath: _modelPath,
        messages: [
          Message(Role.user, prompt),
        ],
        maxTokens: 256,
        temperature: 0.7,
      );

      await fllamaChat(request, (chunk, messageId, done) {
        if (!done) {
          response += chunk;
        }
      });
      
      return response.trim();
    } catch (e) {
      throw Exception('Error generating specialized response: $e');
    }
  }
}

/// Medical scenario types for specialized prompts
enum MedicalScenario {
  general,
  trauma,
  triage,
  burns,
  infectious,
}

/// Extension to get display names for medical scenarios
extension MedicalScenarioExtension on MedicalScenario {
  String get displayName {
    switch (this) {
      case MedicalScenario.general:
        return 'General Medical';
      case MedicalScenario.trauma:
        return 'Trauma Care';
      case MedicalScenario.triage:
        return 'Triage Assessment';
      case MedicalScenario.burns:
        return 'Burn Treatment';
      case MedicalScenario.infectious:
        return 'Infectious Disease';
    }
  }

  String get icon {
    switch (this) {
      case MedicalScenario.general:
        return '🏥';
      case MedicalScenario.trauma:
        return '🚑';
      case MedicalScenario.triage:
        return '🔺';
      case MedicalScenario.burns:
        return '🧯';
      case MedicalScenario.infectious:
        return '🧬';
    }
  }
}