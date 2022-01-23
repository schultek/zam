import 'package:flutter/material.dart';

import '../../../../core/widgets/settings_section.dart';
import '../../../../helpers/extensions.dart';
import '../../chat_provider.dart';
import 'add_members_page.dart';
import 'members_page.dart';

class ChannelInfoPage extends StatefulWidget {
  final ChannelInfo channel;
  const ChannelInfoPage(this.channel, {Key? key}) : super(key: key);

  @override
  _ChannelInfoPageState createState() => _ChannelInfoPageState();

  static Route<bool> route(ChannelInfo channel) {
    return MaterialPageRoute(builder: (context) => ChannelInfoPage(channel));
  }
}

class _ChannelInfoPageState extends State<ChannelInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.channel_details),
      ),
      body: ListView(
        children: [
          SettingsSection(children: [
            ListTile(
              title: Text(context.tr.add_members),
              onTap: () {
                Navigator.of(context).push(AddMembersPage.route(widget.channel));
              },
            ),
            ListTile(
              title: Text(context.tr.members),
              onTap: () {
                Navigator.of(context).push(MembersPage.route(widget.channel));
              },
            ),
          ]),
          SettingsSection(children: [
            ListTile(
              title: Text(
                context.tr.leave,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pop(true);
              },
            ),
          ]),
        ],
      ),
    );
  }
}
