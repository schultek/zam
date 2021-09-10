import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:spotify/spotify.dart';

import '../../models/models.dart';

export 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

@MappableClass()
class MusicConfig {
  final SpotifyCredentials? credentials;
  final SpotifyPlaylist? playlist;
  final SpotifyPlayer? player;

  MusicConfig({this.credentials, this.player, this.playlist});
}

@MappableClass()
class SpotifyPlayer with Mappable {
  SpotifyTrack track;
  bool isPlaying;
  int? progressMs;

  SpotifyPlayer(this.track, this.isPlaying, this.progressMs);
}

extension ToSpotifyPlayer on Player {
  SpotifyPlayer toSpotifyPlayer() => SpotifyPlayer(item!.toSpotifyTrack(), isPlaying!, progress_ms);
}

@MappableClass()
class SpotifyCredentials with Mappable {
  final String accessToken;
  final String refreshToken;
  final Timestamp expiration;

  SpotifyCredentials(this.accessToken, this.refreshToken, this.expiration);
}

@MappableClass()
class SpotifyPlaylist {
  final String id;
  final String name;
  final List<SpotifyImage> images;
  final String uri;
  final String spotifyUrl;
  final List<SpotifyTrack> tracks;

  SpotifyPlaylist(this.id, this.name, this.images, this.uri, this.spotifyUrl, this.tracks);
}

extension ToSpotifyPlaylist on Playlist {
  SpotifyPlaylist toSpotifyPlaylist(Iterable<Track> tracks) => SpotifyPlaylist(
      id!,
      name!,
      images!.map((i) => i.toSpotifyImage()).toList(),
      uri!,
      externalUrls!.spotify!,
      tracks.map((t) => t.toSpotifyTrack()).toList());
}

@MappableClass()
class SpotifyTrack with Mappable {
  final String name;
  final String id;
  final String uri;
  final SpotifyAlbum album;
  final List<SpotifyArtist> artists;
  final int durationMs;

  SpotifyTrack(this.name, this.id, this.uri, this.album, this.artists, this.durationMs);
}

extension ToSpotifyTrack on Track {
  SpotifyTrack toSpotifyTrack() => SpotifyTrack(
      name!, id!, uri!, album!.toSpotifyAlbum(), artists!.map((a) => a.toSpotifyArtist()).toList(), durationMs!);
}

@MappableClass()
class SpotifyAlbum {
  final String id;
  final String uri;
  final String name;
  final List<SpotifyImage> images;

  SpotifyAlbum(this.id, this.uri, this.name, this.images);
}

extension ToSpotifyAlbum on AlbumSimple {
  SpotifyAlbum toSpotifyAlbum() => SpotifyAlbum(id!, uri!, name!, images!.map((i) => i.toSpotifyImage()).toList());
}

@MappableClass()
class SpotifyImage {
  final int height;
  final int width;
  final String url;

  SpotifyImage(this.height, this.width, this.url);
}

extension ToSpotifyImage on Image {
  SpotifyImage toSpotifyImage() => SpotifyImage(height ?? 0, width ?? 0, url!);
}

@MappableClass()
class SpotifyArtist {
  final String id;
  final String name;

  SpotifyArtist(this.id, this.name);
}

extension ToSpotifyArtist on Artist {
  SpotifyArtist toSpotifyArtist() => SpotifyArtist(id!, name!);
}
