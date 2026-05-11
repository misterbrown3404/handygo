import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CircularBackButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: onTap ?? () => Get.back(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
