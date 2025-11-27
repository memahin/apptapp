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

  void _addDigital(String digit) {
    setState(() {
      if (_isNewNumber) {
        _display = digit;
        _isNewNumber = false;
      } else {
        if (_display == 0) {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });
  }

  void _addDecimal() {
    setState(() {
      if (_isNewNumber) {
        _display = '0.';
        _isNewNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _setOperation(String operation) {
    setState(() {
      _firstNumber = _display;
      _operation = operation;
      _isNewNumber = true;
    });
  }

  void _calculate() {
    if (_firstNumber.isNotEmpty && _operation.isNotEmpty) {
      setState(() {
        double first = double.parse(_firstNumber);
        double second = double.parse(_display);
        double result = 0;
        switch (_operation) {
          case '+':
            result = first + second;
            break;
          case '-':
            result = first - second;
            break;
          case 'x':
            result = first * second;
            break;
          case '%':
            result = first % second;
            break;
          case '÷':
            if (second != 0) {
              result = first / second;
            } else {
              _display = 'Error';
              _isNewNumber = true;
              _firstNumber = '';
              _operation = '';
              return;
            }
            break;
        }
        _display = result.toString();
        if (_display.endsWith('.0')) {
          _display = _display.substring(0, _display.length - 2);
        }
        _isNewNumber = true;
        _firstNumber = '';
        _operation = '';
      });
    }
  }


  void _clear() {
    setState(() {
      _display = '0';
      _firstNumber = '';
      _operation = '';
      _isNewNumber = true;
    });
  }

  void _clearEntry() {
    setState(() {
      _display = '0';
      _isNewNumber = true;
    });
  }

  void _changeSign() {
    setState(() {
      if(_display != '0'){
        if(_display.startsWith('-')){
          _display = _display.substring(1);
        }else{
          _display = '-$_display';
        }
      }
    });
  }

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
                            'x',
                            Colors.orange,
                                () => _setOperation('x'),
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
                            () => _addDigital('7'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '8',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('8'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '9',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('9'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '÷',
                            Colors.orange,
                            () => _setOperation('÷'),
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
                            '4',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('4'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '5',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('5'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '6',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('6'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '-',
                            Colors.orange,
                            () => _setOperation('-'),
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
                            '1',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('1'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '2',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('2'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '3',
                            Colors.grey.withOpacity(0.6),
                            () => _addDigital('3'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '+',
                            Colors.orange,
                            () => _setOperation('+'),
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
                            '0',
                            Colors.grey.withOpacity(0.6),
                                () => _addDigital('0'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '.',
                              Colors.orange,
                                _addDecimal,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '%',
                            Colors.orange,
                                () => _setOperation('%'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '=',
                            Colors.green,
                                _calculate,
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
    child: Text(text, style: TextStyle(fontSize: 15)),
  );
}
