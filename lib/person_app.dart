import 'package:flutter/cupertino.dart';

class PersonApp extends StatefulWidget {
  const PersonApp({super.key});

  @override
  State<PersonApp> createState() => _PersonAppState();
}

class _PersonAppState extends State<PersonApp> {
  List<PersonType> person = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class PersonType {
  late String text;
  late bool isCompleted;
}
