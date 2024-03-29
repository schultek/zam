import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/extensions.dart';
import '../../providers/auth/claims_provider.dart';
import '../../providers/auth/logic_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/groups/groups_provider.dart';
import '../../providers/groups/selected_group_provider.dart';
import '../../providers/links/shortcuts_provider.dart';
import '../../screens/admin/admin_panel_screen.dart';
import '../../screens/create_group/create_group_screen.dart';
import '../../screens/signin/phone_signin_screen.dart';
import '../editing/widgets/ju_logo.dart';
import '../models/models.dart';
import '../themes/themes.dart';

class SelectGroupPage extends StatelessWidget {
  const SelectGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groups = context.watch(joinedGroupsProvider);
    var selectedGroup = context.watch(selectedGroupProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.groups),
        actions: [
          if (context.watch(claimsProvider).isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(AdminPanel.route(context));
              },
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (selectedGroup != null) ...[
                  Text(context.tr.selected_group, style: TextStyle(color: context.onSurfaceColor)),
                  const SizedBox(height: 20),
                  groupTile(context, selectedGroup, true),
                  const SizedBox(height: 20),
                ],
                if (groups.where((t) => t.id != selectedGroup?.id).isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(context.tr.available_groups, style: TextStyle(color: context.onSurfaceColor)),
                  const SizedBox(height: 20),
                  for (var group in groups.where((t) => t.id != selectedGroup?.id)) ...[
                    groupTile(context, group, false),
                    const SizedBox(height: 20),
                  ],
                ],
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  if (context.watch(isGroupCreatorProvider)) //
                    ...createGroupSection(context),
                  Expanded(
                    child: groups.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Text(
                                context.tr.no_groups,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  const SizedBox(height: 40),
                  ...accountSection(context),
                  const SizedBox(height: 20),
                  ...aboutSection(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> createGroupSection(BuildContext context) {
    return [
      const Divider(),
      const SizedBox(height: 20),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ThemedSurface(
          builder: (context, color) => Material(
            color: context.surfaceColor,
            child: InkWell(
              child: SizedBox(
                height: 80,
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        children: [
                          const JuLogo(size: 80),
                          Positioned.fill(
                            child: Container(
                              color: context.surfaceColor.withOpacity(0.6),
                              child: const Center(
                                child: Icon(Icons.add_rounded, size: 60),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          context.tr.create_new_group,
                          style: context.theme.textTheme.headline6!.copyWith(color: context.onSurfaceColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(builder: (context) => const CreateGroupScreen()));
              },
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> aboutSection(BuildContext context) {
    var n = 0;
    return [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          n++;
          if (n == 8) {
            n = 0;
            showDevInfo(context);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              context.tr.made_with_love,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
            ),
            Text(
              context.tr.copyright,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      OutlinedButton.icon(
        icon: const Icon(Icons.send),
        label: Text(context.tr.feedback),
        onPressed: () {
          launchUrl(
            Uri.parse('mailto:schulte.kilian97@gmail.com'),
            mode: LaunchMode.externalApplication,
          );
        },
      ),
      const SizedBox(height: 10),
    ];
  }

  List<Widget> accountSection(BuildContext context) {
    var user = context.read(userProvider).value!;

    var logoutButton = OutlinedButton(
      child: Text(context.tr.logout),
      onPressed: () {
        context.read(authLogicProvider).signOut();
      },
    );

    if (user.providerData.any((p) => p.providerId == PhoneAuthProvider.PROVIDER_ID)) {
      return [
        Center(child: Text('${context.tr.logged_in_with} ${user.phoneNumber}')),
        const SizedBox(height: 5),
        Center(child: logoutButton),
      ];
    } else {
      return [
        Text(
          context.tr.logged_in_as_guest,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 10),
        Text(
          context.tr.add_phone_number_hint,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 5),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          children: [
            logoutButton,
            OutlinedButton(
              child: Text(context.tr.add_phone_number),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(PhoneSignInScreen.route());
              },
            ),
          ],
        ),
      ];
    }
  }

  Widget groupTile(BuildContext context, Group group, bool isSelected) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ThemedSurface(
        builder: (context, color) => Material(
          color: context.surfaceColor,
          child: InkWell(
            child: SizedBox(
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: group.pictureUrl != null
                        ? CachedNetworkImage(
                            imageUrl: group.pictureUrl!,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          )
                        : JuLogo(
                            size: 80,
                            name: group.name,
                            theme: group.theme,
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            group.name,
                            style: context.theme.textTheme.headline5!.copyWith(color: context.onSurfaceColor),
                          ),
                          Text(
                            '${group.users.length} ${context.tr.users}',
                            style: context.theme.textTheme.bodySmall!.copyWith(color: context.onSurfaceColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (Platform.isAndroid)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.add_to_home_screen, color: context.onSurfaceColor),
                        onPressed: () {
                          context.read(shortcutsProvider).pinShortcut(
                                id: group.id,
                                name: group.name,
                                theme: group.theme,
                                widget: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  child: JuLogo(size: 40, name: group.name, theme: group.theme),
                                ),
                              );
                        },
                      ),
                    )
                ],
              ),
            ),
            onTap: () {
              if (isSelected) {
                Navigator.pop(context);
              } else {
                context.read(selectedGroupIdProvider.notifier).state = group.id;
              }
            },
          ),
        ),
      ),
    );
  }

  void showDevInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('User Id'),
                subtitle: Text(context.read(userIdProvider) ?? ''),
              ),
              ListTile(
                title: const Text('App Version'),
                subtitle: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Text('${snapshot.data!.version}+${snapshot.data!.buildNumber}');
                    } else if (snapshot.error != null) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Text('Loading...');
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
