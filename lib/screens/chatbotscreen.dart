import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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
  GenerativeModel? _model;
  ChatSession? _chat;
  bool _isLoading = false;
  bool _isApiConfigured = false;

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initChatbot();
    _initVoice();
  }

  Future<void> _initVoice() async {
    await _speechToText.initialize();
    // BILINGUAL TTS: We no longer set a default language here.
    // It will be set dynamically before each speech utterance.
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _initChatbot() {
    // This function remains the same as your previous version.
    // ... (Your existing _initChatbot code)
    void showError(String message) {
      setState(() {
        _messages.add(ChatMessage(text: message, isUser: false));
      });
    }

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        _isApiConfigured = false;
        showError('API Key കണ്ടെത്തിയില്ല. നിങ്ങളുടെ .env ഫയൽ പരിശോധിക്കുക.');
        return;
      }

      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );

      _chat = _model!.startChat();
      _isApiConfigured = true;

       final initialMessage = 'Hello! I can speak English and Malayalam. How can I help you?\n\nഹലോ! എനിക്ക് ഇംഗ്ലീഷും മലയാളവും സംസാരിക്കാൻ കഴിയും. ഞാൻ നിങ്ങളെ എങ്ങനെ സഹായിക്കും?';
      setState(() {
        _messages.add(ChatMessage(text: initialMessage, isUser: false));
      });
       _speak(initialMessage);
    } catch (e) {
      _isApiConfigured = false;
      showError('ചാറ്റ്ബോട്ട് സജ്ജീകരിക്കുന്നതിൽ പിശക്: ${e.toString()}');
    }
  }

  // BILINGUAL TTS: A new function to detect the language of a string.
  String _detectLanguage(String text) {
    // The Unicode range for Malayalam characters is 0D00–0D7F.
    const int malayalamStart = 0x0D00;
    const int malayalamEnd = 0x0D7F;

    // Check if any character in the string falls within the Malayalam range.
    for (final rune in text.runes) {
      if (rune >= malayalamStart && rune <= malayalamEnd) {
        return "ml-IN"; // It's Malayalam
      }
    }
    // If no Malayalam characters were found, default to English.
    return "en-US";
  }

  // BILINGUAL TTS: The _speak function is now dynamic.
  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      // 1. Detect the language of the text.
      final language = _detectLanguage(text);
      // 2. Set the TTS engine to that language.
      await _flutterTts.setLanguage(language);
      // 3. Speak.
      await _flutterTts.speak(text);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print('onStatus: $status'),
        onError: (error) => print('onError: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        // We can let the STT engine auto-detect or specify a primary locale.
        // For a bilingual app, letting it auto-detect can sometimes work well.
        // To prioritize Malayalam, we keep 'ml_IN'.
        _speechToText.listen(
          onResult: (result) => setState(() {
            _textController.text = result.recognizedWords;
          }),
          localeId: 'ml_IN',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  Future<void> _sendMessage(String text) async {
    // This function remains the same. The magic happens when its response
    // is passed to our new dynamic _speak() function.
    // ... (Your existing _sendMessage code)
     if (text.trim().isEmpty || _isLoading || !_isApiConfigured) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _textController.clear();
    _speechToText.stop();
    setState(() => _isListening = false);


    try {
      final response = await _chat!.sendMessage(Content.text(text));
      final botResponse = response.text;

      if (botResponse != null) {
        setState(() {
          _messages.add(ChatMessage(text: botResponse, isUser: false));
        });
        _speak(botResponse);
      } else {
        final errorMessage = 'ക്ഷമിക്കണം, എനിക്ക് ഉത്തരം കണ്ടെത്താനായില്ല.';
        setState(() {
          _messages.add(ChatMessage(text: errorMessage, isUser: false));
        });
         _speak(errorMessage);
      }
    } catch (e) {
      debugPrint('Gemini API error: $e');
      final errorMessage = '⚠️ ഒരു പിശക് സംഭവിച്ചു.';
      setState(() {
        _messages.add(ChatMessage(text: errorMessage, isUser: false));
      });
       _speak(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // The build method remains the same as your previous version.
    // ... (Your existing build method code)
     return Scaffold(
      appBar: AppBar(
        title: const Text('തണൽ Bilingual Assistant'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
           Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.green[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    enabled: _isApiConfigured,
                    decoration: InputDecoration(
                      hintText: _isListening ? 'Listening...' : 'Type or use the mic...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  color: Colors.green[700],
                  onPressed: _isApiConfigured ? _listen : null,
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.green[700],
                  onPressed: _isApiConfigured ? () => _sendMessage(_textController.text) : null,
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
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