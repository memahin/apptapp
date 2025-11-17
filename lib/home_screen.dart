import 'package:apptapp/todo_app.dart';
import 'package:flutter/material.dart';
import 'calculator_app.dart';
import 'counter_app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppTapp'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to AppTapp!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Click on any app below:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // To-Do App Button
            _buildAppCard(
              context,
              '📝 To-Do App',
              'Add, remove, and mark tasks as complete',
              'Manage a list of items',
              Icons.check_box,
              Colors.green,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoApp()),
              ),
            ),

            const SizedBox(height: 16),

            // Counter App Button
            _buildAppCard(
              context,
              '🔢 Counter App',
              'Increment and decrement a number',
              'Simple number changes',
              Icons.add_circle,
              Colors.blue,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CounterApp()),
              ),
            ),

            const SizedBox(height: 16),

            // Calculator App Button
            _buildAppCard(
              context,
              '🧮 Calculator App',
              'Perform basic mathematical operations',
              'Simple calculations',
              Icons.calculate,
              Colors.orange,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalculatorApp()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppCard(
      BuildContext context,
      String title,
      String description,
      String learning,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      learning,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}