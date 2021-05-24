import 'package:flutter/material.dart';

import '../../core/module/module.dart';
import '../../models/models.dart';

@Module()
class ProfileModule {
  ModuleData moduleData;
  ProfileModule(this.moduleData);

  @ModuleItem(id: "profile")
  ContentSegment getProfileCard() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: const Center(child: Text("Profil")),
      ),
      onNavigate: (context) => ProfilePage(moduleData.trip.currentUser!),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final TripUser user;
  const ProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (text) {
                  user.nickname = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
