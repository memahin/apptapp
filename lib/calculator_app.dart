import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  // --- Logic Methods (Same as before) ---
  void _onBtnTap(String value) {
    HapticFeedback.lightImpact();
    if (_isNumeric(value)) {
      _addDigit(value);
    } else if (value == '.') {
      _addDecimal();
    } else if (value == 'C') {
      _clear();
    } else if (value == 'CE') {
      _clearEntry();
    } else if (value == '+/-') {
      _changeSign();
    } else if (value == '=') {
      _calculate();
    } else {
      _setOperation(value);
    }
  }

  bool _isNumeric(String s) => double.tryParse(s) != null;

  void _addDigit(String digit) {
    setState(() {
      if (_isNewNumber) {
        _display = digit;
        _isNewNumber = false;
      } else {
        if (_display == '0') _display = digit;
        else if (_display.length < 10) _display += digit;
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
      _calculate();
      _firstNumber = _display;
      _operation = operation;
      _isNewNumber = true;
    });
  }

  void _calculate() {
    if (_firstNumber.isEmpty || _operation.isEmpty) return;
    setState(() {
      double first = double.tryParse(_firstNumber) ?? 0;
      double second = double.tryParse(_display) ?? 0;
      double result = 0;
      switch (_operation) {
        case '+': result = first + second; break;
        case '-': result = first - second; break;
        case 'x': result = first * second; break;
        case '%': result = first % second; break;
        case '÷':
          if (second == 0) {
            _display = 'Error';
            _isNewNumber = true;
            return;
          }
          result = first / second;
          break;
      }
      String resultString = result.toString();
      if (resultString.endsWith('.0')) {
        resultString = resultString.substring(0, resultString.length - 2);
      }
      _display = resultString;
      _firstNumber = '';
      _operation = '';
      _isNewNumber = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0'; _firstNumber = ''; _operation = ''; _isNewNumber = true;
    });
  }

  void _clearEntry() {
    setState(() { _display = '0'; _isNewNumber = true; });
  }

  void _changeSign() {
    setState(() {
      if (_display != '0' && _display != 'Error') {
        if (_display.startsWith('-')) _display = _display.substring(1);
        else _display = '-$_display';
      }
    });
  }

  // --- UI Building Blocks ---

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    // Theme Colors
    final bgDark = const Color(0xFF0F1115);
    final surfaceColor = const Color(0xFF1C1E26);
    final accentColor = const Color(0xFFF472B6); // Pink
    final operatorColor = const Color(0xFFDB2777); // Rose

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text('Math Tools', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      body: Column(
        children: [
          // 1. Display Area
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_firstNumber $_operation',
                    style: TextStyle(
                      color: accentColor.withOpacity(0.7),
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _display,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Keypad Area
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1,
              children: [
                _btn('C', textColor: const Color(0xFFEF4444)), // Red
                _btn('CE', textColor: const Color(0xFFEF4444)),
                _btn('%', textColor: accentColor),
                _btn('÷', textColor: accentColor),

                _btn('7'), _btn('8'), _btn('9'),
                _btn('x', textColor: accentColor),

                _btn('4'), _btn('5'), _btn('6'),
                _btn('-', textColor: accentColor),

                _btn('1'), _btn('2'), _btn('3'),
                _btn('+', textColor: accentColor),

                _btn('+/-'), _btn('0'), _btn('.'),
                _btn('=', bgColor: operatorColor, textColor: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String text, {Color? textColor, Color? bgColor}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xFF0F1115),
        shape: BoxShape.circle,
        boxShadow: bgColor != null ? [
          BoxShadow(color: bgColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0,4))
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () => _onBtnTap(text),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 24,
                fontWeight: bgColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}