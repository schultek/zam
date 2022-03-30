library polls_module;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../module.dart';
import 'builders/polls_list_builder.dart';
import 'pages/create_poll_page.dart';
import 'pages/polls_page.dart';

export '../module.dart';

part 'elements/new_poll_action_element.dart';
part 'elements/poll_content_element.dart';
part 'elements/polls_content_element.dart';
part 'elements/polls_list_content_element.dart';
part 'polls.models.dart';
part 'polls.provider.dart';

class PollsModule extends ModuleBuilder {
  PollsModule() : super('polls');

  @override
  String getName(BuildContext context) => context.tr.polls;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        // 'poll': PollContentElement(),
        // 'new_poll_action': NewPollActionElement(),
        // 'polls': PollsContentElement(),
        // 'polls_list': PollsListContentElement(),
      };
}
