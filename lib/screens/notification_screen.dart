
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nexus_hub/providers/app_state.dart';
import 'package:flutter_nexus_hub/utils/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime _selectedDate = DateTime.now().add(Duration(minutes: 1));
  final _titleController = TextEditingController(text: 'Scheduled Notification');
  final _bodyController = TextEditingController(text: 'This is a scheduled notification from Flutter Nexus Hub');
  
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
  
  Future<void> _showDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
  
  void _scheduleNotification() {
    NotificationService.scheduleNotification(
      id: DateTime.now().millisecond,
      title: _titleController.text,
      body: _bodyController.text,
      scheduledDate: _selectedDate,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled')),
    );
  }
  
  void _showInstantNotification() {
    NotificationService.showNotification(
      id: DateTime.now().millisecond,
      title: 'Instant Notification',
      body: 'This is an instant notification from Flutter Nexus Hub',
      payload: 'instant_notification',
    );
  }
  
  void _cancelAllNotifications() {
    NotificationService.cancelAllNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All notifications cancelled')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Global Settings',
              child: _buildGlobalSettings(),
            ),
            SizedBox(height: 24),
            _buildSection(
              title: 'Instant Notification',
              child: _buildInstantNotification(),
            ),
            SizedBox(height: 24),
            _buildSection(
              title: 'Schedule Notification',
              child: _buildScheduleNotification(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }
  
  Widget _buildGlobalSettings() {
    return Consumer<AppState>(
      builder: (ctx, appState, _) {
        return Column(
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              subtitle: Text('Toggle all notifications for this app'),
              value: appState.notificationsEnabled,
              onChanged: (value) {
                appState.toggleNotifications(value);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Cancel All Notifications'),
              trailing: ElevatedButton(
                onPressed: _cancelAllNotifications,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('CANCEL ALL'),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildInstantNotification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Send an instant notification to test the functionality',
          style: TextStyle(color: Colors.grey[700]),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _showInstantNotification,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text('SEND NOTIFICATION NOW'),
        ),
      ],
    );
  }
  
  Widget _buildScheduleNotification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Notification Title',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _bodyController,
          decoration: InputDecoration(
            labelText: 'Notification Body',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        SizedBox(height: 16),
        ListTile(
          title: Text('Scheduled Time'),
          subtitle: Text(
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} at ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
          ),
          trailing: TextButton(
            onPressed: _showDateTimePicker,
            child: Text('CHANGE'),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _scheduleNotification,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text('SCHEDULE NOTIFICATION'),
        ),
      ],
    );
  }
}
