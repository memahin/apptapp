import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {

  int _count = 0;

  void _increment(){
    setState(() {
      _count++;
    });
  }

  void _decrement(){
    setState((){
      _count--;
    });
  }

  void _reset(){
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(padding: EdgeInsetsGeometry.all(16),

      ),
    );
  }
}
