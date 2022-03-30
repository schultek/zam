import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';
import 'layout_preview.dart';

class TemplatePreviewSwitcher extends StatefulWidget {
  final TemplateModel currentTemplate;
  const TemplatePreviewSwitcher({required this.currentTemplate, Key? key}) : super(key: key);

  static Future<TemplateModel?> show(BuildContext context, TemplateModel currentTemplate) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (ctx) => GroupTheme(
        theme: context.groupTheme.copy(),
        child: TemplatePreviewSwitcher(
          currentTemplate: currentTemplate,
        ),
      ),
    );
  }

  @override
  State<TemplatePreviewSwitcher> createState() => _TemplatePreviewSwitcherState();
}

class _TemplatePreviewSwitcherState extends State<TemplatePreviewSwitcher> {
  late final PageController controller;
  late int page;

  @override
  void initState() {
    super.initState();
    page = TemplateModel.all.indexWhere((m) => m.runtimeType == widget.currentTemplate.runtimeType);
    controller = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.choose_template),
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
                  for (var template in TemplateModel.all)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: PreviewBox(preview: template.preview(), padding: 20)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            template.name,
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
                  onPressed: page < TemplateModel.all.length - 1
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
            var newTemplate = TemplateModel.all[controller.page!.round()];
            if (newTemplate.runtimeType == widget.currentTemplate.runtimeType) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop(newTemplate);
            }
          },
        )
      ],
    );
  }
}
