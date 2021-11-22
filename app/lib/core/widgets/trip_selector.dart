import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/trips/selected_trip_provider.dart';
import '../../providers/trips/trips_provider.dart';
import '../../screens/create_trip/create_trip_screen.dart';
import '../core.dart';

class TripSelectorButton extends StatelessWidget {
  final Route Function()? settingsRoute;
  const TripSelectorButton({Key? key, this.settingsRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TripSelectorPage(
                    settingsRoute: settingsRoute,
                  )));
        },
      ),
    );
  }
}

class TripSelectorPage extends StatelessWidget {
  final Route Function()? settingsRoute;
  const TripSelectorPage({Key? key, this.settingsRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trips = context.watch(tripsProvider).value ?? <Trip>[];
    var selectedTrip = context.watch(selectedTripProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
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
            const Text('Ausgewählter Trip', style: TextStyle(color: Colors.white38)),
            const SizedBox(height: 20),
            selectedTripTile(context, selectedTrip),
            const SizedBox(height: 40),
          ],
          const Text('Verfügbare Trips', style: TextStyle(color: Colors.white38)),
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
          color: Colors.grey.shade900,
          image: trip.pictureUrl != null
              ? DecorationImage(image: CachedNetworkImageProvider(trip.pictureUrl!), fit: BoxFit.cover)
              : null,
        ),
        height: 200,
        child: Material(
          color: Colors.black38,
          child: InkWell(
            child: Stack(
              children: [
                Center(
                  child: Text(
                    trip.name,
                    style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                  ),
                ),
                if (context.watch(isOrganizerProvider) && settingsRoute != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(context, settingsRoute!());
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
          color: Colors.grey.shade900,
          image: trip.pictureUrl != null
              ? DecorationImage(image: CachedNetworkImageProvider(trip.pictureUrl!), fit: BoxFit.cover)
              : null,
        ),
        height: 100,
        child: Material(
          color: Colors.black38,
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
