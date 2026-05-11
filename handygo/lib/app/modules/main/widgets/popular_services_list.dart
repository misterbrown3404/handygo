import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/main/widgets/fade_in_animation.dart';
import 'package:handygo/app/routes/app_pages.dart';

class PopularServicesList extends StatelessWidget {
  const PopularServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> popularServices = [
      {"name": "Home Cleaning", "price": "20", "image": "assets/images/favourite.jpg"},
      {"name": "AC Repairing", "price": "25", "image": "assets/images/favourite_2.jpg"},
      {"name": "Plumbing", "price": "18", "image": "assets/images/favourite_3.jpg"},
      {"name": "Car Wash", "price": "15", "image": "assets/images/home_image.jpg"},
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: popularServices.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final service = popularServices[index];
          return FadeInAnimation(
            delay: Duration(milliseconds: index * 100),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.SERVICE_DETAILS),
              child: Container(
                width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[100]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Image.asset(
                        service["image"]!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service["name"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Starting from \$${service["price"]}",
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            )
          );
        },
      ),
    );
  }
}
