import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseView extends StatelessWidget {
  final Map sub;
  final VoidCallback onPressed;

  const ExpenseView({
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
            // Icon cho chi tiêu (có thể là một biểu tượng cụ thể hoặc một hình ảnh)
            Icon(
              CupertinoIcons.money_dollar,
              size: 40,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            // Thông tin chi tiết chi tiêu
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
                    'Ngày: ${sub['date'].toLocal()}'.split(' ')[0], // Hiển thị ngày
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tổng: \$${sub['Tổng']}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Nút để thực hiện một hành động (như xem chi tiết)
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
