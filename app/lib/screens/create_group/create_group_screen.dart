import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/editing/widgets/ju_logo.dart';
import '../../modules/announcement/announcement.module.dart';
import '../../widgets/ju_layout.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String? groupName;
  var theme = ThemeModel(schemeIndex: FlexScheme.blue.index);

  Future<void> createNewGroup() async {
    if (groupName == null) return;

    var group = Group(
      id: '',
      name: groupName!,
      users: {context.read(userIdProvider)!: GroupUser(role: UserRoles.organizer)},
      template: SwipeTemplateModel(),
      theme: theme,
      moduleBlacklist: ['music', 'polls'],
    );
    var doc = await FirebaseFirestore.instance.collection('groups').add(group.toMap());
    context.read(selectedGroupIdProvider.notifier).state = doc.id;
    context.read(groupsLogicProvider).updateLogo(group.copyWith(id: doc.id));
  }

  @override
  Widget build(BuildContext context) {
    return JuLayout(
      height: 360,
      header: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              context.tr.create_new_group,
              style: context.theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      body: GroupTheme(
        theme: GroupThemeData.fromModel(theme),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: JuLogo(
                    size: 68,
                    theme: theme,
                    name: groupName,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
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
                ),
              ],
            ),
            // const SizedBox(height: 20),
            // ClipRRect(
            //   borderRadius: const BorderRadius.all(Radius.circular(20)),
            //   child: TemplateSwitcher(
            //     style: SwitcherStyle.card,
            //     showName: false,
            //     height: 160,
            //     onTemplateChanged: (template) {},
            //   ),
            // ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Builder(builder: (context) {
                return Material(
                  color: context.onSurfaceColor.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 4),
                    child: Column(
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.only(bottom: 10),
                        //   child: Text(
                        //     context.tr.theme,
                        //     style: TextStyle(fontWeight: FontWeight.bold, color: context.surfaceColor),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        ThemeSelector(
                          schemeIndex: theme.schemeIndex,
                          onChange: (index) {
                            setState(() {
                              theme = theme.copyWith(schemeIndex: index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
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
              onPressed: createNewGroup,
            ),
          ],
        ),
      ),
    );
  }
}
