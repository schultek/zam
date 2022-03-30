import 'package:flutter/material.dart';

import '../notes.module.dart';
import '../pages/change_folder_page.dart';

class NotesSettingsBuilder {
  NotesSettingsBuilder(this.module, this.params);

  final ModuleContext module;
  final NotesListParams params;

  List<Widget> call(BuildContext context) {
    return [
      SwitchListTile(
        value: params.showAdd,
        onChanged: (v) {
          module.updateParams(params.copyWith(showAdd: v));
        },
        title: Text(context.tr.show_add_tile),
      ),
      Builder(builder: (context) {
        return ListTile(
          title: Text(context.tr.folder),
          subtitle: Text(params.folder ?? context.tr.no_folder),
          onTap: () async {
            var newFolder = await Navigator.of(context).push(ChangeFolderPage.route(params.folder));
            if (newFolder != null) {
              module.updateParams(params.copyWith(folder: newFolder.value));
            }
          },
        );
      }),
      if (params.folder == null)
        SwitchListTile(
          value: params.showFolders,
          onChanged: (v) {
            module.updateParams(params.copyWith(showFolders: v));
          },
          title: Text(context.tr.show_folders),
        )
    ];
  }
}
