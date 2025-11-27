import 'dart:ui';
import 'package:apptapp/todo_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calculator_app.dart';
import 'counter_app.dart';
import 'moneyTracker_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animation controller for the staggered entrance
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure status bar icons are white
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115), // Deep Dark Background
      body: Stack(
        children: [
          // 1. Ambient Background Glows
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.15),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.15), blurRadius: 100, spreadRadius: 50)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34D399).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF34D399).withOpacity(0.1), blurRadius: 100, spreadRadius: 50)
                ],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: 20),

                // Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(width: 4, height: 16, color: const Color(0xFF6366F1)), // Accent Bar
                      const SizedBox(width: 8),
                      Text(
                        "COMMAND CENTER",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Animated App Grid
                Expanded(
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                    children: [
                      _buildAnimatedCard(
                        index: 0,
                        title: 'Tasks',
                        subtitle: 'Directives',
                        icon: Icons.check_circle_outline,
                        gradientColors: [const Color(0xFFC084FC), const Color(0xFF6366F1)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TodoApp())),
                      ),
                      _buildAnimatedCard(
                        index: 1,
                        title: 'Wallet',
                        subtitle: 'Finances',
                        icon: Icons.account_balance_wallet_outlined,
                        gradientColors: [const Color(0xFF34D399), const Color(0xFF059669)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoneyTrackerApp())),
                      ),
                      _buildAnimatedCard(
                        index: 2,
                        title: 'Tally',
                        subtitle: 'Counter',
                        icon: Icons.ads_click,
                        gradientColors: [const Color(0xFF22D3EE), const Color(0xFF0EA5E9)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CounterApp())),
                      ),
                      _buildAnimatedCard(
                        index: 3,
                        title: 'Maths',
                        subtitle: 'Calculator',
                        icon: Icons.calculate_outlined,
                        gradientColors: [const Color(0xFFF472B6), const Color(0xFFDB2777)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorApp())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RupantorSoft',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF22D3EE).withOpacity(0.8), // Cyan glow text
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'AppTapp Hub',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a module to begin operations.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  // Wraps the card in an animation builder for the staggered entry effect
  Widget _buildAnimatedCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate delay based on index
        double delay = index * 0.15;
        double start = delay;
        double end = delay + 0.4; // Animation lasts 40% of total duration per item

        var slideCurve = CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOutBack),
        );

        var fadeCurve = CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut),
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - slideCurve.value)), // Slide up 50px
          child: Opacity(
            opacity: fadeCurve.value,
            child: _buildCyberCard(title, subtitle, icon, gradientColors, onTap),
          ),
        );
      },
    );
  }

  Widget _buildCyberCard(
      String title,
      String subtitle,
      IconData icon,
      List<Color> gradientColors,
      VoidCallback onTap,
      ) {
    return Container(
      decoration: BoxDecoration(
        // Dark Surface with Gradient Border Simulation
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          // Subtle glow matching the brand color
          BoxShadow(
            color: gradientColors.first.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: const Color(0xFF1C1E26).withOpacity(0.8), // Semi-transparent dark bg
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: gradientColors.first.withOpacity(0.1),
          highlightColor: gradientColors.first.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: gradientColors.first.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: gradientColors.first, size: 28),
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
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ],
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