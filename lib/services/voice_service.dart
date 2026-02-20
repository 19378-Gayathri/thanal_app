import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  /// Initialize speech & TTS
  Future<bool> init() async {
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    return await _speech.initialize();
  }

  /// Start Listening
  Future<void> startListening(Function(String) onResult) async {
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  /// Stop Listening
  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;

  /// Send text to OpenRouter API
  Future<String> sendToOpenRouter(String message) async {
    try {
      final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? "";

      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo", 
          "messages": [
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return tr('voice_processing_error');
      }
    } catch (e) {
      print("OpenRouter Error: $e");
      return tr('voice_processing_error');
    }
  }

  /// Speak response
  Future<void> speak(String text, {String language = "en-US"}) async {
    await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  /// Full Voice Assistant Flow
  Future<void> processVoiceInput(String text, String locale) async {
    String response = await sendToOpenRouter(text);

    await speak(
      response,
      language: locale == "ml" ? "ml-IN" : "en-US",
    );
  }
}
   