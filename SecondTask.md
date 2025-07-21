Perfect — since your system **already uses MiniLM** for embeddings and chunk retrieval via SQLite, we’ll **keep MiniLM** in the pipeline and **add TinyLLaMA only for generation** (after top-k chunk retrieval). Here's the updated, detailed plan tailored for your `g-zamed` repo with both components.

---

## 📄 `TINYLLAMA_MINILM_RAG_PLAN.md`

````markdown
# 🧠 TinyLLaMA + MiniLM RAG Integration Plan for g-zamed

This document describes how to integrate **TinyLLaMA** for answer generation while **retaining MiniLM** for embeddings + retrieval using SQLite. The goal: create an **offline medical/triage assistant** optimized for low-resource Android phones in Gaza.

---

## ⚙️ System Overview

| Component | Role |
|----------|------|
| **MiniLM (ONNX)** | Sentence embeddings for document chunks + queries |
| **SQLite** | Store embeddings & metadata locally |
| **TinyLLaMA (GGUF)** | Generates human-like, helpful answers from retrieved context |
| **Flutter** | Frontend + Controller |
| **Kotlin** | ONNX Runtime MiniLM backend |

---

## 🚀 Phase 0: Setup

- [ ] Create branch: `tinyllama-integration`
- [ ] Download TinyLLaMA model (e.g. `Q4_K_M`) from:
  [https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF](https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF)
- [ ] Place it in: `flutter_app/assets/models/llm/`
- [ ] Add to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/models/llm/TinyLlama-1.1B-Chat-v1.0.Q4_K_M.gguf
````

---

## 🔌 Phase 1: Keep MiniLM Embedding Flow (No Change)

**Preserve your current pipeline**:

1. User uploads PDFs
2. You split chunks + embed each with MiniLM (via Kotlin ONNX runtime)
3. Store: `embedding`, `chunk`, `doc title`, `ID` → SQLite

✅ This works and remains unchanged.

---

## 🔍 Phase 2: Search Pipeline

🟣 On search query:

1. Get embedding from MiniLM (via Kotlin/ONNX)
2. Perform cosine similarity in Dart/Flutter using SQLite
3. Retrieve **top K most relevant chunks** (e.g. 3–5)

✅ Output: `List<String> topChunks`

---

## 🧠 Phase 3: Add TinyLLaMA via fllama

### 3.1 Add Dependency

```yaml
dependencies:
  fllama:
    git:
      url: https://github.com/Telosnex/fllama.git
```

* [ ] Run `flutter pub get`
* [ ] Update Android `minSdkVersion` to **21+** in `android/app/build.gradle`

### 3.2 Prompt Template for Medical Agent

```dart
String buildMedicalPrompt(List<String> chunks, String userQuery) {
  final context = chunks.map((c) => '- $c').join('\n');

  return '''
You are an offline emergency medical assistant trained in trauma, triage, and field survival.

Context:
$context

---

Question:
$userQuery

---

Answer step-by-step in clear terms, as if guiding a medic in the field. Only rely on provided context.
''';
}
```

---

## 🧩 Phase 4: Add LLM Generation Code

### 4.1 File: `lib/services/llm_service.dart`

```dart
Future<void> runTinyLlamaChat(List<String> chunks, String query, void Function(String) onData) async {
  final prompt = buildMedicalPrompt(chunks, query);

  final request = OpenAiRequest(
    modelPath: "assets/models/llm/TinyLlama-1.1B-Chat-v1.0.Q4_K_M.gguf",
    messages: [
      Message(Role.system, "You are a helpful emergency assistant."),
      Message(Role.user, prompt),
    ],
    maxTokens: 256,
  );

  fllamaChat(request, (chunk, done) {
    onData(chunk);
  });
}
```

---

## 📲 Phase 5: Integrate with UI

### 5.1 In `search_screen.dart` (or wherever RAG is triggered)

1. Query: user enters question
2. → get embedding via MiniLM (Kotlin call)
3. → cosine search in SQLite, get top chunks
4. → `runTinyLlamaChat(chunks, userQuery, onResponse)`
5. → Stream response to UI

💡 Best UX: Show spinner/loading indicator, stream LLM response line-by-line

---

## 💾 Phase 6: Caching and Failover (Optional)

* [ ] Save all generated Q\&A in SQLite for history
* [ ] Add retry if LLM load fails
* [ ] Enable "regenerate" button

---

## 🧪 Phase 7: Testing & Optimization

| Area    | Tip                                      |
| ------- | ---------------------------------------- |
| Model   | Use Q4\_K\_M for speed + quality balance |
| Memory  | Run on 3 GB RAM minimum                  |
| Speed   | Keep chunks short, reduce `maxTokens`    |
| Timeout | Cancel generation after X sec or by user |

---

## ✅ Final Checklist

| Task                               | Done |
| ---------------------------------- | ---- |
| TinyLLaMA model downloaded + added | \[ ] |
| `fllama` integrated                | \[ ] |
| Prompt template created            | \[ ] |
| Generation function built          | \[ ] |
| UI updated to show result          | \[ ] |
| End-to-end test with real PDFs     | \[ ] |

---

## 📚 References

* [MiniLM Sentence Embeddings (Android)](https://github.com/shubham0204/Sentence-Embeddings-Android)
* [TinyLLaMA GGUF - HuggingFace](https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF)
* [fllama plugin](https://github.com/Telosnex/fllama)
* [llama.cpp](https://github.com/ggerganov/llama.cpp)

---

## 🧠 Tip: Prompt Engineering

You can specialize the prompt per query type:

* 🔺 Wound management
* 🚑 Triage level detection
* 🧯 Fire/burn injuries
* 🧬 Infectious disease protocol

Use flags in UI to toggle mode-specific prompts.

```

---

Would you like this saved as a `.md` file and zipped with supporting Flutter files like `llm_service.dart`?
```
