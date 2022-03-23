import 'dart:async';

import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
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

  TextEditingValue formatPhoneNumberInput(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = '';
    var selection = newValue.selection.baseOffset;
    var newText = newValue.text.split('');
    var i = 0;
    while (newText.isNotEmpty) {
      var char = newText.removeAt(0);
      if (i == 0) {
        if (char == '+') {
          text += char;
        } else if (char == '0') {
          text += '+49';
          i += 2;
          selection += 2;
        } else {
          text += '+$char';
          i++;
          selection++;
        }
      } else {
        if (i == 3 || i == 7) {
          text += ' ';
          selection++;
        }

        if (char == '+') {
          i--;
          selection--;
        } else {
          text += char;
        }
      }
      i++;
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selection),
    );
  }

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

  String _getTitleText() {
    if (invitationLink?.path.endsWith('/organizer') ?? false) {
      return context.tr.become_organizer;
    } else if (invitationLink?.path.endsWith('/admin') ?? false) {
      return context.tr.become_admin;
    } else if (context.read(userProvider).value != null) {
      return context.tr.add_phone_number;
    } else {
      return context.tr.login_with_phone;
    }
  }

  Future<void> verifyPhoneNumber([int? smsToken]) async {
    var completer = Completer();
    await context.read(authLogicProvider).verifyPhoneNumber(
          phoneNumber ?? '',
          resendToken: smsToken,
          onSent: (String verificationId, int? resendToken) async {
            completer.complete();
            if (smsToken == null) {
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
          onFailed: (err) {
            if (!mounted) return;
            print(err);

            var msg = '';
            switch (err.code) {
              case 'invalid-phone-number':
                msg = context.tr.invalid_phone_number;
                break;
              default:
                msg = '${context.tr.unknown_error} (${err.code})';
                break;
            }

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(msg),
            ));

            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );
    await completer.future;
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
                      decoration: InputDecoration(
                        hintText: context.tr.enter_phone_number,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
                        fillColor: Colors.transparent,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[+0-9]')),
                        TextInputFormatter.withFunction(formatPhoneNumberInput),
                      ],
                      style: const TextStyle(fontSize: 24),
                      onChanged: (text) => setState(() => phoneNumber = text),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              Text(
                context.tr.proceed_and_accept_disclaimer,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.95)),
              ),
              const SizedBox(height: 20),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
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
                          : Text(
                              context.tr.send_code,
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
