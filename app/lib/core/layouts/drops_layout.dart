import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../../modules/labels/widgets/label_widget.dart';
import '../../providers/providers.dart';
import '../areas/areas.dart';
import '../editing/editing_providers.dart';
import '../elements/elements.dart';
import '../themes/themes.dart';
import '../widgets/input_list_tile.dart';
import '../widgets/layout_preview.dart';
import '../widgets/select_image_list_tile.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/settings_section.dart';
import 'layout_model.dart';
import 'widgets/fill_overscroll.dart';

@MappableClass()
class DropModel {
  final String id;
  final String? label;
  final bool isHidden;

  const DropModel({required this.id, this.label, this.isHidden = false});
}

@MappableClass(discriminatorValue: 'drops')
class DropsLayoutModel extends LayoutModel {
  const DropsLayoutModel({this.drops = const [], this.wideFocus = true, this.coverUrl}) : super();

  final List<DropModel> drops;
  final bool wideFocus;
  final String? coverUrl;

  @override
  String get name => 'Drops Layout';

  @override
  Widget builder(LayoutContext context) => DropsLayout(context, this);

  @override
  String? getAreaIdToFocus() => 'focus';

  @override
  bool hasAreaId(String id) => ['focus', ...drops.map((d) => d.id)].contains(id);

  @override
  List<Widget> settings(BuildContext context, void Function(LayoutModel) update) {
    return [
      SwitchListTile(
        title: Text(context.tr.wide_focus),
        value: wideFocus,
        onChanged: (value) => update(copyWith(wideFocus: value)),
      ),
      SelectImageListTile(
        label: context.tr.custom_cover_image,
        hasImage: coverUrl != null,
        onImageSelected: (bytes) async {
          var link =
              await context.read(groupsLogicProvider).uploadFile('layouts/${generateRandomId(4)}/cover.png', bytes);
          update(copyWith(coverUrl: link));
        },
        onDelete: () {
          update(copyWith(coverUrl: null));
        },
      ),
    ];
  }

  @override
  PreviewPage preview({Widget? header}) => PreviewPage(
        layers: [
          PreviewLayer(
            segments: [
              PreviewSection(
                child: Column(
                  children: [
                    if (header != null) header else const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: PreviewCard(width: 70, height: 40),
                    ),
                  ],
                ),
              ),
              PreviewSection(
                fill: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        const SizedBox(height: 5),
                        const PreviewCard(width: 40, height: 8),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0; i < 3; i++) ...[
                                const PreviewCard(width: 30, height: 30),
                                const SizedBox(width: 5),
                              ]
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

class DropsLayout extends StatefulWidget {
  final LayoutContext layoutContext;
  final DropsLayoutModel model;

  const DropsLayout(this.layoutContext, this.model, {Key? key}) : super(key: key);

  @override
  State<DropsLayout> createState() => _DropsLayoutState();
}

class _DropsLayoutState extends State<DropsLayout> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FillOverscroll(
      fill: Container(
        color: context.groupTheme
            .computeSurfaceTheme(context: context, preference: const ColorPreference(useHighlightColor: true))
            .surfaceColor,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ThemedSurface(
              preference: ColorPreference(useHighlightColor: widget.model.coverUrl == null),
              builder: (context, color) => Container(
                decoration: BoxDecoration(
                  image: widget.model.coverUrl != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(widget.model.coverUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Material(
                  color: color.withOpacity(widget.model.coverUrl != null ? 0.4 : 1),
                  child: Column(
                    children: [
                      if (widget.layoutContext.header != null) //
                        widget.layoutContext.header!
                      else
                        SizedBox(height: MediaQuery.of(context).padding.top + 10),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: SizedBox(
                          height: 200,
                          child: widget.model.wideFocus
                              ? SingleElementArea(
                                  id: widget.layoutContext.idFor('focus'),
                                  decorator: widget.model.coverUrl != null
                                      ? const GlassContentElementDecorator()
                                      : const ClippedContentElementDecorator(),
                                )
                              : AspectRatio(
                                  aspectRatio: 1,
                                  child: SingleElementArea(
                                    id: widget.layoutContext.idFor('focus'),
                                    decorator: widget.model.coverUrl != null
                                        ? const GlassContentElementDecorator()
                                        : const ClippedContentElementDecorator(),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          for (var drop in widget.model.drops)
            if (!drop.isHidden || context.read(isOrganizerProvider)) ...[
              SliverPadding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                sliver: SliverToBoxAdapter(
                  child: Opacity(
                    opacity: drop.isHidden ? 0.7 : 1,
                    child: Builder(builder: (context) {
                      return Row(
                        children: [
                          Expanded(
                            child: LabelWidget(
                              label: drop.label,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                          if (context.read(isOrganizerProvider)) ...[
                            const SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                drop.isHidden ? Icons.visibility_off : Icons.visibility,
                                color: context.onSurfaceHighlightColor,
                              ),
                              onPressed: () {
                                widget.layoutContext.update(widget.model.copyWith.drops //
                                    .at(widget.model.drops.indexOf(drop))
                                    .call(isHidden: !drop.isHidden));
                              },
                            ),
                            if (context.watch(isEditingProvider))
                              IconButton(
                                icon: Icon(Icons.settings, color: context.onSurfaceColor),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    useRootNavigator: false,
                                    barrierColor: Colors.black26,
                                    builder: (context) => SettingsDialog(
                                      title: Text(context.tr.settings),
                                      content: SettingsSection(
                                        margin: EdgeInsets.zero,
                                        backgroundOpacity: 0.3,
                                        children: [
                                          InputListTile(
                                            label: context.tr.label,
                                            value: drop.label,
                                            onChanged: (value) {
                                              widget.layoutContext.update(widget.model.copyWith.drops //
                                                  .at(widget.model.drops.indexOf(drop))
                                                  .call(label: value));
                                            },
                                          ),
                                          ListTile(
                                            title: Text(context.tr.delete),
                                            trailing: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                            onTap: () async {
                                              var delete = await SettingsDialog.confirm(
                                                context,
                                                text: context.tr.confirm_delete_section,
                                                confirm: context.tr.delete,
                                              );
                                              if (delete) {
                                                widget.layoutContext.update(widget.model.copyWith.drops //
                                                    .where((d) => d.id != drop.id));
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(context.tr.ok),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ],
                      );
                    }),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 10),
                sliver: SliverToBoxAdapter(
                  child: Opacity(
                    opacity: drop.isHidden ? 0.5 : 1,
                    child: HorizontalScrollArea(widget.layoutContext.idFor(drop.id)),
                  ),
                ),
              ),
            ],
          Builder(builder: (context) {
            if (context.watch(isEditingProvider)) {
              return SliverPadding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                sliver: SliverToBoxAdapter(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(context.tr.add_section),
                    onPressed: () {
                      widget.layoutContext.update(widget.model.copyWith.drops //
                          .add(DropModel(id: generateRandomId(4))));
                    },
                  ),
                ),
              );
            } else {
              return SliverToBoxAdapter(
                child: Container(),
              );
            }
          }),
          SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
        ],
      ),
    );
  }
}
