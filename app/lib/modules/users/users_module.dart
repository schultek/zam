library users_module;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/widgets/async_list_tile.dart';
import '../module.dart';
import 'pages/users_page.dart';

export '../module.dart';

part 'elements/users_action_element.dart';
part 'elements/users_content_element.dart';

class UsersModule extends ModuleBuilder {
  UsersModule() : super('users');

  @override
  String getName(BuildContext context) => context.tr.users;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'users': UsersContentElement(),
        'users_action': UsersActionElement(),
      };

  @override
  Iterable<Widget>? getSettings(BuildContext context) sync* {
    yield ListTile(
      title: Text(context.tr.open_users),
      onTap: () => Navigator.of(context).push(UsersPage.route()),
    );
    yield AsyncListTile(
      title: Text(context.tr.invite_participant),
      onTap: () async {
        var group = context.read(selectedGroupProvider)!;
        String link = await context.read(linkLogicProvider).createGroupInvitationLink(context: context, group: group);
        await Share.share('${context.tr.click_link_to_join(group.name)}: $link');
      },
    );
    yield AsyncListTile(
      title: Text(context.tr.invite_organizer),
      onTap: () async {
        var group = context.read(selectedGroupProvider)!;
        String link = await context
            .read(linkLogicProvider)
            .createGroupInvitationLink(context: context, group: group, role: UserRoles.organizer);

        await Share.share('${context.tr.click_link_to_organize(group.name)}: $link');
      },
    );
  }
}
