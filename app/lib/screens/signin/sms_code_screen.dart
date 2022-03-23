import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../providers/auth/logic_provider.dart';
import '../../widgets/ju_background.dart';

class SmsCodeScreen extends StatefulWidget {
  final String verificationId;
  final Function(User user) onSignedIn;
  final Future<void> Function() onResend;

  const SmsCodeScreen(this.verificationId, this.onSignedIn, this.onResend, {Key? key}) : super(key: key);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<SmsCodeScreen> {
  bool isLoading = false;
  String code = '';

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
              Text(
                context.tr.enter_sms_code,
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
                      decoration: InputDecoration(
                        hintText: context.tr.enter_code,
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() => code = text);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: context.tr.no_sms_received,
                  children: [
                    TextSpan(
                      text: context.tr.resend_sms,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          setState(() => isLoading = true);
                          await widget.onResend();
                          setState(() => isLoading = false);
                        },
                    ),
                  ],
                  style: TextStyle(color: Colors.white.withOpacity(0.95)),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(
                flex: 3,
              ),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    setState(() => isLoading = true);
                    try {
                      var user = await context.read(authLogicProvider).verifyCode(code, widget.verificationId);
                      await widget.onSignedIn(user);
                    } on FirebaseAuthException catch (e) {
                      print(e);

                      var msg = '';
                      switch (e.code) {
                        case 'credential-already-in-use':
                          msg = context.tr.phone_already_used;
                          break;
                        case 'invalid-verification-code':
                          msg = context.tr.invalid_code;
                          break;
                        default:
                          msg = '${context.tr.unknown_error} (${e.code})';
                          break;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(msg),
                      ));
                    }
                    if (mounted) {
                      setState(() => isLoading = false);
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black87),
                            )
                          : Text(
                              context.tr.confirm,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
