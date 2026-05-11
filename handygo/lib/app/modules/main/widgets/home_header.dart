import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/image_string.dart';
import 'package:handygo/app/routes/app_pages.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          backgroundImage: const AssetImage(ImageStrings.profilePic),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, Jonathan",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              "London, UK",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Badge(
              child: Icon(Icons.notifications_outlined),
            ),
          ),
        ),
      ],
    );
  }
}
