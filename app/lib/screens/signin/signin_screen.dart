import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/auth/logic_provider.dart';
import '../../widgets/ju_background.dart';
import 'phone_signin_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

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
                context.tr.login_to_jufa,
                style: const TextStyle(color: Colors.white, fontSize: 45),
              ),
              const Spacer(flex: 1),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    context.read(authLogicProvider).signInAnonymously();
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                        context.tr.login_as_guest,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context).push(PhoneSignInScreen.route());
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                        context.tr.login_with_phone,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.tr.signin_disclaimer_1 + ' ',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text: context.tr.signin_tos,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://jufa20.web.app/terms-of-service.html');
                        },
                    ),
                    TextSpan(
                      text: ' ' + context.tr.signin_disclaimer_2 + ' ',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text: context.tr.signin_pp,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://jufa20.web.app/privacy-policy.html');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
