
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nexus_hub/providers/app_state.dart';
import 'package:flutter_nexus_hub/models/task.dart';

class DatabaseScreen extends StatefulWidget {
  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Load tasks when screen is initialized
    Future.microtask(() {
      Provider.of<AppState>(context, listen: false).loadTasks();
    });
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Provider.of<AppState>(context, listen: false).addTask(
        _titleController.text,
        _descriptionController.text,
      );
      
      // Clear the form
      _titleController.clear();
      _descriptionController.clear();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Database'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AppState>(
              builder: (ctx, appState, child) {
                if (appState.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (appState.tasks.isEmpty) {
                  return Center(
                    child: Text(
                      'No tasks yet. Add one!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: appState.tasks.length,
                  itemBuilder: (ctx, index) {
                    final task = appState.tasks[index];
                    return _buildTaskItem(task);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('ADD TASK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTaskItem(Task task) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<AppState>(context, listen: false).deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task deleted')),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(task.description),
          trailing: Checkbox(
            value: task.completed,
            onChanged: (bool? value) {
              if (value != null) {
                Provider.of<AppState>(context, listen: false)
                    .toggleTaskCompletion(task.id, value);
              }
            },
          ),
        ),
      ),
    );
  }
}
