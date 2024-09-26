import 'package:flutter/material.dart';

import 'forward_button.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final String? value;
  final bool showDropdown; // Add this flag to show dropdown or not

  const SettingItem({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
    required this.icon,
    this.value,
    this.showDropdown = false, // Default is false
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
          value != null
              ? Text(
            value!,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          )
              : const SizedBox(),
          const SizedBox(width: 10),
          ForwardButton(
            onTap: () {
              if (showDropdown) {
                onTap(); // Trigger dropdown display
              }
            },
          ),
        ],
      ),
    );
  }
}
