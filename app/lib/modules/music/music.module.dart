library music_module;

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oauth2/oauth2.dart' as oauth;
import 'package:riverpod_context/riverpod_context.dart';
import 'package:spotify/spotify.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../module.dart';
import 'widgets/spotify_player.dart';

export 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

export '../module.dart';

part 'elements/player_content_element.dart';
part 'music.models.dart';
part 'music.providers.dart';

class MusicModule extends ModuleBuilder {
  MusicModule() : super('music');

  @override
  String getName(BuildContext context) => context.tr.music;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'player': PlayerContentElement(),
      };
}
