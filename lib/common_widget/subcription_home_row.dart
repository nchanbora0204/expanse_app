import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class SubScriptionHomeRow extends StatelessWidget {
  final Map sub;
  final VoidCallback onPressed;

  const SubScriptionHomeRow({
    super.key,
    required this.sub,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
              color: TColor.border.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              Image.asset(
                sub["icon"],
                width: 44,
                height: 44,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sub["Tên"],
                  style: TextStyle(
                    color: TColor.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "\$${sub["Giá"]}",  // Changed from "Tổng" to "Giá"
                style: TextStyle(
                  color: TColor.white,
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
