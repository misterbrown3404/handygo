import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/core/constant/image_string.dart';

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
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.1), width: 2),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(imageUrl ?? ImageStrings.profilePic),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
