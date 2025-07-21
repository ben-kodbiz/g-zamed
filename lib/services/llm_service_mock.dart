/// Mock LLM Service for testing and development on non-Android platforms
class MockLLMService {
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

  /// Mock TinyLLaMA chat response for testing
  Future<String> runTinyLlamaChat(String query, String context) async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate a mock medical response based on the query
    if (query.toLowerCase().contains('bleeding') || query.toLowerCase().contains('wound')) {
      return '''
For bleeding wounds:

1. **Immediate Action**: Apply direct pressure with clean cloth/gauze
2. **Elevation**: Raise the injured area above heart level if possible
3. **Pressure Points**: If bleeding continues, apply pressure to arterial pressure points
4. **Tourniquet**: Only as last resort for severe limb bleeding
5. **Monitor**: Watch for signs of shock (pale skin, rapid pulse, weakness)

⚠️ Seek professional medical help immediately if available.
''';
    } else if (query.toLowerCase().contains('burn')) {
      return '''
For burn treatment:

1. **Cool the Burn**: Use cool (not cold) water for 10-20 minutes
2. **Remove**: Take off jewelry/clothing near burn before swelling
3. **Cover**: Use sterile gauze or clean cloth - do not use cotton
4. **Pain Relief**: Over-the-counter pain medication if available
5. **Hydration**: Give fluids if person is conscious and not vomiting

⚠️ For severe burns (>3 inches or on face/hands/genitals), seek immediate medical care.
''';
    } else if (query.toLowerCase().contains('fracture') || query.toLowerCase().contains('broken')) {
      return '''
For suspected fractures:

1. **Immobilize**: Don't move the injured area
2. **Splint**: Use rigid materials to support the injury
3. **Ice**: Apply ice wrapped in cloth for 15-20 minutes
4. **Elevation**: Raise the injured area if possible
5. **Pain Management**: Give pain medication if available and conscious

⚠️ Do not attempt to realign bones. Seek medical attention immediately.
''';
    } else {
      return '''
Based on the medical context provided:

1. **Assess the Situation**: Ensure scene safety first
2. **Check Vital Signs**: Breathing, pulse, consciousness level
3. **Prioritize Treatment**: Address life-threatening conditions first
4. **Apply First Aid**: Use available medical supplies appropriately
5. **Monitor Patient**: Watch for changes in condition
6. **Prepare for Transport**: If evacuation is possible

⚠️ This is AI-generated guidance for emergency reference only. Professional medical judgment is always preferred when available.
''';
    }
  }

  /// Mock specialized medical chat response
  Future<String> runSpecializedChat(
    String query,
    String context,
    MedicalScenario scenario,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    
    switch (scenario) {
      case MedicalScenario.trauma:
        return 'TRAUMA PROTOCOL: Assess ABC (Airway, Breathing, Circulation). Control bleeding. Immobilize spine if suspected injury.';
      case MedicalScenario.triage:
        return 'TRIAGE ASSESSMENT: Red (immediate), Yellow (delayed), Green (minor), Black (deceased/expectant). Prioritize based on survivability.';
      case MedicalScenario.burns:
        return 'BURN ASSESSMENT: Rule of 9s for area calculation. Cool with water, cover with sterile dressing, manage pain and fluid loss.';
      case MedicalScenario.infectious:
        return 'INFECTION CONTROL: Isolate if possible, use PPE, maintain hygiene, monitor for fever and symptoms.';
      case MedicalScenario.general:
      default:
        return 'GENERAL MEDICAL: Follow standard first aid protocols. Assess, treat, monitor, and prepare for evacuation if needed.';
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