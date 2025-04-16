import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Task Manager App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}

// -------------------- SPLASH SCREEN --------------------
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Task Manager",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// -------------------- WEEK 1: LOGIN SCREEN --------------------
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Enter email';
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-z]+\.[a-z]+")
                      .hasMatch(value)) return 'Enter valid email';
                  return null;
                },
              ),
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter password' : null,
              ),
              SizedBox(height: 20),
              TextButton(onPressed: () {}, child: Text("Forgot Password?")),
              ElevatedButton(onPressed: _login, child: Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- WEEK 2 & 3: HOME + COUNTER + TASK APP --------------------
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Task {
  String title;
  bool isDone;
  Task(this.title, {this.isDone = false});
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  List<Task> tasks = [];
  final taskCtrl = TextEditingController();

  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      tasks.add(Task(title));
      taskCtrl.clear();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New Task"),
        content: TextField(
          controller: taskCtrl,
          decoration: InputDecoration(hintText: "Enter task"),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                _addTask(taskCtrl.text);
                Navigator.pop(context);
              },
              child: Text("Add")),
        ],
      ),
    );
  }

  Widget _buildCounter() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Counter Value", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () => setState(() => counter--), icon: Icon(Icons.remove)),
                Text('$counter', style: TextStyle(fontSize: 20)),
                IconButton(onPressed: () => setState(() => counter++), icon: Icon(Icons.add)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return tasks.isEmpty
        ? Center(child: Text("No tasks yet."))
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final task = tasks[i];
              return ListTile(
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (_) => _toggleTask(i),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(i),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        actions: [
          IconButton(onPressed: _showAddTaskDialog, icon: Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildCounter(),
            Divider(),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }
}
