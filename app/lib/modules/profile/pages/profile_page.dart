import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../providers/trips/logic_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../widgets/image_selector.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.getTextColor()),
        title: Text('Profil', style: TextStyle(color: context.getTextColor())),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var user = ref.watch(tripUserProvider);
          return ListView(
            padding: const EdgeInsets.all(50),
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      onTap: () async {
                        var pngBytes = await ImageSelector.fromGallery(context);
                        if (pngBytes != null) {
                          ref.read(tripsLogicProvider).uploadProfileImage(pngBytes);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            user?.profileUrl != null ? CachedNetworkImageProvider(user!.profileUrl!) : null,
                        child: user?.profileUrl == null ? const Center(child: Icon(Icons.add, size: 60)) : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                initialValue: user?.nickname,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                style: TextStyle(color: context.getTextColor()),
                onFieldSubmitted: (text) {
                  ref.read(tripsLogicProvider).setUserName(text);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
