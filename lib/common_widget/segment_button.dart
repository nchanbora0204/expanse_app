import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

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
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: isAcitive
            ? BoxDecoration(
                border: Border.all(
                  color: TColor.border.withOpacity(0.15),
                ),
                color: TColor.gray60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              )
            : null,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isAcitive ? TColor.white : TColor.gray30,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
