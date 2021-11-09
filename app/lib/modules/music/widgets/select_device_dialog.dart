import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:spotify/spotify.dart';

import '../../../core/themes/themes.dart';
import '../music_providers.dart';

class SelectDeviceDialog extends StatefulWidget {
  const SelectDeviceDialog({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => const SelectDeviceDialog(),
    );
  }

  @override
  _SelectDeviceDialogState createState() => _SelectDeviceDialogState();
}

class _SelectDeviceDialogState extends State<SelectDeviceDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mit Gerät verbinden'),
      content: SizedBox(
        width: 400,
        child: FutureBuilder<List<Device>>(
          future: context.read(musicLogicProvider).getDevices(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: [
                  for (var device in snapshot.data!)
                    ListTile(
                      leading: Icon(_getIconForType(device.type ?? DeviceType.Unknown)),
                      title: Text(device.name ?? ''),
                      onTap: () {
                        context.read(musicLogicProvider).selectDevice(device.id!);
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              );
            } else {
              return SizedBox(
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(context.getTextColor()),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  IconData? _getIconForType(DeviceType type) {
    switch (type) {
      case DeviceType.Speaker:
        return Icons.speaker_group;
      case DeviceType.Computer:
        return Icons.computer;
      case DeviceType.Smartphone:
        return Icons.phone_iphone;
      case DeviceType.GameConsole:
        return Icons.videogame_asset;
      default:
        return Icons.speaker;
    }
  }
}
