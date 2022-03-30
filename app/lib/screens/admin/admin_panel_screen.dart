import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const AdminPanel());
  }
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
