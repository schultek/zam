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
import '../groups/selected_group_provider.dart';

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

  static bool isOrganizerInvitationLink(Uri? uri) => uri?.path == '/invitation/organizer';
  static bool isAdminInvitationLink(Uri? uri) => uri?.path == '/invitation/admin';
  static bool isGroupInvitationLink(Uri? uri) => uri?.path == '/invitation/group';
  static bool isInvitationLink(Uri? uri) =>
      isGroupInvitationLink(uri) || isOrganizerInvitationLink(uri) || isAdminInvitationLink(uri);
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
    try {
      await ref.read(firebaseProvider.future);

      var link = await FirebaseDynamicLinks.instance.getInitialLink();
      if (link != null) {
        _handleDynamicLink(link);
      } else {
        state = LinkState.noLink();
      }
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st);
    }

    _linkSub = FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? link) {
      if (link == null) return;
      _handleDynamicLink(link);
    });
  }

  void checkInvitationLink() async {
    if (state is UriLinkState) {
      try {
        await _processLink((state as UriLinkState).uri);
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(e, st);
      } finally {
        state = LinkState.noLink();
      }
    }
  }

  void _handleDynamicLink(PendingDynamicLinkData link) async {
    var uri = link.link;

    if (!LinkState.isInvitationLink(uri)) {
      state = LinkState.noLink();
      return;
    }

    var needsPhoneAuth = !LinkState.isGroupInvitationLink(uri);
    var finallyReset = true;

    try {
      var user = await ref.read(userProvider.future);
      if (user != null && (!needsPhoneAuth || user.phoneNumber != null)) {
        await _processLink(uri);
      } else {
        if (needsPhoneAuth && user != null) {
          await ref.read(authLogicProvider).signOut();
        }
        state = LinkState(uri);
        finallyReset = false;
      }
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st);
    } finally {
      if (finallyReset) {
        state = LinkState.noLink();
      }
    }
  }

  Future<void> _processLink(Uri uri) async {
    state = LinkState.processing();

    var claimsChanged = await ref.read(linkApiProvider).onLinkReceived(uri.toString());
    if (claimsChanged) {
      await ref.read(claimsProvider.notifier).refresh();
    }
    if (LinkState.isGroupInvitationLink(uri)) {
      ref.read(selectedGroupIdProvider.notifier).state = uri.queryParameters['groupId'];
    }
  }
}

final linkApiProvider = Provider((ref) => ref.watch(apiProvider).links);

final linkLogicProvider = Provider((ref) => LinkLogic(ref));

const _appLogoUrl =
    'https://firebasestorage.googleapis.com/v0/b/jufa20.appspot.com/o/180.png?alt=media&token=06c67193-0f25-40d4-9c55-53e36de402c2';

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
        imageUrl: Uri.parse(_appLogoUrl),
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
        imageUrl: Uri.parse(_appLogoUrl),
      ),
    );
  }

  Future<String> createGroupInvitationLink(
      {required BuildContext context, required Group group, String role = UserRoles.participant}) async {
    var link = await ref.read(linkApiProvider).createGroupInvitationLink(group.id, role);
    return _buildDynamicLink(
      link: link,
      meta: SocialMetaTagParameters(
        title: '${group.name}${role == UserRoles.organizer ? ' - ${context.tr.become_organizer}' : ''}',
        description: context.tr.join_the_group,
        imageUrl: Uri.parse(group.pictureUrl ?? _appLogoUrl),
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
