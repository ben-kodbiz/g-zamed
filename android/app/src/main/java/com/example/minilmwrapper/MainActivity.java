package com.example.minilmwrapper;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import android.os.Handler;
import android.os.Looper;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.minilm/embedding";
    private SentenceEmbedder sentenceEmbedder;
    private ExecutorService executorService;
    private Handler mainHandler;

    @Override
    public void configureFlutterEngine(io.flutter.embedding.engine.FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        // Initialize the sentence embedder
        sentenceEmbedder = new SentenceEmbedder(this);
        executorService = Executors.newSingleThreadExecutor();
        mainHandler = new Handler(Looper.getMainLooper());
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("getEmbedding")) {
                    String text = call.argument("text");
                    if (text == null) {
                        text = "";
                    }
                    
                    // Run embedding generation on background thread
                    final String finalText = text;
                    executorService.execute(() -> {
                        try {
                            float[] embedding = sentenceEmbedder.embed(finalText);
                            // Convert float array to list for Flutter
                            Float[] embeddingList = new Float[embedding.length];
                            for (int i = 0; i < embedding.length; i++) {
                                embeddingList[i] = embedding[i];
                            }
                            
                            // Return result on main thread
                            mainHandler.post(() -> {
                                result.success(Arrays.asList(embeddingList));
                            });
                        } catch (Exception e) {
                            mainHandler.post(() -> {
                                result.error("EMBEDDING_ERROR", "Failed to generate embedding: " + e.getMessage(), null);
                            });
                        }
                    });
                } else {
                    result.notImplemented();
                }
            });
    }

    // Dummy embedding method for fallback when ONNX is not available
    private float[] generateDummyEmbedding(String text) {
        // Generate a deterministic but varied 384-dimension embedding based on text hash
        int hashCode = text.hashCode();
        float[] embedding = new float[384];
        
        // Use hash code to seed a simple pseudo-random generator
        int seed = hashCode;
        for (int i = 0; i < 384; i++) {
            seed = seed * 1103515245 + 12345; // Linear congruential generator
            embedding[i] = (float) ((seed % 10000) / 10000.0 - 0.5); // Range: -0.5 to 0.5
        }
        
        // Normalize the embedding vector
        float norm = 0.0f;
        for (float value : embedding) {
            norm += value * value;
        }
        norm = (float) Math.sqrt(norm);
        
        if (norm > 0) {
            for (int i = 0; i < embedding.length; i++) {
                embedding[i] /= norm;
            }
        }
        
        return embedding;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (sentenceEmbedder != null) {
            sentenceEmbedder.close();
        }
        if (executorService != null) {
            executorService.shutdown();
        }
    }
}