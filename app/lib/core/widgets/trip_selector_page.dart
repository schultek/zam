import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/auth/claims_provider.dart';
import '../../providers/auth/logic_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../../providers/trips/trips_provider.dart';
import '../../screens/create_trip/create_trip_screen.dart';
import '../../screens/signin/phone_signin_screen.dart';
import '../../widgets/ju_background.dart';
import '../models/trip.dart';
import '../themes/theme_context.dart';
import '../themes/widgets/themed_surface.dart';
import 'trip_settings_page.dart';

class TripSelectorPage extends StatelessWidget {
  const TripSelectorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trips = context.watch(tripsProvider).value ?? <Trip>[];
    var selectedTrip = context.watch(selectedTripProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (selectedTrip != null) ...[
            Text('Ausgewählter Trip', style: TextStyle(color: context.onSurfaceColor)),
            const SizedBox(height: 20),
            tripTile(context, selectedTrip, true),
            const SizedBox(height: 20),
          ],
          if (trips.where((t) => t.id != selectedTrip?.id).isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Verfügbare Trips', style: TextStyle(color: context.onSurfaceColor)),
            const SizedBox(height: 20),
            for (var trip in trips.where((t) => t.id != selectedTrip?.id)) ...[
              tripTile(context, trip, false),
              const SizedBox(height: 20),
            ],
          ],
          if (context.watch(claimsProvider).isOrganizer) ...createTripSection(context),
          const SizedBox(height: 40),
          ...accountSection(context),
          const SizedBox(height: 20),
          ...aboutSection(context),
        ],
      ),
    );
  }

  List<Widget> createTripSection(BuildContext context) {
    return [
      const Divider(),
      const SizedBox(height: 20),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ThemedSurface(
          builder: (context, color) => JuBackground(
            child: Container(
              decoration: BoxDecoration(
                color: context.surfaceColor.withOpacity(0.2),
              ),
              height: 80,
              child: Material(
                color: context.surfaceColor.withOpacity(0.3),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 10),
                      Text(
                        'Create new Trip',
                        style: context.theme.textTheme.headline5!.copyWith(color: context.onSurfaceColor),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) => const CreateTripScreen()));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> aboutSection(BuildContext context) {
    return [
      const SizedBox(height: 20),
      Text(
        'Made with ❤️ & 🍫 in Munich',
        textAlign: TextAlign.center,
        style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
      ),
      Text(
        'Copyright @ 2022 Kilian Schulte',
        textAlign: TextAlign.center,
        style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
      ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> accountSection(BuildContext context) {
    var user = context.read(userProvider).value!;

    var logoutButton = TextButton(
      child: const Text('Log out'),
      onPressed: () {
        context.read(authLogicProvider).signOut();
      },
    );

    if (user.providerData.any((p) => p.providerId == PhoneAuthProvider.PROVIDER_ID)) {
      return [
        Center(child: Text('Logged in with ${user.phoneNumber}')),
        Center(child: logoutButton),
      ];
    } else {
      return [
        Text(
          'Logged in as a guest.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 10),
        Text(
          'You can add your phone number\nto access your trips on another device.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.onSurfaceColor.withOpacity(0.8)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoutButton,
            TextButton(
              child: const Text('Add Phone Number'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(PhoneSignInScreen.route());
              },
            ),
          ],
        ),
      ];
    }
  }

  Widget tripTile(BuildContext context, Trip trip, bool isSelected) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ThemedSurface(
        builder: (context, color) => Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            image: trip.pictureUrl != null
                ? DecorationImage(image: CachedNetworkImageProvider(trip.pictureUrl!), fit: BoxFit.cover)
                : null,
          ),
          height: isSelected ? 200 : 140,
          child: Material(
            color: context.surfaceColor.withOpacity(0.3),
            child: InkWell(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      trip.name,
                      style: context.theme.textTheme.headline4!.copyWith(color: context.onSurfaceColor),
                    ),
                  ),
                  if (isSelected && context.watch(isOrganizerProvider))
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.settings, color: context.onSurfaceColor),
                        onPressed: () {
                          Navigator.push(context, TripSettingsPage.route());
                        },
                      ),
                    ),
                ],
              ),
              onTap: () {
                if (isSelected) {
                  Navigator.pop(context);
                } else {
                  context.read(selectedTripIdProvider.notifier).state = trip.id;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
