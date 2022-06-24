import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../core/core.dart';
import '../core/reorderable/drag_item.dart';
import '../providers/groups/selected_group_provider.dart';

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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (context.read(isOrganizerProvider)) {
          ModuleElement.openSettings(context);
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Opacity(
              opacity: 0.4,
              child: widget.child,
            ),
            AnimatedPositioned(
              top: 6,
              left: 6,
              width: showHint ? constraints.maxWidth - 12 : 34,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutQuint,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: showHint ? context.theme.colorScheme.error.withOpacity(0.1) : Colors.transparent,
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
                            context.onSurfaceHighlightColor.withOpacity(0.2),
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
                            width: constraints.maxWidth - 30 - 12 - 8,
                            child: Text(
                              widget.setupHint!,
                              style: context.theme.textTheme.caption!
                                  .copyWith(color: context.onSurfaceColor.withOpacity(0.8)),
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
