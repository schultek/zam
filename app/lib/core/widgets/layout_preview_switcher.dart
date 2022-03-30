import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../layouts/layouts.dart';
import '../themes/themes.dart';
import 'layout_preview.dart';

class LayoutPreviewSwitcher extends StatefulWidget {
  final LayoutModel currentLayout;
  final Widget? header;

  const LayoutPreviewSwitcher({required this.currentLayout, this.header, Key? key}) : super(key: key);

  static Future<LayoutModel?> show(BuildContext context, LayoutModel currentTemplate, [Widget? header]) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (ctx) => TripTheme(
        theme: context.tripTheme.copy(),
        child: LayoutPreviewSwitcher(
          currentLayout: currentTemplate,
          header: header,
        ),
      ),
    );
  }

  @override
  State<LayoutPreviewSwitcher> createState() => _LayoutPreviewSwitcherState();
}

class _LayoutPreviewSwitcherState extends State<LayoutPreviewSwitcher> {
  late final PageController controller;
  late int page;

  @override
  void initState() {
    super.initState();
    page = LayoutModel.all.indexWhere((m) => m.runtimeType == widget.currentLayout.runtimeType);
    controller = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.choose_layout),
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.surfaceColor,
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              PageView(
                controller: controller,
                onPageChanged: (page) {
                  setState(() {
                    this.page = page;
                  });
                },
                children: [
                  for (var layout in LayoutModel.all)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: PreviewBox(preview: layout.preview(header: widget.header), padding: 20)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            layout.name,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Positioned(
                right: 0,
                top: 60,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: page < LayoutModel.all.length - 1
                      ? () {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
              Positioned(
                left: 0,
                top: 60,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: page > 0
                      ? () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(context.tr.ok),
          onPressed: () {
            var newLayout = LayoutModel.all[controller.page!.round()];
            if (newLayout.runtimeType == widget.currentLayout.runtimeType) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop(newLayout);
            }
          },
        )
      ],
    );
  }
}
