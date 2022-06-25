import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/groups/selected_group_provider.dart';
import '../../core.dart';
import '../../reorderable/drag_item.dart';

class NeedsSetupCard extends StatefulWidget {
  final Widget child;
  final String? setupHint;

  const NeedsSetupCard({
    this.setupHint,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<NeedsSetupCard> createState() => _NeedsSetupCardState();
}

class _NeedsSetupCardState extends State<NeedsSetupCard> {
  @override
  Widget build(BuildContext context) {
    var elemState = InheritedDragState.of(context);
    var showHint = widget.setupHint != null && elemState == ElementDragState.placed;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Opacity(
              opacity: 1,
              child: widget.child,
            ),
            AnimatedPositioned(
              top: 4,
              left: 4,
              width: showHint ? constraints.maxWidth - 8 : 34,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutQuint,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (context.read(isOrganizerProvider)) {
                    ModuleElement.openSettings(context);
                  }
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        color: showHint ? context.theme.colorScheme.error.withOpacity(0.2) : Colors.transparent,
                        border: Border.all(
                          color: showHint ? context.theme.colorScheme.error.withOpacity(0.4) : Colors.transparent,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(14)),
                      ),
                      padding: const EdgeInsets.all(4),
                      duration: const Duration(milliseconds: 800),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Color.alphaBlend(
                              context.onSurfaceHighlightColor.withOpacity(0.4),
                              context.surfaceColor,
                            ),
                            size: 26,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(
                              Icons.priority_high,
                              color: context.theme.colorScheme.error,
                              size: 20,
                            ),
                          ),
                          if (widget.setupHint != null)
                            Positioned(
                              left: 30,
                              width: constraints.maxWidth - 30 - 8 - 8,
                              top: -10,
                              bottom: -10,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Einrichtung nötig. ${widget.setupHint!}',
                                  style: context.theme.textTheme.caption!
                                      .copyWith(color: context.onSurfaceColor.withOpacity(0.8)),
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
