import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class StatusButton extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;
  final VoidCallback onPressed;

  const StatusButton({
    super.key,
    required this.title,
    required this.value,
    required this.statusColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 68, // Ensure button height is fixed
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : Colors.black.withOpacity(0.15),
                ),
                color: isDarkMode
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: 8,
                width: 68, // Set width to match the button width
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

