import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncomeView extends StatelessWidget {
  final Map sub;
  final VoidCallback onPressed;

  const IncomeView({
    super.key,
    required this.sub,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Subscription Icon
            Image.asset(
              sub['icon'],
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            // Subscription Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub['Tên'],
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${sub['Giá']}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Button to trigger onPressed
            IconButton(
              icon: Icon(
                CupertinoIcons.arrow_right,
                color: colorScheme.primary,
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
