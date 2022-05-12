library elimination_module;

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../widgets/needs_setup_card.dart';
import '../module.dart';
import 'builders/games_list_builder.dart';
import 'pages/create_game_page.dart';
import 'pages/games_page.dart';
import 'widgets/elimination_game_card.dart';

export '../module.dart';

part 'elements/game_content_element.dart';
part 'elements/games_action_element.dart';
part 'elements/games_content_element.dart';
part 'elements/games_list_content_element.dart';
part 'elements/new_game_action_element.dart';
part 'elimination.models.dart';
part 'elimination.provider.dart';

class EliminationGameModule extends ModuleBuilder {
  EliminationGameModule() : super('elimination');

  @override
  String getName(BuildContext context) => context.tr.elimination;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'game': GameContentElement(),
        'new_game': NewGameActionElement(),
        'games_action': GamesActionElement(),
        'games': GamesContentElement(),
        'games_list': GamesListContentElement(),
      };
}
