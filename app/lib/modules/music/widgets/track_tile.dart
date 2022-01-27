import 'package:flutter/material.dart';

import '../../../helpers/extensions.dart';
import '../music_models.dart';

enum TrackAction { play, queue, addPlaylist, deletePlaylist }

const defaultActions = {TrackAction.play, TrackAction.queue};

extension ActionUi on TrackAction {
  IconData get icon {
    switch (this) {
      case TrackAction.play:
        return Icons.play_arrow;
      case TrackAction.queue:
        return Icons.playlist_add;
      case TrackAction.addPlaylist:
        return Icons.add;
      case TrackAction.deletePlaylist:
        return Icons.delete;
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case TrackAction.play:
        return context.tr.play;
      case TrackAction.queue:
        return context.tr.add_to_queue;
      case TrackAction.addPlaylist:
        return context.tr.add_to_playlist;
      case TrackAction.deletePlaylist:
        return context.tr.remove_from_playlist;
    }
  }
}

class TrackTile extends StatelessWidget {
  final SpotifyTrack track;
  final VoidCallback? onTap;
  final Function(TrackAction)? onAction;
  final Set<TrackAction> actions;
  const TrackTile({
    required this.track,
    this.onTap,
    this.onAction,
    this.actions = defaultActions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(track.album.images.last.url),
      ),
      title: Text(track.name),
      subtitle: Text(
        track.artists.map((a) => a.name).join(', '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onAction != null
          ? PopupMenuButton<TrackAction>(
              icon: const Icon(Icons.more_horiz),
              onSelected: onAction,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<TrackAction>>[
                for (var action in actions)
                  PopupMenuItem<TrackAction>(
                    value: action,
                    child: Row(
                      children: [
                        Icon(action.icon, size: 20),
                        const SizedBox(width: 10),
                        Text(action.label(context)),
                      ],
                    ),
                  ),
              ],
            )
          : null,
      onTap: onTap,
    );
  }
}
