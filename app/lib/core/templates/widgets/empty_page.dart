import 'package:flutter/material.dart';

import '../../themes/themes.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.visibility_off,
        size: 180,
        color: context.onSurfaceColor.withOpacity(0.02),
      ),
    );
  }
}
