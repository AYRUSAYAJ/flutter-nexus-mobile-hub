
import 'dart:isolate';
import 'package:flutter/material.dart';

class MultithreadingScreen extends StatefulWidget {
  @override
  _MultithreadingScreenState createState() => _MultithreadingScreenState();
}

class _MultithreadingScreenState extends State<MultithreadingScreen> {
  int _counter = 0;
  bool _isLoading = false;
  double _progress = 0.0;
  String _result = "";
  Isolate? _isolate;
  late ReceivePort _receivePort;
  
  @override
  void initState() {
    super.initState();
    _receivePort = ReceivePort();
  }
  
  @override
  void dispose() {
    _isolate?.kill();
    _receivePort.close();
    super.dispose();
  }
  
  // Function to increment counter without blocking the UI
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  // Heavy computation run in the UI thread (will freeze the UI)
  void _runHeavyTaskOnMainThread() {
    setState(() {
      _isLoading = true;
      _result = "Computing on main thread...";
      _progress = 0.0;
    });
    
    // Simulate heavy computation that blocks the UI
    int result = 0;
    for (int i = 0; i < 1000000000; i++) {
      result += i;
      if (i % 10000000 == 0) {
        setState(() {
          _progress = i / 1000000000;
        });
      }
    }
    
    setState(() {
      _isLoading = false;
      _result = "Main thread result: $result";
      _progress = 1.0;
    });
  }
  
  // Heavy computation run in a separate isolate (won't freeze the UI)
  void _runHeavyTaskOnIsolate() async {
    setState(() {
      _isLoading = true;
      _result = "Computing on background thread...";
      _progress = 0.0;
    });
    
    // Kill any existing isolate
    _isolate?.kill();
    _receivePort.close();
    _receivePort = ReceivePort();
    
    // Create and start the isolate
    _isolate = await Isolate.spawn(
      _heavyComputation,
      _receivePort.sendPort,
    );
    
    // Listen for messages from the isolate
    _receivePort.listen((message) {
      if (message is double) {
        setState(() {
          _progress = message;
        });
      } else {
        setState(() {
          _isLoading = false;
          _result = "Background thread result: $message";
          _progress = 1.0;
        });
        _isolate?.kill();
      }
    });
  }
  
  // This function runs in a separate isolate
  static void _heavyComputation(SendPort sendPort) {
    int result = 0;
    for (int i = 0; i < 1000000000; i++) {
      result += i;
      if (i % 10000000 == 0) {
        sendPort.send(i / 1000000000);
      }
    }
    sendPort.send(result);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multithreading Demo'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UI Responsiveness Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Try clicking the counter button while heavy tasks are running to test UI responsiveness',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Counter: $_counter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _incrementCounter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('INCREMENT'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Heavy Computation Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'UI Thread (Will Freeze UI)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Runs a heavy computation directly on the UI thread, which will cause the app to freeze',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _runHeavyTaskOnMainThread,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('RUN ON UI THREAD'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Background Thread (Won\'t Freeze UI)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Runs the same heavy computation in a separate Isolate, keeping the UI responsive',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _runHeavyTaskOnIsolate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('RUN ON BACKGROUND THREAD'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            if (_isLoading || _result.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (_isLoading) ...[
                        Text(
                          'Progress: ${(_progress * 100).toStringAsFixed(1)}%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ],
                      SizedBox(height: 16),
                      Text(_result),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
