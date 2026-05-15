import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/bookings/controllers/bookings_controller.dart';
import 'package:handygo/app/modules/bookings/widgets/booking_tab_list.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BookingsController>()) {
      Get.lazyPut(() => BookingsController());
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const CircularBackButton(),
          title: Text(
            "My Booking",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            tabs: const [
              Tab(text: "Ongoing"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookingTabList(bookings: controller.ongoingBookings),
            BookingTabList(bookings: controller.completedBookings),
            BookingTabList(bookings: controller.cancelledBookings),
          ],
        ),
      ),
    );
  }
}
