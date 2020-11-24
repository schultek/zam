import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AppState.dart';
import '../service/AuthService.dart';

class EnterPhoneNumber extends StatefulWidget {
  @override
  _EnterPhoneNumberState createState() => _EnterPhoneNumberState();
}

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Telefonnummer",
            ),
            onChanged: (text) {
              setState(() {
                phoneNumber = text;
              });
            },
            keyboardType: TextInputType.phone,
          ),
          Container(
            height: 20,
          ),
          ElevatedButton(
            child: Text("Weiter"),
            onPressed: () {
              AuthService.signIn(phoneNumber, (String verificatonId) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterCode(verificatonId)));
              }, (User user) async {
                await Provider.of<AppState>(context, listen: false).updateUser(user);
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
          ),
        ]),
      ),
    ));
  }
}

class EnterCode extends StatefulWidget {
  final String verificationId;

  EnterCode(this.verificationId);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Bitte gebe hier den Code aus der SMS ein"),
              TextField(
                decoration: InputDecoration(
                  labelText: "Code",
                ),
                onChanged: (text) {
                  setState(() {
                    code = text;
                  });
                },
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                child: Text("Bestätigen"),
                onPressed: () async {
                  var user = await AuthService.verifyCode(code, widget.verificationId);
                  await Provider.of<AppState>(context, listen: false).updateUser(user);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
