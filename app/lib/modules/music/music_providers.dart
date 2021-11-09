import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oauth2/oauth2.dart' as oauth;
import 'package:spotify/spotify.dart';

import '../../models/models.dart';
import '../../providers/firebase/doc_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'music_models.dart';

const clientId = 'aa587b50876f4c5c979890ed4425d9e2';
const clientSecret = '9d2bc5b37080475b83ae2cce64bec39c';

const apiScopes = [
  'user-modify-playback-state',
  'user-read-playback-state',
  'playlist-modify-private',
  'playlist-read-private',
  'playlist-read-collaborative'
];
const redirectUri = 'https://jufa20.web.app/spotify/auth';

final musicLogicProvider = Provider((ref) => MusicLogic(ref));

final musicConfigProvider =
    StreamProvider((ref) => ref.watch(moduleDocProvider('music')).snapshotsMapped<MusicConfig>());

final credentialsProvider = StreamProvider<SpotifyCredentials?>(
    (ref) => ref.watch(musicConfigProvider.stream).map((d) => d.credentials).distinct());
final playlistProvider = Provider<SpotifyPlaylist?>((ref) => ref.watch(musicConfigProvider).asData?.value.playlist);
final playerProvider = Provider<SpotifyPlayer?>((ref) => ref.watch(musicConfigProvider).asData?.value.player);

final spotifyApiProvider = StreamProvider<SpotifyApi?>((ref) {
  return ref.watch(credentialsProvider.stream).map((credentials) {
    if (credentials == null) {
      return null;
    } else {
      var spotifyCredentials = SpotifyApiCredentials(
        clientId,
        clientSecret,
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        scopes: apiScopes,
        expiration: credentials.expiration.toDate(),
      );
      return SpotifyApi(spotifyCredentials, onCredentialsRefreshed: (cred) {
        print('CREDENTIALS REFRESHED $cred');
      });
    }
  });
});

final spotifySyncProvider = Provider((ref) => SpotifyApiSync(ref));

class SpotifyApiSync with WidgetsBindingObserver {
  final Ref ref;

  final SpotifyApi? api;

  Timer? playerTimer;
  int backoffSeconds = 1;

  SpotifyApiSync(this.ref) : api = ref.watch(spotifyApiProvider).asData?.value {
    WidgetsBinding.instance!.addObserver(this);
    ref.onDispose(dispose);
    syncAll();
  }

  Future<void> syncAll() async {
    await Future.wait([syncPlayer(), syncPlaylist()]);
  }

  Future<void> syncPlayer() async {
    var wasTimer = playerTimer != null && !playerTimer!.isActive;
    print('WAS TIMER $wasTimer');

    playerTimer?.cancel();
    playerTimer = null;

    if (api == null) return;
    print('RELOAD PLAYER');
    try {
      var player = (await api!.me.player())?.toSpotifyPlayer();
      var curPlayer = ref.read(playerProvider);

      if (player?.isPlaying == curPlayer?.isPlaying && player?.track == curPlayer?.track) {
        if (!wasTimer) {
          print('NO CHANGES AFTER SYNC, TRY AGAIN IN 1s');
          playerTimer = Timer(const Duration(milliseconds: 1000), syncPlayer);
          return;
        }
      }

      await _updatePlayer(player);

      if (player?.isPlaying == true && player?.track != null) {
        int trackMs = max(0, (player!.track.durationMs) - (player.progressMs ?? 0)) + 1000;
        print('SET TIMER FOR $trackMs');
        playerTimer = Timer(Duration(milliseconds: trackMs), syncPlayer);
      }
    } on oauth.AuthorizationException catch (e) {
      if (e.error == 'invalid_grant') {
        await ref.read(musicLogicProvider).signOut();
        await _updatePlayer(null);
      } else {
        rethrow;
      }
    } catch (e) {
      print('ERROR ON PLAYER $backoffSeconds: $e');
      await _updatePlayer(null);
      backoffSeconds *= 2;
      playerTimer = Timer(Duration(seconds: backoffSeconds), syncPlayer);
    }
  }

  Future<void> _updatePlayer(SpotifyPlayer? player) {
    return _update({'player': player?.toMap()});
  }

  Future<void> syncPlaylist([String? id]) async {
    if (api == null) return;
    print('RELOAD PLAYLIST');
    try {
      var curPlaylistId = id ?? ref.read(playlistProvider)?.id;
      if (curPlaylistId == null) return;

      var playlist = await api!.playlists.get(curPlaylistId);
      var tracks = await api!.playlists.getTracksByPlaylistId(curPlaylistId).all();

      _updatePlaylist(playlist, tracks);
    } catch (e, st) {
      print('ERROR ON PLAYLIST: $e\n$st');
    }
  }

  Future<void> _updatePlaylist(Playlist playlist, Iterable<Track> tracks) {
    return _update({'playlist': playlist.toSpotifyPlaylist(tracks).toMap()});
  }

  Future<void> _update(Map<String, dynamic> data) async {
    await ref.read(moduleDocProvider('music')).set(data, SetOptions(merge: true));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      syncAll();
    }
  }

  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    playerTimer?.cancel();
  }
}

final spotifyIsSignedInProvider =
    StreamProvider((ref) => ref.watch(spotifyApiProvider.stream).map((api) => api != null));

class MusicLogic {
  final Ref ref;
  final SpotifyApi? spotify;
  MusicLogic(this.ref) : spotify = ref.watch(spotifyApiProvider).asData?.value;

  Future<void> play(String? uri, {String? context, dynamic offset}) async {
    if (spotify == null) return;
    try {
      await spotify!.me.play(uri, context: context, offset: offset);
    } catch (e) {
      print('ERROR ON PLAY: $e');
    }
    ref.read(spotifySyncProvider).syncPlayer();
  }

  Future<void> resume() async {
    if (spotify == null) return;
    try {
      await spotify!.me.play(null);
    } catch (e) {
      print('ERROR ON RESUME: $e');
    }
    ref.read(spotifySyncProvider).syncPlayer();
  }

  Future<void> pause() async {
    if (spotify == null) return;
    try {
      await spotify!.me.pause();
    } catch (e) {
      print('ERROR ON PAUSE: $e');
    }
    ref.read(spotifySyncProvider).syncPlayer();
  }

  Future<void> addToQueue(String uri) async {
    if (spotify == null) return;
    try {
      await spotify!.me.queue(uri);
    } catch (e) {
      print('ERROR ON QUEUE: $e');
    }
    ref.read(spotifySyncProvider).syncPlayer();
  }

  Future<void> skipPrevious() async {
    if (spotify == null) return;
    try {
      await spotify!.me.skipPrevious();
    } catch (e) {
      print('ERROR ON SKIP PREV: $e');
    }
    ref.read(spotifySyncProvider).syncPlayer();
  }

  Future<void> skipNext() async {
    if (spotify == null) return;
    try {
      await spotify!.me.skipNext();
    } catch (e) {
      print('ERROR ON SKIP NEXT: $e');
    }
    ref.read(spotifySyncProvider).syncPlayer();
  }

  Future<List<Device>> getDevices() async {
    if (spotify == null) return [];
    try {
      var devices = await spotify!.me.devices();
      return devices.toList();
    } catch (e) {
      print('ERROR ON DEVICES: $e');
      return [];
    }
  }

  Future<bool> signOut() async {
    await ref.read(moduleDocProvider('music')).set({'credentials': null}, SetOptions(merge: true));
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
      }, SetOptions(merge: true));
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

  Future<Iterable<PlaylistSimple>> myPlaylists() async {
    if (spotify == null) return [];
    return Future.wait([
      spotify!.playlists.me.all(),
      // spotify!.playlists.featured.all(),
    ]).then((l) => l.expand((d) => d));
  }

  Future<Playlist?> createSharedPlaylist() async {
    if (spotify == null) return null;
    var user = await spotify!.me.get();
    var playlist = await spotify!.playlists
        .createPlaylist(user.id!, ref.read(selectedTripProvider)!.name, public: false, collaborative: true);
    await ref
        .read(moduleDocProvider('music'))
        .set({'playlist': playlist.toSpotifyPlaylist([]).toMap()}, SetOptions(merge: true));
    return playlist;
  }

  Future<void> selectDevice(String deviceId) async {
    if (spotify == null) return;
    try {
      await spotify!.me.setPlayer(deviceId);
    } catch (e) {
      print('ERROR ON SET DEVICE: $e');
    }
    ref.read(spotifySyncProvider).syncPlayer();
  }

  Future<void> addToPlaylist(String trackUri, String playlistId) async {
    if (spotify == null) return;
    try {
      await spotify!.playlists.addTrack(trackUri, playlistId);
    } catch (e) {
      print('ERROR ON ADD TO PLAYLIST: $e');
    }
    ref.read(spotifySyncProvider).syncPlaylist();
  }

  Future<void> removeFromPlaylist(String trackUri, String playlistId) async {
    if (spotify == null) return;
    try {
      await spotify!.playlists.removeTrack(trackUri, playlistId);
    } catch (e) {
      print('ERROR ON ADD TO PLAYLIST: $e');
    }
    ref.read(spotifySyncProvider).syncPlaylist();
  }
}
