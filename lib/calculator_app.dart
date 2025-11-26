import 'package:flutter/material.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _display = '0';
  String _firstNumber = '';
  String _operation = '';
  bool _isNewNumber = true;

  void _addDigital() {}

  void _addDecimal() {}

  void _setOperation() {}

  void _calculate() {}

  void _clear() {}

  void _clearEntry() {}

  void _changeSign() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
