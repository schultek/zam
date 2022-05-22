import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';

class InputListTile extends StatefulWidget {
  const InputListTile({
    required this.label,
    required this.value,
    required this.onChanged,
    this.trailing,
    this.keyboardType,
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final bool autofocus;

  @override
  State<InputListTile> createState() => _InputListTileState();
}

class _InputListTileState extends State<InputListTile> {
  bool hasFocus = false;
  late String? value = widget.value;
  late final FocusNode focusNode;

  late String? savedValue;

  @override
  void initState() {
    super.initState();
    hasFocus = widget.autofocus;
    focusNode = FocusNode()
      ..addListener(() {
        if (!focusNode.hasPrimaryFocus) {
          save(value);
        }
      });
  }

  void save(String? value) {
    if (!hasFocus) return;
    if (value != null) {
      widget.onChanged(value);
    }
    setState(() {
      hasFocus = false;
    });
  }

  @override
  void didUpdateWidget(covariant InputListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    value = widget.value ?? value;
  }

  @override
  Widget build(BuildContext context) {
    if (hasFocus) {
      return ListTile(
        title: TextFormField(
          autofocus: widget.autofocus,
          focusNode: focusNode,
          initialValue: widget.value,
          decoration: InputDecoration(
            labelText: widget.label,
            border: InputBorder.none,
            filled: false,
          ),
          onFieldSubmitted: save,
          onChanged: (value) {
            this.value = value;
          },
          keyboardType: widget.keyboardType,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            save(value);
          },
        ),
      );
    } else {
      return ListTile(
        title: Text(widget.label),
        subtitle: value != null ? Text(value!) : Text(context.tr.tap_to_change),
        trailing: widget.trailing,
        onTap: () {
          setState(() => hasFocus = true);
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            focusNode.requestFocus();
          });
        },
      );
    }
  }
}
