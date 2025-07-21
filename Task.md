# 🖥️ ENVIRONMENT SETUP

**Important:** This project is developed on **Windows 11** and all commands use **PowerShell syntax**. When running terminal commands, ensure you're using PowerShell (not Command Prompt or Bash).

---

Here is a **detailed phase-by-phase implementation plan** for building an **offline RAG app on Android using MiniLM via ONNX**, fully wrapped in Flutter, suitable for **agentic automation**. It integrates the Android repo [shubham0204/Sentence-Embeddings-Android](https://github.com/shubham0204/Sentence-Embeddings-Android) and includes:

* Kotlin FFI bridge to MiniLM ONNX model
* Flutter UI
* SQLite embedding storage
* Cosine similarity retrieval

---

# 📘 OFFLINE RAG SYSTEM (MiniLM-Only) — DETAILED IMPLEMENTATION PLAN

---

## ⚙️ PHASE 1: FLUTTER SCAFFOLD & PLATFORM SETUP

### ✅ Step 1.1 – Flutter App Setup

* Scaffold created ✅ (from previous ZIP)
* Folder: `flutter_app/`
* Install dependencies:

  ```bash
  flutter pub get
  ```

---

### ✅ Step 1.2 – Android Platform Channel Setup

* Path: `android/app/src/main/java/com/example/minilmwrapper/MainActivity.kt`

Wrap `MethodChannel`:

```kotlin
private val CHANNEL = "com.example.minilm/embedding"
```

Handle method:

```kotlin
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
    call, result ->
    if (call.method == "getEmbedding") {
        val text = call.argument<String>("text") ?: ""
        val embedding = SentenceEmbedder().embed(text)
        result.success(embedding.toList())
    } else {
        result.notImplemented()
    }
}
```

---

## 🧠 PHASE 2: INTEGRATE MiniLM ONNX IN ANDROID

### ✅ Step 2.1 – Add MiniLM ONNX Dependencies

* Clone the embedding repo inside Android:

  ```powershell
  git clone https://github.com/shubham0204/Sentence-Embeddings-Android MiniLMEmbedder
  ```

* Add these dependencies to your `app/build.gradle`:

```groovy
implementation 'ai.onnxruntime:onnxruntime-mobile:1.15.1'
implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.6.4'
```

---

### ✅ Step 2.2 – Copy and Use MiniLM Model

* Download quantized ONNX model:
  [MiniLM-L6-v2 ONNX version](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2)

* Place it in: `android/app/src/main/assets/model.onnx`
  (Create `assets` folder if missing)

* Register assets in `android/app/build.gradle`:

```groovy
android {
    ...
    aaptOptions {
        noCompress "onnx"
    }
}
```

---

### ✅ Step 2.3 – Create Kotlin Embedding Wrapper

**Create a new Kotlin class: `SentenceEmbedder.kt`**

```kotlin
package com.example.minilmwrapper

import ai.onnxruntime.*
import java.nio.FloatBuffer

class SentenceEmbedder {
    private var env: OrtEnvironment = OrtEnvironment.getEnvironment()
    private var session: OrtSession = env.createSession("model.onnx", OrtSession.SessionOptions())

    fun embed(text: String): FloatArray {
        val tokens = tokenize(text)
        val inputTensor = OnnxTensor.createTensor(env, tokens)
        val results = session.run(mapOf("input" to inputTensor))
        val output = results[0].value as Array<FloatArray>
        return output[0] // Use mean pooling or CLS token
    }

    private fun tokenize(text: String): Array<IntArray> {
        // TODO: use built-in tokenizer or integrate tokenizer manually
        return arrayOf(intArrayOf(/* token ids */))
    }
}
```

✳️ Replace `tokenize()` with working tokenization code from the original repo.

---

## 💾 PHASE 3: FLUTTER + SQLITE INTEGRATION

### ✅ Step 3.1 – Add Drift (SQLite wrapper)

```yaml
dependencies:
  drift: ^2.13.0
  sqlite3_flutter_libs: ^0.5.17
```

Create schema:

```dart
class Chunks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  BlobColumn get embedding => blob()(); // Float32List encoded
}
```

Store embedding:

```dart
await db.into(db.chunks).insert(ChunksCompanion(
  content: Value("Some paragraph..."),
  embedding: Value(floatListToBlob(embedding))
));
```

---

### ✅ Step 3.2 – Cosine Similarity (in Dart)

```dart
double cosineSim(List<double> a, List<double> b) {
  double dot = 0.0, normA = 0.0, normB = 0.0;
  for (int i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }
  return dot / (sqrt(normA) * sqrt(normB));
}
```

Query all chunks, decode BLOBs, then run similarity:

```dart
final chunks = await db.select(db.chunks).get();
final scores = chunks.map((chunk) {
  final emb = blobToFloatList(chunk.embedding);
  final score = cosineSim(userQueryEmbedding, emb);
  return (chunk, score);
}).toList();

scores.sort((a, b) => b.$2.compareTo(a.$2)); // descending
```

---

## 🔄 PHASE 4: FULL RAG FLOW (No LLM)

### RAG Pipeline:

1. ✅ User uploads PDF/DOC/TXT
2. ✅ Extract text using `flutter_pdfview` / `flutter_archive` / Rust FFI
3. ✅ Split into paragraphs or fixed-length chunks (100–150 tokens)
4. ✅ Call `getEmbedding()` for each chunk (via platform channel)
5. ✅ Store chunks + embeddings in SQLite
6. ✅ On query:

   * Embed question using same method
   * Find top-N closest chunks (cosine)
   * Display most relevant result in Flutter UI

---

## ✅ Final Result: MiniLM-Powered Search RAG on Android

| Component       | Tech                     |
| --------------- | ------------------------ |
| Embedding Model | MiniLM ONNX (via Kotlin) |
| Search          | Cosine Sim + SQLite      |
| UI              | Flutter                  |
| Offline         | 100%                     |
| LLM             | ❌ Not required           |
| RAM Required    | \~200MB                  |
| Speed           | Fast (CPU-optimized)     |

Rules for flutter projects
- Avoid using type any
- Create necessary types
- Don't leave blank lines within a function
- One export per file
- Prefer super contructor
- Use PascalCase for classes.
- Use camelCase for variables, functions, and methods.
- Use underscores_case for file and directory names.
- Avoid magic numbers and define constants.
- Start each function with a verb.
- always use package import even for our project files
Ex: import 'package:apparence_kit/core/data/entities/upload_result.dart';
- Comply to the always_use_package_imports rule
- Our package is named apparence_kit
- DO avoid relative imports for files in lib/
