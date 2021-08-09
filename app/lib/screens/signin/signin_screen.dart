import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/logic_provider.dart';
import '../../providers/links/links_provider.dart';
import '../../widgets/ju_background.dart';
import 'sms_code_screen.dart';

class SignInScreen extends StatefulWidget {
  final Uri? invitationLink;
  const SignInScreen(this.invitationLink);
  @override
  _SignInScreenState createState() => _SignInScreenState();

  static Route route(Uri invitationLink) {
    return MaterialPageRoute(builder: (context) => SignInScreen(invitationLink));
  }

  static MaterialPage page(Uri link) {
    return MaterialPage(child: SignInScreen(link));
  }
}

class _SignInScreenState extends State<SignInScreen> {
  String phoneNumber = "";

  Future<void> _onSignedIn(User user) async {
    if (widget.invitationLink != null) {
      print('HANDLING INVITATION LINK');
      await context.read(linkProvider.notifier).handleReceivedLink(widget.invitationLink!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: JuBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
          child: Column(
            children: [
              const Spacer(),
              Text(
                _getTitleText(),
                style: const TextStyle(color: Colors.white, fontSize: 45),
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
                        hintText: "Telefonnummer eingeben",
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() {
                          phoneNumber = text;
                        });
                      },
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Wenn du fortfährst, akzeptierst du Jufas Nutzungsbedingungen und bestätigst, dass du Jufas Datenschutzerklärung gelesen hast. Wenn du dich per SMS registrierst, können SMS-Gebühren anfallen",
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
                  onTap: () {
                    context.read(authLogicProvider).verifyPhoneNumber(phoneNumber, onSent: (String verificationId) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SmsCodeScreen(verificationId, _onSignedIn),
                      ));
                    }, onCompleted: _onSignedIn);
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        "Code Senden",
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

  String _getTitleText() {
    if (widget.invitationLink?.path.endsWith('/organizer') ?? false) {
      return "Werde Organisator*in. (${widget.invitationLink!.queryParameters['phoneNumber']})";
    } else if (widget.invitationLink?.path.endsWith('/admin') ?? false) {
      return "Werde Administrator.";
    } else {
      return "Mit Telefonnummer anmelden.";
    }
  }
}
