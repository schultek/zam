import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import 'core/core.dart';
import 'helpers/extensions.dart';
import 'providers/auth/user_provider.dart';
import 'providers/general/l10n_provider.dart';
import 'providers/general/loading_provider.dart';
import 'providers/groups/selected_group_provider.dart';
import 'providers/links/links_provider.dart';
import 'providers/links/shortcuts_provider.dart';
import 'screens/group/group_screen.dart';
import 'screens/loading/loading_link_screen.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/signin/signin_screen.dart';
import 'widgets/nested_will_pop_scope.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    runApp(const ProviderScope(child: InheritedConsumer(child: JufaApp())));
  }, (error, stack) async {
    try {
      Firebase.app();
    } catch (_) {
      await Firebase.initializeApp();
    }
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class JufaApp extends StatefulWidget {
  const JufaApp({Key? key}) : super(key: key);

  @override
  _JufaAppState createState() => _JufaAppState();
}

class _JufaAppState extends State<JufaApp> {
  var navigatorKey = GlobalKey<NavigatorState>();
  bool updateNavigatorKey = false;

  @override
  void initState() {
    super.initState();
    context.read(shortcutsProvider).checkIsLaunchedFromShortcut();
  }

  @override
  void reassemble() {
    super.reassemble();
    updateNavigatorKey = false;
  }

  @override
  Widget build(BuildContext context) {
    if (updateNavigatorKey) {
      navigatorKey = GlobalKey();
    }
    updateNavigatorKey = true;
    return MaterialApp(
      title: 'Jufa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        context.read(l10nStateProvider.notifier).state = context.tr;
        return child!;
      },
      home: buildHome(context),
    );
  }

  Widget buildHome(BuildContext context) {
    var isLoading = context.watch(isLoadingProvider);
    if (isLoading) {
      return const LoadingScreen();
    }

    var isProcessingLink = context.watch(isProcessingLinkProvider);
    if (isProcessingLink) {
      return const LoadingLinkScreen();
    }

    var isSignedIn = context.watch(isSignedInProvider);
    if (!isSignedIn) {
      return const SignInScreen();
    }

    var selectedGroupId = context.watch(selectedGroupIdProvider);
    if (selectedGroupId != null) {
      return NestedWillPopScope(
        onWillPop: () async => false,
        child: GroupScreen(key: ValueKey(selectedGroupId)),
      );
    }

    return GroupTheme(
      theme: GroupThemeData(FlexScheme.green, true),
      child: const SelectGroupPage(),
    );
  }
}
