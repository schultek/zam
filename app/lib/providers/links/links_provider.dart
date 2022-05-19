import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../api/api.dart';
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
        var user = ref.read(userProvider);
        if (user.value != null && user.value!.phoneNumber != null) {
          state = LinkState.processing();
          handleReceivedLink(uri);
        } else {
          state = LinkState(uri);
        }
      } else if (uri.path.endsWith('/group')) {
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
    try {
      var claimsChanged = await ref.read(linkApiProvider).onLinkReceived(link.toString());
      if (claimsChanged) {
        await ref.read(claimsProvider.notifier).refresh();
      }
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st);
    } finally {
      state = LinkState.noLink();
    }
  }
}

final linkApiProvider = Provider((ref) => ref.watch(apiProvider).links);

final linkLogicProvider = Provider((ref) => LinkLogic(ref));

class LinkLogic {
  final Ref ref;
  LinkLogic(this.ref);

  Future<String> createOrganizerLink({required BuildContext context, String? phoneNumber}) async {
    var link = await ref.read(linkApiProvider).createOrganizerLink(phoneNumber: phoneNumber);
    return _buildDynamicLink(
      link: link,
      meta: SocialMetaTagParameters(
        title: context.tr.become_organizer,
        description: context.tr.become_organizer_desc,
        imageUrl: Uri.parse('https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200'),
      ),
    );
  }

  Future<String> createAdminLink({required BuildContext context, String? phoneNumber}) async {
    var link = await ref.read(linkApiProvider).createAdminLink(phoneNumber: phoneNumber);
    return _buildDynamicLink(
      link: link,
      meta: SocialMetaTagParameters(
        title: context.tr.become_admin,
        description: context.tr.become_admin_desc,
        imageUrl: Uri.parse('https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200'),
      ),
    );
  }

  Future<String> createGroupInvitationLink({required Group group, String role = UserRoles.participant}) async {
    var link = await ref.read(linkApiProvider).createGroupInvitationLink(group.id, role);
    return _buildDynamicLink(
      link: link,
      meta: SocialMetaTagParameters(
        title: role == UserRoles.participant
            ? group.name
            : "Werde ${role == UserRoles.organizer ? 'Organisator' : 'Teilnehmer'} bei ${group.name}",
        description: 'Trete dem Ausflug bei.',
        imageUrl: Uri.parse(
            group.pictureUrl ?? 'https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200'),
      ),
    );
  }

  Future<String> _buildDynamicLink({required String link, SocialMetaTagParameters? meta}) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://jufa.page.link',
      androidParameters: const AndroidParameters(packageName: 'de.schultek.jufa'),
      iosParameters: const IOSParameters(appStoreId: '1623842177', bundleId: 'de.schultek.jufaapp'),
      socialMetaTagParameters: meta,
      link: Uri.parse(link),
    );
    ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }
}
