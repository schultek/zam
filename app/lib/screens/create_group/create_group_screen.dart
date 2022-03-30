import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/groups/selected_group_provider.dart';
import '../../widgets/ju_background.dart';

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
    return Scaffold(
      body: JuBackground(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const Spacer(),
              Text(
                context.tr.create_new_group,
                style: const TextStyle(color: Colors.white, fontSize: 45),
              ),
              const Spacer(
                flex: 3,
              ),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
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
              const Spacer(
                flex: 3,
              ),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    if (groupName == null) return;
                    DocumentReference doc = await createNewGroup(groupName!, context.read(userIdProvider)!);
                    context.read(selectedGroupIdProvider.notifier).state = doc.id;
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                        context.tr.create_group,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
