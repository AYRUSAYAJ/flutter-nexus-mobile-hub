
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nexus_hub/providers/app_state.dart';
import 'package:flutter_nexus_hub/screens/home_screen.dart';
import 'package:flutter_nexus_hub/screens/database_screen.dart';
import 'package:flutter_nexus_hub/screens/notification_screen.dart';
import 'package:flutter_nexus_hub/screens/multithreading_screen.dart';
import 'package:flutter_nexus_hub/screens/location_screen.dart';
import 'package:flutter_nexus_hub/screens/rss_screen.dart';
import 'package:flutter_nexus_hub/screens/email_screen.dart';
import 'package:flutter_nexus_hub/screens/voice_command_screen.dart';
import 'package:flutter_nexus_hub/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications
  await NotificationService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Nexus Hub',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: MainScreen(),
      routes: {
        '/database': (context) => DatabaseScreen(),
        '/notifications': (context) => NotificationScreen(),
        '/multithreading': (context) => MultithreadingScreen(),
        '/location': (context) => LocationScreen(),
        '/rss': (context) => RssScreen(),
        '/email': (context) => EmailScreen(),
        '/voice': (context) => VoiceCommandScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  static final List<Widget> _screens = [
    HomeScreen(),
    DatabaseScreen(),
    NotificationScreen(),
    MultithreadingScreen(),
    LocationScreen(),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Database',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Threading',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
