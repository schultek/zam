import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';

import '../../providers/firebase/doc_provider.dart';

const clientId = 'aa587b50876f4c5c979890ed4425d9e2';
const clientSecret = '9d2bc5b37080475b83ae2cce64bec39c';

const apiScopes = ['user-modify-playback-state', 'user-read-playback-state'];
const redirectUri = 'https://jufa20.web.app/spotify/auth';

final musicLogicProvider = Provider((ref) => MusicLogic(ref));

final spotifyApiProvider = StreamProvider<SpotifyApi?>(
    (ref) => ref.watch(moduleDocProvider('music')).snapshots().map((s) => s.data()).map((d) {
          if (d == null || d['credentials'] == null) {
            return null;
          } else {
            var spotifyCredentials = SpotifyApiCredentials(
              clientId,
              clientSecret,
              accessToken: d['credentials']!['accessToken'] as String,
              refreshToken: d['credentials']!['refreshToken'] as String,
              scopes: apiScopes,
              expiration: (d['credentials']!['expiration'] as Timestamp).toDate(),
            );
            return SpotifyApi(spotifyCredentials, onCredentialsRefreshed: (cred) {});
          }
        }));

final playerProvider = StateNotifierProvider<PlayerNotifier, Player?>((ref) => PlayerNotifier(ref));

class PlayerNotifier extends StateNotifier<Player?> {
  final ProviderReference ref;
  PlayerNotifier(this.ref) : super(null) {
    reload();
  }

  Future<void> reload() async {
    var api = ref.watch(spotifyApiProvider).data?.value;
    if (api != null) {
      state = await api.me.player();
    }
  }
}

final spotifyIsPausedProvider = Provider((ref) => !(ref.watch(playerProvider)?.isPlaying ?? false));

final spotifyIsSignedInProvider =
    StreamProvider((ref) => ref.watch(spotifyApiProvider.stream).map((api) => api != null));

class MusicLogic {
  final ProviderReference ref;
  final SpotifyApi? spotify;
  MusicLogic(this.ref) : spotify = ref.watch(spotifyApiProvider).data?.value;

  Future<void> play(String uri) async {
    if (spotify == null) return;
    await spotify!.me.play(uri);
    ref.read(playerProvider.notifier).reload();
  }

  Future<void> resume() async {
    if (spotify == null) return;
    await spotify!.me.play(null);
    ref.read(playerProvider.notifier).reload();
  }

  Future<void> pause() async {
    if (spotify == null) return;
    await spotify!.me.pause();
    ref.read(playerProvider.notifier).reload();
  }

  Future<bool> signOut() async {
    await ref.read(moduleDocProvider('music')).set({'credentials': null});
    return true;
  }

  Future<bool> signInToSpotify(Future<String?> Function(Uri authUri, String redirectUri) makeAuthRequest) async {
    var grant = SpotifyApi.authorizationCodeGrant(SpotifyApiCredentials(clientId, clientSecret));
    var authUri = grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: apiScopes);

    var responseUri = await makeAuthRequest(authUri, redirectUri);
    if (responseUri == null) {
      return false;
    }

    try {
      var cred = await SpotifyApi.fromAuthCodeGrant(grant, responseUri).getCredentials();

      await ref.read(moduleDocProvider('music')).set({
        'credentials': {
          'accessToken': cred.accessToken,
          'refreshToken': cred.refreshToken,
          'expiration': cred.expiration,
        }
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<List<Track>> search(String search) async {
    if (spotify == null) return [];
    var result = spotify!.search.get(search, types: [SearchType.track]);
    var page = await result.first();
    return page.expand((p) => p.items ?? []).cast<Track>().toList();
  }
}
