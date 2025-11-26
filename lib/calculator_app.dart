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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'How to work here:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• When you press numbers: updates display\n'
                    '• When you press operation: stores first number\n'
                    '• When you press =: calculates and shows result\n'
                    '• When you press C: resets all variables\n'
                    '• Multiple variables change together in one display',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _operation.isNotEmpty ? '$_firstNumber $_operation' : '',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            'C',
                            Colors.red.withOpacity(0.6),
                            _clear,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            'CE',
                            Colors.red.withOpacity(0.8),
                            _clearEntry,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '+/-',
                            Colors.orange,
                            _changeSign,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '÷',
                            Colors.orange,
                            () => _setOperation(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            '7',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital(),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '8',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital(),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '9',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital(),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            'x',
                            Colors.orange,
                            () => _setOperation(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButton(
  String text,
  Color color,
  VoidCallback onPressed, {
  int span = 1,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: color == Colors.black ? Colors.white : Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(text, style: TextStyle(fontSize: 20)),
  );
}
