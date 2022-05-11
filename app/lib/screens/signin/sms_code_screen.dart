import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/auth/logic_provider.dart';
import '../../widgets/ju_layout.dart';

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
    return JuLayout(
      header: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            context.tr.enter_sms_code,
            style: context.theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
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
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          RichText(
            text: TextSpan(
              text: context.tr.no_sms_received,
              children: [
                TextSpan(
                  text: context.tr.resend_sms,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      setState(() => isLoading = true);
                      await widget.onResend();
                      setState(() => isLoading = false);
                    },
                ),
              ],
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              padding: const EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            child: isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black87),
                  )
                : Text(
                    context.tr.confirm,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            onPressed: !isLoading && code.isNotEmpty
                ? () async {
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
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
