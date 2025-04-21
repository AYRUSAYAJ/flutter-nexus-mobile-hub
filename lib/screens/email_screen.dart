
import 'package:flutter/material.dart';
import 'package:flutter_nexus_hub/utils/email_service.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _toController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  
  bool _isSending = false;
  String _error = '';
  
  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    super.dispose();
  }
  
  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSending = true;
      _error = '';
    });
    
    try {
      await EmailService.sendEmail(
        subject: _subjectController.text,
        body: _bodyController.text,
        recipients: _toController.text.split(',').map((e) => e.trim()).toList(),
        cc: _ccController.text.isEmpty
            ? []
            : _ccController.text.split(',').map((e) => e.trim()).toList(),
        bcc: _bccController.text.isEmpty
            ? []
            : _bccController.text.split(',').map((e) => e.trim()).toList(),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email sent successfully')),
      );
      
      // Clear form fields after successful send
      _toController.clear();
      _subjectController.clear();
      _bodyController.clear();
      _ccController.clear();
      _bccController.clear();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Sender'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
                        'Compose Email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _toController,
                        label: 'To',
                        hint: 'recipient@example.com',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one recipient';
                          }
                          // Simple email validation
                          final emails = value.split(',').map((e) => e.trim());
                          for (final email in emails) {
                            if (!email.contains('@') || !email.contains('.')) {
                              return 'Please enter valid email addresses';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _ccController,
                        label: 'CC',
                        hint: 'cc@example.com (optional)',
                        icon: Icons.person_add,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _bccController,
                        label: 'BCC',
                        hint: 'bcc@example.com (optional)',
                        icon: Icons.person_add_alt,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _subjectController,
                        label: 'Subject',
                        hint: 'Enter email subject',
                        icon: Icons.subject,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a subject';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _bodyController,
                        decoration: InputDecoration(
                          labelText: 'Body',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        maxLines: 8,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email content';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              if (_error.isNotEmpty)
                Card(
                  color: Colors.red[100],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _error,
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSending ? null : _sendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.send),
                  label: _isSending
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('SEND EMAIL'),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This feature uses the device\'s email client to send messages. The recipient will see your registered email address as the sender.',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}
