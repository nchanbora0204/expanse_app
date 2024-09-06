import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import 'forward_button.dart';

class SettingSwitch extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final bool value;

  final Function(bool value) onTap;

  const SettingSwitch({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          Text(
            value ? "Tối" : "Sáng",
            style: textTheme.headlineMedium?.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          CupertinoSwitch(value: value, onChanged: onTap)
        ],
      ),
    );
    ;
  }
}
