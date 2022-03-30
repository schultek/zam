library photos_module;

import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../module.dart';
import 'pages/select_photos_album_page.dart';
import 'providers/google_account_provider.dart';
import 'providers/photos_provider.dart';
import 'widgets/photos_album_shortcut_card.dart';

export '../module.dart';

part 'elements/album_content_element.dart';
part 'photos.models.dart';

class PhotosModule extends ModuleBuilder {
  PhotosModule() : super('photos');

  @override
  String getName(BuildContext context) => context.tr.photos;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'album': AlbumContentElement(),
      };
}
