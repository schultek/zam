import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/auth/logic_provider.dart';
import '../../providers/links/links_provider.dart';
import '../../widgets/ju_layout.dart';
import 'phone_signin_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var invitationLink = context.watch(linkProvider);
    var canUseGuestAuth = invitationLink == null || LinkState.isGroupInvitationLink(invitationLink);

    return JuLayout(
      header: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.tr.one_space_for_everything,
            style: context.theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            context.tr.organize_groups_desc,
            style: context.theme.textTheme.bodyLarge!.copyWith(
                color: Colors.white.withOpacity(0.9), height: 1.5, fontSize: 16, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          if (invitationLink != null) LinkPreview(link: invitationLink),
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
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse('https://jufa.schultek.de/terms-of-service.html'));
                    },
                ),
                TextSpan(
                  text: ' ' + context.tr.signin_disclaimer_2 + ' ',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white70),
                ),
                TextSpan(
                  text: context.tr.signin_pp,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse('https://jufa.schultek.de/privacy-policy.html'));
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
            onPressed: canUseGuestAuth
                ? () async {
                    context.read(authLogicProvider).signInAnonymously();
                  }
                : null,
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

class LinkPreview extends StatelessWidget {
  const LinkPreview({required this.link, Key? key}) : super(key: key);

  final Uri link;

  @override
  Widget build(BuildContext context) {
    String text;
    if (LinkState.isGroupInvitationLink(link)) {
      var groupName = link.queryParameters['name'];
      var isOrganizer = link.queryParameters['role'] == UserRoles.organizer;
      if (groupName != null) {
        text = context.tr.login_to_join_group(utf8.decode(base64Decode(groupName)), isOrganizer);
      } else {
        text = context.tr.login_to_join_group(context.tr.the_group, isOrganizer);
      }
    } else if (LinkState.isOrganizerInvitationLink(link)) {
      text = context.tr.login_to_become_organizer;
    } else {
      text = context.tr.login_to_become_admin;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white30,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.link, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                ),
                const SizedBox(width: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
