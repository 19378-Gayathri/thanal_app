import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenRouterService {
  static final String apiKey =
      dotenv.env['OPENROUTER_API_KEY'] ?? '';

  static Future<String> getChatResponse(String message) async {
    final response = await http.post(
      Uri.parse("https://openrouter.ai/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "mistralai/mistral-7b-instruct",
        "messages": [
          {
            "role": "system",
            "content":
                "You are Thanal, a helpful emergency assistant. "
                "Detect the user's language automatically. "
                "If Malayalam reply in Malayalam. "
                "If English reply in English."
          },
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "API Error: ${response.body}";
    }
  }
}