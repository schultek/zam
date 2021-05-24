import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../core/module/module.dart';
import '../../helpers/locator.dart';
import '../../models/models.dart';
import '../../service/dynamic_link_service.dart';

@Module()
class UsersModule {
  ModuleData moduleData;
  UsersModule(this.moduleData);

  @ModuleItem(id: "users")
  ContentSegment getUsers() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: const Center(child: Text("Users")),
      ),
      onNavigate: (context) => UsersPage(moduleData.trip),
    );
  }
}

class UsersPage extends StatelessWidget {
  final Trip trip;
  const UsersPage(this.trip);

  IconData? getIconForUser(String role) {
    if (role == "organizer") {
      return Icons.account_box;
    } else if (role == "leader") {
      return Icons.account_circle;
    } else if (role == "participant") {
      return Icons.account_circle_outlined;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(trip.name, style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String link = await locator<DynamicLinkService>().createParticipantLink(trip.id);
                  Share.share("Um dich bei der Freizeit anzumelden, klicke auf den Link: $link");
                },
                child: const Text("Einladungslink für Teilnehmer erstellen"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String link = await locator<DynamicLinkService>().createLeaderLink(trip.id);
                  Share.share("Um dich als Leiter bei der Freizeit anzumelden, klicke auf den Link: $link");
                },
                child: const Text("Einladungslink für Leiter erstellen"),
              ),
              const SizedBox(height: 20),
              const Text("Teilnehmerliste"),
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: ListView(
                    children: trip.users.entries
                        .map<Widget>(
                          (e) => ListTile(
                            leading: Icon(getIconForUser(e.value.role)),
                            title: Text(e.key),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
