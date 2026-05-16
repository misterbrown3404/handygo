import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:handygo/app/modules/favorites/widgets/service_grid_card.dart';
import 'package:handygo/app/modules/main/widgets/fade_in_animation.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FavoritesController>()) {
      Get.lazyPut(() => FavoritesController());
    }

    return DefaultTabController(
      length: controller.categories.length,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const CircularBackButton(),
          title: Text(
            "Favourite",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            onTap: (index) =>
                controller.selectCategory(controller.categories[index]),
            tabs: controller.categories.map((cat) => Tab(text: cat)).toList(),
          ),
        ),
        body: TabBarView(
          children: controller.categories
              .map((_) => _buildFavoritesGrid())
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    return Obx(() {
      final services = controller.filteredServices;
      if (services.isEmpty) {
        return const Center(child: Text("No favorites found"));
      }
      return GridView.builder(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 100,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return FadeInAnimation(
            delay: Duration(milliseconds: index * 100),
            child: ServiceGridCard(
              service: services[index],
              onTap: () {},
              onFavoriteToggle: () {},
            ),
          );
        },
      );
    });
  }
}
