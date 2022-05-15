import 'package:flutter/material.dart';

import '../split.module.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({Key? key}) : super(key: key);

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();

  static Route<ExpenseEntry> route() {
    return MaterialPageRoute(builder: (context) => const NewExpensePage());
  }
}

class _NewExpensePageState extends State<NewExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
