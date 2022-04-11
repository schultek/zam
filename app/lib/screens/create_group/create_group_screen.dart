import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../core/widgets/template_preview_switcher.dart';
import '../../helpers/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/groups/selected_group_provider.dart';
import '../../widgets/ju_layout.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String? groupName;

  static Future<DocumentReference> createNewGroup(String groupName, String userId) {
    var group = Group(
      id: '',
      name: groupName,
      users: {userId: GroupUser(role: UserRoles.organizer)},
      template: const SwipeTemplateModel(),
      theme: ThemeModel(schemeIndex: FlexScheme.blue.index),
      moduleBlacklist: ['music', 'photos', 'polls'],
    );
    return FirebaseFirestore.instance.collection('groups').add(group.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return JuLayout(
      height: 500,
      header: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            context.tr.create_new_group,
            style: context.theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: GroupTheme(
        theme: GroupThemeData(FlexScheme.blue, true),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: context.tr.enter_group_name,
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.black45),
                      fillColor: Colors.transparent,
                    ),
                    style: const TextStyle(color: Colors.black),
                    onChanged: (text) {
                      setState(() => groupName = text);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: TemplateSwitcher(
                style: SwitcherStyle.card,
                onTemplateChanged: (template) {},
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                padding: const EdgeInsets.all(20),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              child: Text(
                context.tr.create_group,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              onPressed: () async {
                if (groupName == null) return;
                DocumentReference doc = await createNewGroup(groupName!, context.read(userIdProvider)!);
                context.read(selectedGroupIdProvider.notifier).state = doc.id;
              },
            ),
          ],
        ),
      ),
    );
  }
}
