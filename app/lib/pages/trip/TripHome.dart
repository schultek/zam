import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/AppState.dart';
import '../../general/module/Module.dart';
import '../../models/Trip.dart';
import 'AddModuleCardDialog.dart';
import 'ReorderToggle.dart';

class TripHome extends StatefulWidget {
  final Trip trip;

  TripHome(this.trip);

  @override
  _TripHomeState createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> with TickerProviderStateMixin, GridProvider {
  bool isOrganizer = false;
  bool isReordering = false;

  AnimationController reorderController;
  AnimationController wiggleController;

  List<List<ModuleCard>> grid = [];

  List<ModuleCard> allModuleCards;
  List<ModuleCard> selectedModuleCards;

  @override
  void initState() {
    super.initState();

    reorderController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    wiggleController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    isOrganizer =
        Provider.of<AppState>(context, listen: false).claims.isAdmin || widget.trip.currentUser()?.role == UserRoles.Organizer;

    ModuleData moduleData = ModuleData(trip: widget.trip);

    this.allModuleCards = ModuleRegistry.getModuleCards(moduleData);
    this.selectedModuleCards = allModuleCards.where((card) => moduleData.trip.modules.contains(card.id)).toList()
      ..sort((a, b) => moduleData.trip.modules.indexOf(a.id) - moduleData.trip.modules.indexOf(b.id));

    List<ModuleCard> row;
    for (ModuleCard card in selectedModuleCards) {
      if (card.size == CardSize.Square) {
        if (row == null) {
          row = List()..add(card);
          grid.add(row);
        } else {
          row.add(card);
          row = null;
        }
      } else {
        grid.add(List()..add(card));
      }
    }
  }

  @override
  void dispose() {
    reorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableList(
      grid: this,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 50),
                    Text(widget.trip.name, style: Theme.of(context).textTheme.headline5),
                    SizedBox(
                        width: 50,
                        child: isOrganizer
                            ? ReorderToggle(
                                controller: reorderController,
                                onStartToggle: (isReordering) {
                                  if (isReordering) {
                                    wiggleController.repeat();
                                  }
                                },
                                onCompletedToggle: (isReordering) {
                                  if (!isReordering) {
                                    wiggleController.stop();
                                  }
                                  setState(() {
                                    this.isReordering = isReordering;
                                    if (!isReordering) {
                                      updateIndices();
                                    }
                                  });
                                })
                            : null),
                  ],
                ),
              ),
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              ...grid
                  .map(
                    (row) => Padding(
                      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                      child: row[0].size == CardSize.Wide
                          ? ModuleGridItem(card: row[0], reorderAnimation: reorderController, wiggleAnimation: wiggleController, onRemove: removeCard)
                          : Row(children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: ModuleGridItem(
                                      card: row[0], reorderAnimation: reorderController, wiggleAnimation: wiggleController, onRemove: removeCard)),
                              Container(width: 20),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: row.length == 2
                                    ? ModuleGridItem(
                                        card: row[1], reorderAnimation: reorderController, wiggleAnimation: wiggleController, onRemove: removeCard)
                                    : Container(),
                              )
                            ]),
                    ),
                  )
                  .toList(),
              ...(isOrganizer && !isReordering && selectedModuleCards.length < allModuleCards.length ? _addModuleCard(context) : []),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> updateIndices() async {
    List<String> sortedIds = [];
    for (var row in grid) {
      for (var item in row) {
        sortedIds.add(item.id);
      }
    }

    await FirebaseFirestore.instance.collection("trips").doc(widget.trip.id).update({
      "modules": sortedIds,
    });
  }

  List<Widget> _addModuleCard(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(bottom: 20, top: 0, left: 100, right: 100),
        child: Container(height: 1, color: Colors.black12),
      ),
      Padding(
        padding: EdgeInsets.only(left: 80, right: 80, bottom: 20),
        child: Center(child: FlatButton(
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 80,
            child: Icon(Icons.add),
          ),
          onPressed: () async {
            var card = await AddModuleCardDialog.open(
                context, allModuleCards.where((card) => !selectedModuleCards.contains(card)).toList());
            if (card != null) {
              addCard(card);
            }
          },
        ),
        ),
      ),
    ];
  }

  GridIndex indexOf(Key key) {
    var rowIndex = grid.indexWhere((List<ModuleCard> row) => row.any((card) => card.key == key));
    var columnIndex = grid[rowIndex].indexWhere((card) => card.key == key);
    return GridIndex(rowIndex, columnIndex, grid[rowIndex][columnIndex].size);
  }

  void onReorder(Key draggedItem, Key newPosition) {
    GridIndex curIndex = indexOf(draggedItem);
    GridIndex newIndex = indexOf(newPosition);

    setState(() {
      if (curIndex.row == newIndex.row) {
        grid[curIndex.row] = grid[curIndex.row].reversed.toList();
      } else if (curIndex.size == CardSize.Square && newIndex.size == CardSize.Square) {
        var draggedCard = grid[curIndex.row][curIndex.column];
        grid[curIndex.row][curIndex.column] = grid[newIndex.row][newIndex.column];
        grid[newIndex.row][newIndex.column] = draggedCard;
      } else {
        var draggedRow = grid.removeAt(curIndex.row);
        grid.insert(newIndex.row, draggedRow);
      }
    });
  }

  Widget decorateItem(Widget widget, double opacity) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -2,
          color: Colors.black.withOpacity(opacity * 0.5),
        )
      ]),
      child: widget,
    );
  }

  @override
  List<List<ModuleCard>> getGrid() {
    return this.grid;
  }

  void addCard(ModuleCard card) {
    setState(() {
      selectedModuleCards.add(card);
      if (grid.isNotEmpty && grid.last.length == 1 && grid.last[0].size == CardSize.Square) {
        if (card.size == CardSize.Square) {
          grid.last.add(card);
        } else {
          grid.insert(grid.length-1, [card]);
        }
      } else {
        grid.add([card]);
      }
      this.updateIndices();
    });
  }

  void removeCard(BuildContext context, ModuleCard card) {
    setState(() {
      selectedModuleCards.remove(card);
      ReorderableList.of(context).removeItem(card.key);

      var index = indexOf(card.key);
      grid[index.row].remove(card);
      if (grid[index.row].length == 0) {
        grid.removeAt(index.row);
      }

      this.updateIndices();
    });
  }
}

class ModuleGridItem extends StatelessWidget {
  final ModuleCard card;
  final Animation<double> reorderAnimation;
  final Animation<double> wiggleAnimation;
  final void Function(BuildContext context, ModuleCard card) onRemove;

  ModuleGridItem({this.card, this.reorderAnimation, this.wiggleAnimation, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: card.key,
        childBuilder: (context, state) {
          if (state == ReorderableItemState.placeholder) {
            return AspectRatio(
              aspectRatio: card.size == CardSize.Square ? 1 / 1 : 2 / 1,
              child: Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.grey[300].withOpacity(.2),
                child: Container(),
              ),
            );
          } else {
            var animation = state == ReorderableItemState.normal ? CurvedAnimation(
                parent: PhasedAnimation(
                    phase: wiggleAnimation,
                    intensity: reorderAnimation,
                    shift: Random().nextDouble()
                ),
                curve: Curves.easeInOut
            ) : AlwaysStoppedAnimation(0.0);
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (animation.value - 0.5) * 0.015,
                  child: child,
                );
              },
              child: AnimatedGridItem(
                child: GridItem(
                  animation: reorderAnimation,
                  card: card
                ),
                reorderAnimation: reorderAnimation,
                icon: Material(
                  color: Colors.red, // button color
                  child: InkWell(
                    splashColor: Colors.redAccent, // inkwell color
                    child: SizedBox(width: 24, height: 24, child: Icon(Icons.close, size: 15, color: Colors.white)),
                    onTap: () {
                      onRemove(context, card);
                    },
                  ),
                ),
              ),
            );
          }
        });
  }
}

class GridItem extends StatefulWidget {

  final Animation<double> animation;
  final ModuleCard card;

  GridItem({this.card, this.animation});

  @override
  _GridItemState createState() => _GridItemState();

}

class _GridItemState extends State<GridItem> {

  bool isReordering = false;

  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener(onAnimationStatus);
    onAnimationStatus(widget.animation.status);
  }

  @override
  void dispose() {
    super.dispose();
    widget.animation.removeStatusListener(onAnimationStatus);
  }

  onAnimationStatus(status) {
    if (status == AnimationStatus.completed) {
      if (!isReordering) {
        setState(() {
          isReordering = true;
        });
      }
    } else {
      if (isReordering) {
        setState(() {
          isReordering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isReordering) {
      return DelayedReorderableListener(
        delay: Duration(milliseconds: 100),
        child: AbsorbPointer(child: widget.card),
      );
    } else {
      return widget.card;
    }
  }
}


class AnimatedGridItem extends AnimatedWidget {
  final Widget child;
  final Widget icon;

  AnimatedGridItem({this.child, this.icon, reorderAnimation}) : super(listenable: reorderAnimation);

  Animation<double> get _reordering => listenable;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      Positioned(
        top: 0,
        right: 0,
        child: ClipOval(
          clipper: ScalingClipper(_reordering.value, const Offset(12, 12)),
          child: icon,
        ),
      ),
    ]);
  }
}

class PhasedAnimation extends CompoundAnimation<double> {

  double shift;

  PhasedAnimation({phase, intensity, this.shift = 0.0}) : super(first: phase, next: intensity);

  @override
  double get value {
    var phase = this.first.value + shift;
    phase = phase > 1 ? phase - 1 : phase;
    phase *= 2;
    phase = phase > 1 ? 2 - phase : phase;
    return phase * this.next.value;
  }
}

class ScalingClipper extends CustomClipper<Rect> {
  double value;
  Offset center;

  ScalingClipper(this.value, this.center);

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
      center: center,
      width: size.width * this.value,
      height: size.height * this.value,
    );
  }

  @override
  bool shouldReclip(ScalingClipper oldClipper) => oldClipper.value != value;
}
