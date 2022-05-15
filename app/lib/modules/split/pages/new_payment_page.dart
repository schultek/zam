import 'package:flutter/material.dart';

import '../split.module.dart';

class NewPaymentPage extends StatefulWidget {
  const NewPaymentPage({Key? key}) : super(key: key);

  @override
  State<NewPaymentPage> createState() => _NewPaymentPageState();

  static Route<PaymentEntry> route() {
    return MaterialPageRoute(builder: (context) => const NewPaymentPage());
  }
}

class _NewPaymentPageState extends State<NewPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
