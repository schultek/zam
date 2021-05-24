import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app_bloc.dart';
import '../../service/auth_service.dart';
import 'sms_code_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Telefonnummer",
              ),
              onChanged: (text) {
                setState(() {
                  phoneNumber = text;
                });
              },
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AuthService.signIn(phoneNumber, (String verificatonId) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SmsCodeScreen(verificatonId)));
                }, (User user) async {
                  await context.read<AppBloc>().updateUser(user);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              },
              child: const Text("Weiter"),
            ),
          ]),
        ),
      ),
    );
  }
}
