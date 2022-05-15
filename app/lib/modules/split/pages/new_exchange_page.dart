import 'package:flutter/material.dart';

import '../split.module.dart';

class NewExchangePage extends StatefulWidget {
  const NewExchangePage({Key? key}) : super(key: key);

  @override
  State<NewExchangePage> createState() => _NewExchangePageState();

  static Route<ExchangeEntry> route() {
    return MaterialPageRoute(builder: (context) => const NewExchangePage());
  }
}

class _NewExchangePageState extends State<NewExchangePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
