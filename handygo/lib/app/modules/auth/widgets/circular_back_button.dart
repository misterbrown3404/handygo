import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:handygo/app/core/widgets/glass_container.dart';
import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class CircularBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CircularBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
      child: ScaleOnTap(
        onTap: onTap ?? () => Get.back(),
        child: GlassContainer(
          width: 40,
          height: 40,
          borderRadius: BorderRadius.circular(20),
          child: const Center(child: Icon(Icons.arrow_back, size: 20)),
        ),
      ),
    );
  }
}
