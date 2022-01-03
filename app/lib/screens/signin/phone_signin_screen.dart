import 'dart:async';

import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../providers/auth/logic_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/links/links_provider.dart';
import '../../widgets/ju_background.dart';
import 'sms_code_screen.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({Key? key}) : super(key: key);

  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const PhoneSignInScreen());
  }
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  bool isLoading = false;
  late final String? requiredPhoneNumber;
  String? phoneNumber;
  late final Uri? invitationLink;

  @override
  void initState() {
    super.initState();
    var invitationLink = context.read(linkProvider);
    this.invitationLink = invitationLink;
    requiredPhoneNumber = invitationLink?.queryParameters['phoneNumber'] ?? '';
  }

  Future<void> _onSignedIn(User user) async {
    if (invitationLink != null) {
      await context.read(linkStateProvider.notifier).handleReceivedLink(invitationLink!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
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
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Telefonnummer eingeben',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black45, fontSize: 18),
                        fillColor: Colors.transparent,
                      ),
                      style: const TextStyle(fontSize: 24),
                      onChanged: (text) => setState(() => phoneNumber = text),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
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
                    await verifyPhoneNumber().catchError((_) {});
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
    if (invitationLink?.path.endsWith('/organizer') ?? false) {
      return 'Werde Organisator*in.';
    } else if (invitationLink?.path.endsWith('/admin') ?? false) {
      return 'Werde Administrator.';
    } else if (context.read(userProvider).value != null) {
      return 'Telefonnummer hinzufügen';
    } else {
      return 'Mit Telefonnummer anmelden.';
    }
  }

  Future<void> verifyPhoneNumber([int? resendToken]) async {
    var completer = Completer();
    await context.read(authLogicProvider).verifyPhoneNumber(
      phoneNumber ?? '',
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
    ).catchError((e) {
      print(e);
    });
    await completer.future;
  }
}
