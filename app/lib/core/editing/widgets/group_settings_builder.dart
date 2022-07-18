import 'package:cached_network_image/cached_network_image.dart';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../helpers/extensions.dart';
import '../../../modules/modules.dart';
import '../../../providers/auth/claims_provider.dart';
import '../../../providers/groups/logic_provider.dart';
import '../../../providers/groups/selected_group_provider.dart';
import '../../../providers/links/links_provider.dart';
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
      _landingPageSection(group),
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

  Widget _landingPageSection(Group group) {
    var isLoading = false;
    return SettingsSection(
      title: 'Landing Page',
      children: [
        StatefulBuilder(builder: (context, setState) {
          if (isLoading) {
            return ListTile(
              title: const Text('Activate custom landing page'),
              subtitle: group.landingPage != null ? Text('jufa.app/${group.landingPage!.slug}') : null,
              trailing: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(context.theme.colorScheme.secondary),
                  ),
                ),
              ),
            );
          } else {
            return SwitchListTile(
              title: const Text('Activate custom landing page'),
              subtitle: group.landingPage != null ? Text('jufa.app/${group.landingPage!.slug}') : null,
              value: group.landingPage?.enabled ?? false,
              onChanged: (value) async {
                setState(() => isLoading = true);
                try {
                  if (!value) {
                    await context
                        .read(groupsLogicProvider)
                        .updateGroup({'landingPage': group.landingPage?.copyWith(enabled: false).toMap()});
                  } else {
                    if (group.landingPage == null) {
                      var landingPage = await context.read(groupsLogicProvider).createLandingPage(group);

                      String link = await context
                          .read(linkLogicProvider)
                          .createGroupInvitationLink(context: context, group: group);
                      landingPage = landingPage.copyWith(link: link);
                      await context.read(groupsLogicProvider).updateGroup({'landingPage': landingPage.toMap()});
                    } else {
                      await context
                          .read(groupsLogicProvider)
                          .updateGroup({'landingPage': group.landingPage!.copyWith(enabled: true).toMap()});
                    }
                  }
                } finally {
                  setState(() => isLoading = false);
                }
              },
            );
          }
        }),
        if (group.landingPage?.enabled ?? false) ...[
          ListTile(
            title: const Text('Visit live page'),
            subtitle: Text('jufa.app/${group.landingPage!.slug}'),
            onTap: () {
              launchUrlString('https://jufa.app/${group.landingPage!.slug}', mode: LaunchMode.externalApplication);
            },
            trailing: const Icon(Icons.open_in_new),
          ),
        ],
      ],
    );
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
