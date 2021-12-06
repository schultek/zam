import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../../../providers/trips/trips_provider.dart';
import '../../../screens/create_trip/create_trip_screen.dart';
import '../../models/trip.dart';
import '../../themes/theme_context.dart';
import '../../themes/widgets/themed_surface.dart';
import '../../widgets/trip_settings.dart';

class TripSelectorButton extends StatelessWidget {
  const TripSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: InkResponse(
        child: Icon(Icons.menu_open, color: context.onSurfaceColor),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TripSelectorPage()));
        },
        onLongPress: context.read(isOrganizerProvider) ? () => Navigator.push(context, TripSettings.route()) : null,
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
            tripTile(context, selectedTrip, true),
            const SizedBox(height: 40),
          ],
          Text('Verfügbare Trips', style: TextStyle(color: context.onSurfaceColor)),
          const SizedBox(height: 20),
          for (var trip in trips.where((t) => t.id != selectedTrip?.id)) ...[
            tripTile(context, trip, false),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
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
                          Navigator.push(context, TripSettings.route());
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
