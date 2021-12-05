import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../core/widgets/settings_section.dart';
import '../../../providers/trips/logic_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../widgets/image_selector.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const ProfilePage());
  }
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var user = ref.watch(tripUserProvider);
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      onTap: () async {
                        var logic = ref.read(tripsLogicProvider);
                        var pngBytes = await ImageSelector.fromGallery(context);
                        if (pngBytes != null) {
                          logic.uploadProfileImage(pngBytes);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: context.theme.colorScheme.primary, width: 2),
                            shape: BoxShape.circle,
                            image: user?.profileUrl != null
                                ? DecorationImage(image: CachedNetworkImageProvider(user!.profileUrl!))
                                : null,
                            color: context.surfaceColor),
                        child: user?.profileUrl == null ? const Center(child: Icon(Icons.add, size: 60)) : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SettingsSection(padding: const EdgeInsets.all(14), children: [
                TextFormField(
                  initialValue: user?.nickname,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    suffixIcon: _name != null
                        ? IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              ref.read(tripsLogicProvider).setUserName(_name!);
                              _focusNode.unfocus();
                              setState(() => _name = null);
                            },
                          )
                        : null,
                  ),
                  style: TextStyle(color: context.onSurfaceColor),
                  onChanged: (text) {
                    setState(() => _name = text);
                  },
                  onFieldSubmitted: (text) {
                    ref.read(tripsLogicProvider).setUserName(text);
                  },
                ),
              ]),
            ],
          );
        },
      ),
    );
  }
}
