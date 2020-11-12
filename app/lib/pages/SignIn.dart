import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AppState.dart';
import '../service/AuthService.dart';

class EnterPhoneNumber extends StatelessWidget {
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
              phoneNumber = text;
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
              }, (User user) {
                Provider.of<AppState>(context, listen: false).updateUser(user);
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
          ),
        ]),
      ),
    ));
  }
}

class EnterCode extends StatelessWidget {
  String code = "";
  String verificationId;

  EnterCode(this.verificationId);

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
                  code = text;
                },
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                child: Text("Bestätigen"),
                onPressed: () async {
                  var user = await AuthService.verifyCode(code, verificationId);
                  Provider.of<AppState>(context, listen: false).updateUser(user);
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
