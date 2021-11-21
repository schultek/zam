import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'pages/profile_page.dart';

class ProfileModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                color: context.getTextColor(),
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Profil',
                style: Theme.of(context).textTheme.headline6!.copyWith(color: context.getTextColor()),
              ),
            ],
          ),
        ),
      ),
      onNavigate: (context) => const ProfilePage(),
    );
  }
}
