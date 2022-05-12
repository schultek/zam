import 'package:cached_network_image/cached_network_image.dart';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../../modules/modules.dart';
import '../../modules/profile/widgets/image_selector.dart';
import '../../providers/auth/claims_provider.dart';
import '../../providers/groups/logic_provider.dart';
import '../../providers/groups/selected_group_provider.dart';
import '../themes/themes.dart';
import '../widgets/layout_preview.dart';
import '../widgets/settings_section.dart';
import '../widgets/template_preview_switcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const SettingsPage());
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var group = context.watch(selectedGroupProvider)!;

    var templateSettings = group.template.settings(context);
    var moduleSettings = registry.getSettings(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: GestureDetector(
              onTap: () async {
                var pngBytes = await ImageSelector.fromGallery(context, cropOverlayType: OverlayType.rectangle);
                if (pngBytes != null) {
                  context.read(groupsLogicProvider).setGroupPicture(pngBytes);
                }
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ThemedSurface(
                    builder: (context, color) => Container(
                      color: color,
                      child: group.pictureUrl == null
                          ? Center(child: Icon(Icons.add, size: 60, color: context.onSurfaceHighlightColor))
                          : CachedNetworkImage(
                              imageUrl: group.pictureUrl!,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SettingsSection(padding: const EdgeInsets.all(14), children: [
            TextFormField(
              initialValue: group.name,
              decoration: InputDecoration(labelText: context.tr.name),
              style: TextStyle(color: context.onSurfaceColor),
              onFieldSubmitted: (text) {
                context.read(groupsLogicProvider).updateGroup({'name': text});
              },
            ),
          ]),
          SettingsSection(
            title: context.tr.template,
            children: [
              Builder(builder: (context) {
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(group.template.name),
                        subtitle: Text(context.tr.tap_to_change),
                        onTap: () async {
                          var newTemplate = await TemplatePreviewSwitcherDialog.show(context, group.template);

                          if (newTemplate != null) {
                            context.read(groupsLogicProvider).updateTemplateModel(newTemplate);
                          }
                        },
                      ),
                    ),
                    PreviewBox(preview: group.template.preview())
                  ],
                );
              }),
              ...templateSettings
            ],
          ),
          SettingsSection(title: context.tr.theme, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ThemeSelector(
                schemeIndex: group.theme.schemeIndex,
                onChange: (index) {
                  context
                      .read(groupsLogicProvider)
                      .updateGroup({'theme': group.theme.copyWith(schemeIndex: index).toMap()});
                },
              ),
            ),
            SwitchListTile(
              title: Text(context.tr.dark_mode),
              value: group.theme.dark,
              onChanged: (value) {
                context.read(groupsLogicProvider).updateGroup({'theme': group.theme.copyWith(dark: value).toMap()});
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
        ],
      ),
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
