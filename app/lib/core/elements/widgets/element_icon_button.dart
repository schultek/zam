import 'package:flutter/material.dart';

class ElementIconButton extends StatelessWidget {
  const ElementIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Feedback.forTap(context);
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color,
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              icon,
              size: 15,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
