import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../widgets/loading_shimmer.dart';
import 'music_providers.dart';
import 'widgets/signed_out_player.dart';
import 'widgets/spotify_player.dart';

class MusicModule extends ModuleBuilder<ContentSegment> {
  MusicModule() : super('music');

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'player': buildPlayer,
      };

  FutureOr<ContentSegment?> buildPlayer(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          var signedInValue = ref.watch(spotifyIsSignedInProvider);
          return signedInValue.when(
            data: (signedIn) {
              if (!signedIn) {
                return const SignedOutPlayer();
              } else {
                return const SpotifyPlayer();
              }
            },
            loading: () => const LoadingShimmer(),
            error: (e, st) => Text('${context.tr.error}: $e'),
          );
        },
      ),
    );
  }
}
