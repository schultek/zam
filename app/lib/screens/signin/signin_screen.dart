import 'dart:async';

import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/logic_provider.dart';
import '../../providers/links/links_provider.dart';
import '../../widgets/ju_background.dart';
import 'sms_code_screen.dart';

class SignInScreen extends StatefulWidget {
  final Uri invitationLink;
  const SignInScreen(this.invitationLink);
  @override
  _SignInScreenState createState() => _SignInScreenState();

  static MaterialPage page(Uri link) {
    return MaterialPage(child: SignInScreen(link));
  }
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.invitationLink.queryParameters['phoneNumber'] ?? '';
  }

  Future<void> _onSignedIn(User user) async {
    await context.read(linkStateProvider.notifier).handleReceivedLink(widget.invitationLink);
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
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                    child: Text(
                      phoneNumber,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Nicht deine Nummer? Dann brauchst du einen anderen Einladungs-Link.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.95)),
              ),
              const Spacer(
                flex: 3,
              ),
              Text(
                'Wenn du fortfährst, akzeptierst du Jufas Nutzungsbedingungen und bestätigst, dass du Jufas Datenschutzerklärung gelesen hast. Wenn du dich per SMS registrierst, können SMS-Gebühren anfallen',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.95)),
              ),
              const SizedBox(height: 20),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    setState(() => isLoading = true);
                    await verifyPhoneNumber();

                    setState(() => isLoading = false);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black87),
                            )
                          : const Text(
                              'Code Senden',
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
    if (widget.invitationLink.path.endsWith('/organizer')) {
      return 'Werde Organisator*in.';
    } else if (widget.invitationLink.path.endsWith('/admin')) {
      return 'Werde Administrator.';
    } else {
      return 'Mit Telefonnummer anmelden.';
    }
  }

  Future<void> verifyPhoneNumber([int? resendToken]) async {
    var completer = Completer();
    await context.read(authLogicProvider).verifyPhoneNumber(
      phoneNumber,
      resendToken: resendToken,
      onSent: (String verificationId, int? resendToken) async {
        completer.complete();
        if (resendToken == null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SmsCodeScreen(
              verificationId,
              _onSignedIn,
              () => verifyPhoneNumber(resendToken),
            ),
          ));
        }
      },
      onCompleted: _onSignedIn,
    );
    await completer.future;
  }
}
