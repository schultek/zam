import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../auth/claims_provider.dart';
import '../auth/logic_provider.dart';
import '../auth/user_provider.dart';
import '../firebase/firebase_provider.dart';

final linkStateProvider = StateNotifierProvider<LinkStateNotifier, LinkState>((ref) => LinkStateNotifier(ref));

final linkProvider = Provider((ref) {
  var link = ref.watch(linkStateProvider);
  return link is UriLinkState ? link.uri : null;
});

final isProcessingLinkProvider = Provider((ref) {
  return ref.watch(linkStateProvider.select((s) => s is ProcessingLinkState));
});

class UriLinkState implements LinkState {
  final Uri uri;
  UriLinkState(this.uri);
}

class NoLinkState implements LinkState {}

class ProcessingLinkState implements LinkState {}

class LoadingLinkState implements LinkState {}

class LinkState {
  factory LinkState(Uri uri) = UriLinkState;
  factory LinkState.noLink() = NoLinkState;
  factory LinkState.processing() = ProcessingLinkState;
  factory LinkState.loading() = LoadingLinkState;
}

class LinkStateNotifier extends StateNotifier<LinkState> {
  final Ref ref;

  StreamSubscription<PendingDynamicLinkData>? _linkSub;

  LinkStateNotifier(this.ref) : super(LinkState.loading()) {
    setup();
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  Future<void> setup() async {
    await ref.read(firebaseProvider.future);

    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    if (link != null) {
      await _handleDynamicLink(link);
    }
    if (state is LoadingLinkState) {
      state = LinkState.noLink();
    }

    _linkSub = FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? link) async {
      if (link == null) return;
      await _handleDynamicLink(link);
    });
  }

  Future<void> _handleDynamicLink(PendingDynamicLinkData link) async {
    var uri = link.link;
    if (uri.path.startsWith('/invitation')) {
      if (uri.path.endsWith('/organizer') || uri.path.endsWith('/admin')) {
        state = LinkState(uri);
      } else if (uri.path.endsWith('/trip')) {
        state = LinkState.processing();
        (() async {
          var user = ref.read(userProvider);
          if (user.asData?.value == null) {
            await ref.read(authLogicProvider).signInAnonymously();
          }
          await handleReceivedLink(uri);
        })();
      }
    }
  }

  Future<void> handleReceivedLink(Uri link) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('onLinkReceived');
    var res = await callable.call({'link': link.toString()});
    var claimsChanged = res.data as bool;
    if (claimsChanged) {
      await ref.read(claimsProvider.notifier).refresh();
    }
    state = LinkState.noLink();
  }
}

final linkLogicProvider = Provider((ref) => LinkLogic(ref));

class LinkLogic {
  final Ref ref;
  LinkLogic(this.ref);

  Future<String> createOrganizerLink({required String phoneNumber}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createOrganizerLink');
    var res = await callable.call({'phoneNumber': phoneNumber});
    return _buildDynamicLink(
      link: res.data as String,
      meta: SocialMetaTagParameters(
        title: 'Werde Organisator',
        description: 'Erstelle und manage Ausflüge und andere Gruppen-Events.',
        imageUrl: Uri.parse('https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200'),
      ),
    );
  }

  Future<String> createAdminLink({required String phoneNumber}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createAdminLink');
    var res = await callable.call({'phoneNumber': phoneNumber});
    return _buildDynamicLink(
      link: res.data as String,
      meta: SocialMetaTagParameters(
        title: 'Werde Admin',
        description: 'Erhalte Admin Rechte in der Jufa App.',
        imageUrl: Uri.parse('https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200'),
      ),
    );
  }

  Future<String> createTripInvitationLink({required Trip trip, String role = UserRoles.participant}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createTripInvitationLink');
    var res = await callable.call({'tripId': trip.id, 'role': role});
    return _buildDynamicLink(
      link: res.data as String,
      meta: SocialMetaTagParameters(
        title: role == UserRoles.participant
            ? trip.name
            : "Werde ${role == UserRoles.organizer ? 'Organisator' : 'Leiter'} bei ${trip.name}",
        description: 'Trete dem Ausflug bei.',
        imageUrl: Uri.parse(
            trip.pictureUrl ?? 'https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200'),
      ),
    );
  }

  Future<String> _buildDynamicLink({required String link, SocialMetaTagParameters? meta}) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://jufa.page.link',
      androidParameters: const AndroidParameters(packageName: 'de.schultek.jufa'),
      iosParameters: const IOSParameters(appStoreId: '1582879434', bundleId: 'de.schultek.jufa'),
      socialMetaTagParameters: meta,
      link: Uri.parse(link),
    );
    ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }
}
