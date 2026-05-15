import 'package:flutter/material.dart';

import 'package:handygo/app/core/widgets/glass_container.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        leading: GlassContainer(
          width: 36,
          height: 36,
          borderRadius: BorderRadius.circular(18),
          color: iconColor.withOpacity(0.15),
          child: Center(child: Icon(icon, color: iconColor, size: 20)),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
