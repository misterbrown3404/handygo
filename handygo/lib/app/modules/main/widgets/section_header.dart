import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            "View All",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
