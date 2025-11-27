import 'package:apptapp/todo_app.dart';
import 'package:flutter/material.dart';
import 'calculator_app.dart';
import 'counter_app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Softer background
      body: Column(
        children: [
          // 1. Custom Modern Header
          _buildHeader(),

          // 2. Scrollable App Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                crossAxisCount: 2, // 2 Columns for a dashboard look
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85, // Taller cards to fit content
                children: [
                  _buildModernAppCard(
                    context,
                    title: 'To-Do',
                    subtitle: 'Task Manager',
                    tag: 'Lists',
                    icon: Icons.check_circle_outline,
                    startColor: const Color(0xFF6A11CB),
                    endColor: const Color(0xFF2575FC),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TodoApp()),
                    ),
                  ),
                  _buildModernAppCard(
                    context,
                    title: 'Counter',
                    subtitle: 'Tally & Track',
                    tag: 'State Logic',
                    icon: Icons.ads_click,
                    startColor: const Color(0xFF11998e),
                    endColor: const Color(0xFF38ef7d),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CounterApp()),
                    ),
                  ),
                  _buildModernAppCard(
                    context,
                    title: 'Calculator',
                    subtitle: 'Math Ops',
                    tag: 'Logic',
                    icon: Icons.calculate_outlined,
                    startColor: const Color(0xFFFF512F),
                    endColor: const Color(0xFFDD2476),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CalculatorApp()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Header Widget
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AppTapp',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'What would you\nlike to build?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  // Modern Card Widget
  Widget _buildModernAppCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String tag,
        required IconData icon,
        required Color startColor,
        required Color endColor,
        required VoidCallback onTap,
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    // Small "Learning" Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Text Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}