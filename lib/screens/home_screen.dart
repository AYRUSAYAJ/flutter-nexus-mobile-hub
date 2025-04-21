
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Nexus Hub'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Flutter Nexus Hub',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This application demonstrates various mobile development concepts',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30),
            _buildFeatureCard(
              context,
              title: 'Database Operations',
              description: 'Create, read, update and delete tasks with SQLite',
              icon: Icons.storage,
              route: '/database',
              color: Colors.blue,
            ),
            _buildFeatureCard(
              context,
              title: 'Notification Settings',
              description: 'Manage, schedule and customize notifications',
              icon: Icons.notifications,
              route: '/notifications',
              color: Colors.orange,
            ),
            _buildFeatureCard(
              context,
              title: 'Multithreading',
              description: 'Perform complex operations without blocking the UI',
              icon: Icons.sync,
              route: '/multithreading',
              color: Colors.green,
            ),
            _buildFeatureCard(
              context,
              title: 'GPS Location',
              description: 'Track your current location with coordinates and address',
              icon: Icons.location_on,
              route: '/location',
              color: Colors.red,
            ),
            _buildFeatureCard(
              context,
              title: 'RSS Feed Reader',
              description: 'Fetch and display RSS feeds from websites',
              icon: Icons.rss_feed,
              route: '/rss',
              color: Colors.amber,
            ),
            _buildFeatureCard(
              context,
              title: 'Email Sender',
              description: 'Send and receive email through the app',
              icon: Icons.email,
              route: '/email',
              color: Colors.purple,
            ),
            _buildFeatureCard(
              context,
              title: 'Voice Commands (Innovation)',
              description: 'Control the app using voice instructions',
              icon: Icons.mic,
              route: '/voice',
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
