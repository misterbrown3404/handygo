import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/image_string.dart';
import 'package:handygo/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  final List<OnboardingContent> contents = [
    OnboardingContent(
      image: ImageStrings.onb1,
      title: 'Professional Home Help, Right When You Need It',
      description:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the',
    ),
    OnboardingContent(
      image: ImageStrings.onb2,
      title: 'Pick a service, choose a time, and we\'ll handle the rest',
      description:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the',
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < contents.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      skip();
    }
  }

  void skip() {
    Get.offNamed(Routes.SIGN_IN);
  }
}

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}
