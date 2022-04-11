import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/auth/logic_provider.dart';
import '../../widgets/ju_layout.dart';
import 'phone_signin_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JuLayout(
      header: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'One Space for Everything',
            style: context.theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            'Organize group trips, events and more. Customize your group space to best fit your needs.',
            style: context.theme.textTheme.bodyLarge!.copyWith(
                color: Colors.white.withOpacity(0.9), height: 1.5, fontSize: 16, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.tr.signin_disclaimer_1 + ' ',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white70),
                ),
                TextSpan(
                  text: context.tr.signin_tos,
                  style:
                      Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch('https://jufa20.web.app/terms-of-service.html');
                    },
                ),
                TextSpan(
                  text: ' ' + context.tr.signin_disclaimer_2 + ' ',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white70),
                ),
                TextSpan(
                  text: context.tr.signin_pp,
                  style:
                      Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch('https://jufa20.web.app/privacy-policy.html');
                    },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              padding: const EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            child: Text(
              context.tr.login_as_guest,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              context.read(authLogicProvider).signInAnonymously();
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              padding: const EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            child: Text(
              context.tr.login_with_phone,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Navigator.of(context).push(PhoneSignInScreen.route());
            },
          ),
        ],
      ),
    );
  }
}
