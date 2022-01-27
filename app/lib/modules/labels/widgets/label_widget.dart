import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../core/widgets/widget_selector.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';

class LabelWidget extends StatefulWidget {
  final String? label;
  final IdProvider idProvider;
  final EdgeInsets padding;
  const LabelWidget({this.label, this.padding = const EdgeInsets.all(8), required this.idProvider, Key? key})
      : super(key: key);

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  bool isEditing = false;
  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() => isEditing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isEditing) {
      child = TextFormField(
        autofocus: true,
        focusNode: focusNode,
        initialValue: widget.label,
        decoration: InputDecoration(
          hintText: context.tr.add_label,
          border: const OutlineInputBorder(),
          filled: true,
        ),
        onFieldSubmitted: (text) {
          if (text.isNotEmpty) {
            widget.idProvider.provide(context, base64.encode(utf8.encode(text)));
            setState(() => isEditing = false);
          }
        },
      );
    } else {
      child = Padding(
        padding: widget.padding,
        child: Text(
          widget.label ?? context.tr.add_label,
          style: context.theme.textTheme.headline6!.apply(color: context.onSurfaceColor),
        ),
      );

      if (context.read(isOrganizerProvider)) {
        child = GestureDetector(
          onTap: () {
            setState(() => isEditing = true);
            focusNode.requestFocus();
          },
          child: child,
        );
      }
    }

    if (WidgetSelector.existsIn(context)) {
      child = IntrinsicWidth(child: child);
    }
    return child;
  }
}
