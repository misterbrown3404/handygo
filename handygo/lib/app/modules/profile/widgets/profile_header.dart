import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/core/constant/image_string.dart';

import 'package:handygo/app/core/widgets/glass_container.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GlassContainer(
              padding: const EdgeInsets.all(4),
              borderRadius: BorderRadius.circular(54),
              color: Colors.white.withValues(alpha: 0.3),
              border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    imageUrl != null && imageUrl!.startsWith('http')
                    ? NetworkImage(imageUrl!) as ImageProvider
                    : const AssetImage(ImageStrings.profilePic),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(email, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
