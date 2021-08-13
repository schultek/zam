import 'package:flutter/material.dart';

import '../chat_provider.dart';

class ChannelInfoPage extends StatefulWidget {
  final ChannelInfo channel;
  const ChannelInfoPage(this.channel, {Key? key}) : super(key: key);

  @override
  _ChannelInfoPageState createState() => _ChannelInfoPageState();

  static Route route(ChannelInfo channel) {
    return MaterialPageRoute(builder: (context) => ChannelInfoPage(channel));
  }
}

class _ChannelInfoPageState extends State<ChannelInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Channel details"),
      ),
    );
  }
}
