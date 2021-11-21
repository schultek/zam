import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../widgets/loading_shimmer.dart';
import 'music_providers.dart';
import 'widgets/signed_out_player.dart';
import 'widgets/spotify_player.dart';

class MusicModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return ContentSegment(
      context: context,
      whenRemoved: (context) {
        context.read(musicLogicProvider).signOut();
      },
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
            error: (e, st) => Text('Error: $e'),
          );
        },
      ),
    );
  }
}
