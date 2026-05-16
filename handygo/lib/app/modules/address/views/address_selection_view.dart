import 'package:flutter/material.dart';
import 'package:handygo/app/modules/bookings/controllers/booking_flow_controller.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/address/widgets/address_item.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';

class AddressSelectionView extends GetView<BookingFlowController> {
  const AddressSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Select Address",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Obx(
                      () => AddressItem(
                        icon: Icons.home_work_outlined,
                        title: "Home",
                        address:
                            "7421 Pacific Horizon Blvd, Honolulu, Hawaii 96825, USA",
                        isSelected: controller.selectedAddress.value == "Home",
                        onTap: () => controller.selectedAddress.value = "Home",
                      ),
                    ),
                    Obx(
                      () => AddressItem(
                        icon: Icons.home_outlined,
                        title: "Parents House",
                        address:
                            "123 Ocean View Lane, Honolulu, Hawaii 96825, USA",
                        isSelected:
                            controller.selectedAddress.value == "Parents House",
                        onTap: () =>
                            controller.selectedAddress.value = "Parents House",
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAddNewAddressButton(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.selectedAddress.isEmpty) {
                      Get.snackbar(
                        "Required",
                        "Please select an address",
                        backgroundColor: Colors.orangeAccent,
                      );
                      return;
                    }
                    // No payment step, submit directly
                    controller.submitBooking();
                  },
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
        ),
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return GlassContainer(
      width: double.infinity,
      height: 64,
      borderRadius: BorderRadius.circular(32),
      color: AppColors.primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: AppColors.primaryColor),
            SizedBox(width: 8),
            Text(
              "Add New Address",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
