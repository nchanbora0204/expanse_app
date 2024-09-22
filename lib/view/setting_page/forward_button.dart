import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../common/color_extension.dart';

class ForwardButton extends StatelessWidget {
  final Function() onTap;
  const ForwardButton({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = Theme.of(context).iconTheme.size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          Ionicons.chevron_forward_outline,
          color: TColor.gray30,
          size: iconSize,
        ),
      ),
    );
  }
}