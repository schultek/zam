import 'package:flutter/material.dart';

class CreateGamePage extends StatefulWidget {
  final Function(String) onCreate;
  const CreateGamePage({required this.onCreate, Key? key}) : super(key: key);

  @override
  _CreateGamePageState createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
