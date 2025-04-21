
import 'package:flutter/material.dart';
import 'package:flutter_nexus_hub/utils/voice_command_service.dart';

class VoiceCommandScreen extends StatefulWidget {
  @override
  _VoiceCommandScreenState createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  bool _isListening = false;
  String _transcription = '';
  String _response = '';
  List<Map<String, String>> _commandHistory = [];
  
  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }
  
  Future<void> _initializeSpeech() async {
    try {
      await VoiceCommandService.initialize();
    } catch (e) {
      print('Error initializing speech: $e');
    }
  }
  
  Future<void> _startListening() async {
    if (!_isListening) {
      try {
        await VoiceCommandService.startListening((text) {
          setState(() {
            _transcription = text;
            _processCommand(text);
          });
        });
        
        setState(() {
          _isListening = true;
        });
      } catch (e) {
        print('Error starting listening: $e');
      }
    }
  }
  
  Future<void> _stopListening() async {
    if (_isListening) {
      try {
        await VoiceCommandService.stopListening();
        
        setState(() {
          _isListening = false;
        });
      } catch (e) {
        print('Error stopping listening: $e');
      }
    }
  }
  
  void _processCommand(String command) {
    String response = '';
    
    // Process voice commands
    final lowerCommand = command.toLowerCase();
    
    if (lowerCommand.contains('hello') || lowerCommand.contains('hi')) {
      response = 'Hello! How can I help you today?';
    } else if (lowerCommand.contains('what time') || lowerCommand.contains('current time')) {
      final now = DateTime.now();
      response = 'The current time is ${now.hour}:${now.minute}';
    } else if (lowerCommand.contains('what day') || lowerCommand.contains('current date')) {
      final now = DateTime.now();
      response = 'Today is ${now.day}/${now.month}/${now.year}';
    } else if (lowerCommand.contains('open') || lowerCommand.contains('go to')) {
      if (lowerCommand.contains('database')) {
        response = 'Opening Database screen';
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/database');
        });
      } else if (lowerCommand.contains('notification')) {
        response = 'Opening Notification screen';
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/notifications');
        });
      } else if (lowerCommand.contains('threading') || lowerCommand.contains('multithreading')) {
        response = 'Opening Multithreading screen';
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/multithreading');
        });
      } else if (lowerCommand.contains('location') || lowerCommand.contains('gps')) {
        response = 'Opening Location screen';
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/location');
        });
      } else if (lowerCommand.contains('rss') || lowerCommand.contains('feed')) {
        response = 'Opening RSS screen';
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/rss');
        });
      } else if (lowerCommand.contains('email')) {
        response = 'Opening Email screen';
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/email');
        });
      } else if (lowerCommand.contains('home')) {
        response = 'Going to Home screen';
        Future.delayed(Duration(seconds: 1), () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        });
      } else {
        response = 'I don\'t know how to open that screen';
      }
    } else if (lowerCommand.contains('help')) {
      response = 'You can ask me to open screens, tell the time, or greet me with hello!';
    } else {
      response = 'I didn\'t understand that command. Try saying "help" for assistance.';
    }
    
    setState(() {
      _response = response;
      _commandHistory.add({
        'command': command,
        'response': response,
      });
    });
    
    VoiceCommandService.speak(response);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Commands (Innovation)'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMicrophoneSection(),
            SizedBox(height: 24),
            _buildTranscriptionSection(),
            SizedBox(height: 24),
            _buildResponseSection(),
            SizedBox(height: 24),
            _buildCommandHistorySection(),
            SizedBox(height: 24),
            _buildHelpSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        backgroundColor: _isListening ? Colors.red : Colors.teal,
        child: Icon(_isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
  
  Widget _buildMicrophoneSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Voice Commands',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _isListening ? Colors.red.withOpacity(0.2) : Colors.teal.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 50,
                color: _isListening ? Colors.red : Colors.teal,
              ),
            ),
            SizedBox(height: 16),
            Text(
              _isListening ? 'Listening...' : 'Tap the microphone to start',
              style: TextStyle(
                fontSize: 16,
                color: _isListening ? Colors.red : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTranscriptionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transcription',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              width: double.infinity,
              child: Text(
                _transcription.isEmpty ? 'Say something...' : _transcription,
                style: TextStyle(
                  fontSize: 16,
                  color: _transcription.isEmpty ? Colors.grey : Colors.black,
                  fontStyle: _transcription.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResponseSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Response',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal[200]!),
              ),
              width: double.infinity,
              child: Text(
                _response.isEmpty ? 'Waiting for command...' : _response,
                style: TextStyle(
                  fontSize: 16,
                  color: _response.isEmpty ? Colors.grey : Colors.teal[800],
                  fontStyle: _response.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCommandHistorySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Command History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (_commandHistory.isEmpty)
              Center(
                child: Text(
                  'No commands yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _commandHistory.length,
                itemBuilder: (context, index) {
                  final item = _commandHistory[_commandHistory.length - 1 - index];
                  return ListTile(
                    title: Text(
                      'You: ${item['command']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('App: ${item['response']}'),
                    leading: Icon(Icons.chat_bubble_outline),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHelpSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Commands',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildHelpItem('Hello / Hi', 'Greet the app'),
            _buildHelpItem('What time is it?', 'Get the current time'),
            _buildHelpItem('What day is it?', 'Get the current date'),
            _buildHelpItem('Open database', 'Navigate to Database screen'),
            _buildHelpItem('Open notifications', 'Navigate to Notifications screen'),
            _buildHelpItem('Open threading', 'Navigate to Multithreading screen'),
            _buildHelpItem('Open location', 'Navigate to Location screen'),
            _buildHelpItem('Open RSS feed', 'Navigate to RSS screen'),
            _buildHelpItem('Open email', 'Navigate to Email screen'),
            _buildHelpItem('Go to home', 'Navigate to Home screen'),
            _buildHelpItem('Help', 'Get assistance'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHelpItem(String command, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  command,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
