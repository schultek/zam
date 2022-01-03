import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
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
              const Text(
                'Bei Jufa anmelden',
                style: TextStyle(color: Colors.white, fontSize: 45),
              ),
              const Spacer(flex: 1),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    context.read(authLogicProvider).signInAnonymously();
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        'Als Gast anmelden',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        'Mit Telefonnummer anmelden',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
