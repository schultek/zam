import 'package:cached_network_image/cached_network_image.dart';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/extensions.dart';
import '../../../modules/modules.dart';
import '../../../providers/auth/claims_provider.dart';
import '../../../providers/groups/logic_provider.dart';
import '../../../providers/groups/selected_group_provider.dart';
import '../../core.dart';
import '../../widgets/input_list_tile.dart';
import '../../widgets/select_image_list_tile.dart';
import 'ju_logo.dart';

class GroupSettingsBuilder {
  List<Widget> build(BuildContext context) {
    var group = context.watch(selectedGroupProvider)!;

    //var templateSettings = group.template.settings(context);
    var moduleSettings = registry.getSettings(context);

    return [
      SettingsSection(children: [
        InputListTile(
          label: context.tr.name,
          value: group.name,
          onChanged: (value) {
            context.read(groupsLogicProvider).updateGroup({'name': value});
            context.read(groupsLogicProvider).updateLogo(group.copyWith(name: value));
          },
        ),
        SelectImageListTile(
          label: 'Logo',
          hasImage: true,
          leading: SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: group.pictureUrl != null
                  ? CachedNetworkImage(
                      imageUrl: group.pictureUrl!,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    )
                  : JuLogo(
                      size: 40,
                      name: group.name,
                      theme: group.theme,
                    ),
            ),
          ),
          onImageSelected: (bytes) async {
            var link = await context.read(groupsLogicProvider).setGroupPicture(bytes);
            context.read(groupsLogicProvider).updateLogo(group.copyWith(pictureUrl: link));
          },
          onDelete: group.pictureUrl != null
              ? () {
                  context.read(groupsLogicProvider).deleteGroupPicture();
                  context.read(groupsLogicProvider).updateLogo(group.copyWith(pictureUrl: null));
                }
              : null,
          crop: OverlayType.rectangle,
          maxWidth: 100,
        ),
      ]),
      // SettingsSection(
      //   title: context.tr.template,
      //   children: [
      //     Builder(builder: (context) {
      //       return Row(
      //         children: [
      //           Expanded(
      //             child: ListTile(
      //               title: Text(group.template.name),
      //               subtitle: Text(context.tr.tap_to_change),
      //               onTap: () async {
      //                 var newTemplate = await TemplatePreviewSwitcherDialog.show(context, group.template);
      //
      //                 if (newTemplate != null) {
      //                   context.read(groupsLogicProvider).updateTemplateModel(newTemplate);
      //                 }
      //               },
      //             ),
      //           ),
      //           PreviewBox(preview: group.template.preview())
      //         ],
      //       );
      //     }),
      //     ...templateSettings
      //   ],
      // ),
      SettingsSection(title: context.tr.theme, children: [
        ThemeSelector(
          schemeIndex: group.theme.schemeIndex,
          onChange: (index) {
            context.read(groupsLogicProvider).updateGroup({'theme': group.theme.copyWith(schemeIndex: index).toMap()});
            context.read(groupsLogicProvider).updateLogo(group.copyWith.theme(schemeIndex: index));
          },
        ),
        SwitchListTile(
          title: Text(context.tr.dark_mode),
          value: group.theme.dark,
          onChanged: (value) {
            context.read(groupsLogicProvider).updateGroup({'theme': group.theme.copyWith(dark: value).toMap()});
            context.read(groupsLogicProvider).updateLogo(group.copyWith.theme(dark: value));
          },
        ),
      ]),
      for (var settings in moduleSettings)
        SettingsSection(
          title: settings.key,
          children: settings.value.toList(),
        ),
      SettingsSection(title: context.tr.danger_zone, children: [
        ListTile(
          title: Text(
            context.tr.leave,
            style: TextStyle(color: context.theme.colorScheme.error, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            showConfirmDialog(
              context,
              '${context.tr.do_want_to_leave}${group.name}?',
              '',
              context.tr.leave,
              () => context.read(groupsLogicProvider).leaveSelectedGroup(),
            );
          },
        ),
        if (context.read(isGroupCreatorProvider))
          ListTile(
            title: Text(
              context.tr.delete,
              style: TextStyle(color: context.theme.colorScheme.error, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showConfirmDialog(
                context,
                '${context.tr.do_want_to_delete}${group.name}?',
                context.tr.cant_be_undone,
                context.tr.delete,
                () => context.read(groupsLogicProvider).deleteSelectedGroup(),
              );
            },
          ),
      ]),
    ];
  }

  void showConfirmDialog(BuildContext context, String title, String content, String action, Function() onConfirmed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(context.tr.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(action),
            onPressed: onConfirmed,
          ),
        ],
      ),
    );
  }
}
