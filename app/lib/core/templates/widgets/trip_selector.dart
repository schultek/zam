import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../../../providers/trips/trips_provider.dart';
import '../../../screens/create_trip/create_trip_screen.dart';
import '../../models/trip.dart';
import '../../themes/widgets/trip_theme.dart';
import '../../widgets/trip_settings.dart';

class TripSelectorButton extends StatelessWidget {
  const TripSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TripSelectorPage()));
        },
      ),
    );
  }
}

class TripSelectorPage extends StatelessWidget {
  const TripSelectorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trips = context.watch(tripsProvider).value ?? <Trip>[];
    var selectedTrip = context.watch(selectedTripProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        actions: [
          if (context.watch(isOrganizerProvider))
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateTripScreen()));
              },
            )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (selectedTrip != null) ...[
            Text('Ausgewählter Trip', style: TextStyle(color: context.onSurfaceColor)),
            const SizedBox(height: 20),
            selectedTripTile(context, selectedTrip),
            const SizedBox(height: 40),
          ],
          Text('Verfügbare Trips', style: TextStyle(color: context.onSurfaceColor)),
          const SizedBox(height: 20),
          for (var trip in trips.where((t) => t.id != selectedTrip?.id)) ...[
            tripTile(context, trip),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget selectedTripTile(BuildContext context, Trip trip) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          image: trip.pictureUrl != null
              ? DecorationImage(image: CachedNetworkImageProvider(trip.pictureUrl!), fit: BoxFit.cover)
              : null,
        ),
        height: 200,
        child: Material(
          color: context.theme.colorScheme.primary.withOpacity(0.4),
          child: InkWell(
            child: Stack(
              children: [
                Center(
                  child: Text(
                    trip.name,
                    style: Theme.of(context).textTheme.headline4!.copyWith(color: context.theme.colorScheme.onPrimary),
                  ),
                ),
                if (context.watch(isOrganizerProvider))
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.settings, color: context.theme.colorScheme.onPrimary),
                      onPressed: () {
                        Navigator.push(context, TripSettings.route());
                      },
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget tripTile(BuildContext context, Trip trip) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          image: trip.pictureUrl != null
              ? DecorationImage(image: CachedNetworkImageProvider(trip.pictureUrl!), fit: BoxFit.cover)
              : null,
        ),
        height: 100,
        child: Material(
          color: context.theme.colorScheme.primary.withOpacity(0.4),
          child: InkWell(
            child: Center(
                child: Text(
              trip.name,
              style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
            )),
            onTap: () {
              context.read(selectedTripIdProvider.notifier).state = trip.id;
            },
          ),
        ),
      ),
    );
  }
}
