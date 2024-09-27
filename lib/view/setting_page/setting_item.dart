import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:money_lover/common/color_extension.dart';

import 'forward_button.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final String? value;
  final bool showDropdown;

  const SettingItem({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
    required this.icon,
    this.value,
    this.showDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
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
          const SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const Spacer(),
          if (value != null)
            Text(
              value!,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
          const SizedBox(width: 10),
          if (showDropdown)
            IconButton(
              icon: Icon(Ionicons.chevron_forward_outline, color: TColor.gray30),
              onPressed: onTap, // Để mở dropdown
            ),
          if (!showDropdown)
            IconButton(
              icon: Icon(Ionicons.chevron_forward_outline, color: TColor.gray30),
              onPressed: onTap, // Để chuyển trang
            ),
        ],
      ),
    );
  }
}

