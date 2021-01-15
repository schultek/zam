import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../service/auth_service.dart';

class SmsCodeScreen extends StatefulWidget {
  final String verificationId;
  const SmsCodeScreen(this.verificationId);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<SmsCodeScreen> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bitte gebe hier den Code aus der SMS ein"),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Code",
                ),
                onChanged: (text) {
                  setState(() {
                    code = text;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var user = await AuthService.verifyCode(code, widget.verificationId);
                  await Provider.of<AppState>(context, listen: false).updateUser(user);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Bestätigen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
