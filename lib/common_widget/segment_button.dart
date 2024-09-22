import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SegmentButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isAcitive;

  const SegmentButton(
      {super.key,
      required this.title,
      required this.isAcitive,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color activeTextColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final Color inactiveTextColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final Color borderColor = theme.dividerColor;
    final Color backgroundColor = theme.scaffoldBackgroundColor.withOpacity(0.2);
    
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: isAcitive
            ? BoxDecoration(
                border: Border.all(
                  color: borderColor.withOpacity(0.15),
                ),
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              )
            : null,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isAcitive ? activeTextColor : inactiveTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
