
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceCommandService {
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  
  static Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    bool speechAvailable = await _speech.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) => print('Speech recognition status: $status'),
    );
    
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    
    _isInitialized = speechAvailable;
    return speechAvailable;
  }
  
  static Future<void> startListening(Function(String) onResult) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) {
        throw Exception('Could not initialize speech recognition');
      }
    }
    
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }
  
  static Future<void> stopListening() async {
    await _speech.stop();
  }
  
  static Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }
    await _flutterTts.speak(text);
  }
  
  static Future<void> stop() async {
    await _flutterTts.stop();
  }
  
  static bool isListening() {
    return _speech.isListening;
  }
}
