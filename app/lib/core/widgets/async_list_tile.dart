import 'package:flutter/material.dart';

class AsyncListTile extends StatefulWidget {
  const AsyncListTile({
    required this.title,
    this.subtitle,
    this.leading,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Future<void> Function() onTap;

  @override
  State<AsyncListTile> createState() => _AsyncListTileState();
}

class _AsyncListTileState extends State<AsyncListTile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      trailing: isLoading
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : null,
      onTap: isLoading
          ? null
          : () async {
              setState(() => isLoading = true);
              try {
                await widget.onTap();
              } finally {
                setState(() => isLoading = false);
              }
            },
    );
  }
}
