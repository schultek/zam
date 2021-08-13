import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/module/module.dart';
import '../../providers/trips/logic_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'image_selector.dart';

@Module()
class ProfileModule {
  @ModuleItem(id: "profile")
  ContentSegment getProfileCard() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                color: context.getTextColor(),
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                "Profil",
                style: Theme.of(context).textTheme.headline6!.copyWith(color: context.getTextColor()),
              ),
            ],
          ),
        ),
      ),
      onNavigate: (context) => const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage();

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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Consumer(
            builder: (context, watch, _) {
              var user = watch(tripUserProvider);
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          var pngBytes = await ImageSelector.fromGallery(context);
                          if (pngBytes != null) {
                            context.read(tripsLogicProvider).uploadProfileImage(pngBytes);
                          }
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 5,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              user?.profileUrl != null ? CachedNetworkImageProvider(user!.profileUrl!) : null,
                          child: user?.profileUrl == null
                              ? Center(
                                  child: Text(
                                    "KS",
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: user?.nickname,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    style: TextStyle(color: context.getTextColor()),
                    onFieldSubmitted: (text) {
                      context.read(tripsLogicProvider).setUserName(text);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
