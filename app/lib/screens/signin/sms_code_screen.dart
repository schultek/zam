import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/auth_service.dart';
import '../../widgets/ju_background.dart';

class SmsCodeScreen extends StatefulWidget {
  final String verificationId;
  final Function(User user) onSignedIn;

  const SmsCodeScreen(this.verificationId, this.onSignedIn);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<SmsCodeScreen> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "SMS-Code eingeben.",
                style: TextStyle(color: Colors.white, fontSize: 45),
              ),
              const Spacer(
                flex: 3,
              ),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Code eingeben",
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() {
                          code = text;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Keine SMS erhalten? Nochmal senden",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.95)),
              ),
              const Spacer(
                flex: 3,
              ),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    var user = await AuthService.verifyCode(code, widget.verificationId);
                    await widget.onSignedIn(user);
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        "Bestätigen",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
