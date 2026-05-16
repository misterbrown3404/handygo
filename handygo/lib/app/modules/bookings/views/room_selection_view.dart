import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/bookings/controllers/booking_flow_controller.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/bookings/widgets/room_selection_item.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

class RoomSelectionView extends GetView<BookingFlowController> {
  const RoomSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Select Rooms",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Obx(
                  () => RoomSelectionItem(
                    icon: Icons.weekend_outlined,
                    title: "Rooms",
                    count: controller.selectedRooms.value,
                    onAdd: () => controller.selectedRooms.value++,
                    onRemove: () {
                      if (controller.selectedRooms.value > 1) {
                        controller.selectedRooms.value--;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.SELECT_ADDRESS),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
