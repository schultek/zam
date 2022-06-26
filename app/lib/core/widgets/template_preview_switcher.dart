import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';
import 'layout_preview.dart';

class TemplatePreviewSwitcherDialog extends StatefulWidget {
  final TemplateModel currentTemplate;
  const TemplatePreviewSwitcherDialog({required this.currentTemplate, Key? key}) : super(key: key);

  static Future<TemplateModel?> show(BuildContext context, TemplateModel currentTemplate) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (ctx) => GroupTheme(
        theme: context.groupTheme.copy(),
        child: TemplatePreviewSwitcherDialog(
          currentTemplate: currentTemplate,
        ),
      ),
    );
  }

  @override
  State<TemplatePreviewSwitcherDialog> createState() => _TemplatePreviewSwitcherDialogState();
}

class _TemplatePreviewSwitcherDialogState extends State<TemplatePreviewSwitcherDialog> {
  late TemplateModel template;

  @override
  void initState() {
    super.initState();
    template = widget.currentTemplate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.choose_template),
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.surfaceColor,
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TemplateSwitcher(
          style: SwitcherStyle.dialog,
          initialTemplate: widget.currentTemplate,
          onTemplateChanged: (template) {
            setState(() {
              this.template = template;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text(context.tr.ok),
          onPressed: () {
            if (template.runtimeType == widget.currentTemplate.runtimeType) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop(template);
            }
          },
        )
      ],
    );
  }
}

enum SwitcherStyle { card, dialog }

class TemplateSwitcher extends StatefulWidget {
  const TemplateSwitcher({
    this.initialTemplate,
    required this.onTemplateChanged,
    required this.style,
    this.height = 200,
    this.showName = true,
    Key? key,
  }) : super(key: key);

  final TemplateModel? initialTemplate;
  final Function(TemplateModel template) onTemplateChanged;
  final SwitcherStyle style;
  final double height;
  final bool showName;

  @override
  State<TemplateSwitcher> createState() => _TemplateSwitcherState();
}

class _TemplateSwitcherState extends State<TemplateSwitcher> {
  late final PageController controller;
  late int page;
  late bool hasMultipleTemplates;

  @override
  void initState() {
    super.initState();
    hasMultipleTemplates = TemplateModel.all.length > 1;
    page = widget.initialTemplate != null
        ? TemplateModel.all.indexWhere((m) => m.runtimeType == widget.initialTemplate.runtimeType)
        : 0;
    controller = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: widget.height,
      child: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (page) {
              setState(() {
                this.page = page;
              });
              widget.onTemplateChanged.call(TemplateModel.all[page]);
            },
            children: [
              for (var template in TemplateModel.all)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.style == SwitcherStyle.card)
                      Container(
                        decoration: BoxDecoration(
                          color: context.onSurfaceColor.withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          hasMultipleTemplates ? context.tr.choose_template : context.tr.template,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Expanded(
                      child: PreviewBox(
                        preview: template.preview(),
                        padding: widget.style == SwitcherStyle.card ? 10 : 20,
                      ),
                    ),
                    Container(
                      decoration: widget.style == SwitcherStyle.card
                          ? BoxDecoration(
                              color: context.onSurfaceColor.withOpacity(0.3),
                            )
                          : null,
                      child: widget.showName
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                template.name,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const SizedBox(height: 10),
                    ),
                  ],
                ),
            ],
          ),
          if (hasMultipleTemplates) ...[
            Positioned(
              right: 0,
              top: 60 + (widget.style == SwitcherStyle.card ? 20 : 0),
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
              top: 60 + (widget.style == SwitcherStyle.card ? 20 : 0),
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
        ],
      ),
    );
  }
}
