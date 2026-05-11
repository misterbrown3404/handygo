import 'package:flutter/material.dart';
import 'package:handygo/app/modules/main/widgets/categories_list.dart';
import 'package:handygo/app/modules/main/widgets/home_header.dart';
import 'package:handygo/app/modules/main/widgets/home_search_bar.dart';
import 'package:handygo/app/modules/main/widgets/popular_services_list.dart';
import 'package:handygo/app/modules/main/widgets/section_header.dart';
import 'package:handygo/app/modules/main/widgets/special_offer_banner.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          const SizedBox(height: 25),
          const HomeSearchBar(),
          const SizedBox(height: 25),
          const SpecialOfferBanner(),
          const SizedBox(height: 25),
          SectionHeader(title: "Categories", onViewAll: () {}),
          const SizedBox(height: 15),
          const CategoriesList(),
          const SizedBox(height: 25),
          SectionHeader(title: "Popular Services", onViewAll: () {}),
          const SizedBox(height: 15),
          const PopularServicesList(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
