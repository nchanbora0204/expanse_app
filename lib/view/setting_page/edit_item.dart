import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

class EditItem extends StatelessWidget {
  final Widget widget;
  final String title;

  const EditItem({
    super.key,
    required this.widget,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        Expanded(
          flex: 2,
          child: widget,
        ),
      ],
    );
  }
}
