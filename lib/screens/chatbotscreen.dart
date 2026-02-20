import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  bool _isLoading = false;
  bool _isApiConfigured = false;

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  String? _apiKey;

  @override
  void initState() {
    super.initState();
    _initVoice();
    _initChatbot();
  }

  void _initChatbot() {
    _apiKey = dotenv.env['OPENROUTER_API_KEY'];

    if (_apiKey == null || _apiKey!.isEmpty) {
      _showError("API Key not found. Check .env file.");
      _isApiConfigured = false;
      return;
    }

    _isApiConfigured = true;

    final welcomeMessage =
        "Hello! I am Thanal Assistant. I support English and Malayalam.\n\nഹലോ! ഞാൻ തണൽ അസിസ്റ്റന്റാണ്.";
    _messages.add(ChatMessage(text: welcomeMessage, isUser: false));
    _speak(welcomeMessage);
  }

  Future<void> _initVoice() async {
    await _speechToText.initialize();
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _showError(String message) {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: false));
    });
  }

  String _detectLanguage(String text) {
    const int malayalamStart = 0x0D00;
    const int malayalamEnd = 0x0D7F;

    for (final rune in text.runes) {
      if (rune >= malayalamStart && rune <= malayalamEnd) {
        return "ml-IN";
      }
    }
    return "en-US";
  }
  String _cleanForSpeech(String text) {
  return text
      .replaceAll(RegExp(r'\*\*'), '')
      .replaceAll(RegExp(r'\*'), '')
      .replaceAll(RegExp(r'_'), '')
      .replaceAll(RegExp(r'`'), '')
      .replaceAll(RegExp(r'#'), '')
      .replaceAll(RegExp(r'- '), '')
      .replaceAll(RegExp(r'\d+\.'), '')
      .replaceAll(RegExp(r'\n+'), '\n')
      .trim();
}

  Future<void> _speak(String text) async {
    if (text.isEmpty) return;
    final cleanedText = _cleanForSpeech(text);  
    final language = _detectLanguage(text);
    await _flutterTts.setLanguage(language);   
    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          localeId: 'ml_IN',
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading || !_isApiConfigured) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _textController.clear();
    _speechToText.stop();
    setState(() => _isListening = false);

    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "https://thanal.app",
          "X-Title": "Thanal Assistant"
        },
        body: jsonEncode({
         "model": "openai/gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are Thanal disaster assistant. Give short, practical answers. Support Malayalam and English."
            },
            {"role": "user", "content": text}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply = data["choices"][0]["message"]["content"];

        setState(() {
          _messages.add(ChatMessage(text: botReply, isUser: false));
        });

        _speak(botReply);
      } else {
        _showError("API Error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Something went wrong.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanal Voice Assistant"),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.green[600]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    enabled: _isApiConfigured,
                    decoration: InputDecoration(
                      hintText:
                          _isListening ? "Listening..." : "Type or speak...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(
                      _isListening ? Icons.mic_off : Icons.mic),
                  onPressed: _listen,
                  color: Colors.green[700],
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () =>
                      _sendMessage(_textController.text),
                  color: Colors.green[700],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}