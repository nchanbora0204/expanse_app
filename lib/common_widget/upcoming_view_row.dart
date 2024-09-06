import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class UpcomingBillRow extends StatelessWidget {
  final Map sub;
  final VoidCallback onPressed;

  const UpcomingBillRow({
    super.key,
    required this.sub,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(15),
            color: theme.cardColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Jun",
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "25",
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sub["Tên"] ?? '',
                  overflow: TextOverflow.ellipsis, // Handle overflow text
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "\$${sub["Tổng"] ?? '0'}",
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
