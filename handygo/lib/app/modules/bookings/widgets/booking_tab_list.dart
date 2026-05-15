import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/data/models/booking_model.dart';
import 'package:handygo/app/modules/bookings/widgets/booking_card.dart';
import 'package:handygo/app/modules/main/widgets/fade_in_animation.dart';

class BookingTabList extends StatelessWidget {            
  final RxList<BookingModel> bookings;
  const BookingTabList({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bookings.isEmpty) {
        return const Center(child: Text("No bookings found"));
      }
      return ListView.separated(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
        itemCount: bookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return FadeInAnimation(
            delay: Duration(milliseconds: index * 100),
            child: BookingCard(
              booking: bookings[index],
              onCancel: () {},
              onRebook: () {},
              onReview: () {},
            ),
          );
        },
      );
    });
  }
}
