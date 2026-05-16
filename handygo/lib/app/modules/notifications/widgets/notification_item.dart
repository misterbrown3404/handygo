import 'package:flutter/material.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';
import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final Color iconColor;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () {},
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(20),
              color: iconColor.withValues(alpha: 0.15),
              child: Center(child: Icon(icon, color: iconColor, size: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
