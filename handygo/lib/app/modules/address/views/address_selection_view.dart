import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/address/widgets/address_item.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/routes/app_pages.dart';

class AddressSelectionView extends StatelessWidget {
  const AddressSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Select Address",
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
                AddressItem(
                  icon: Icons.home_work_outlined,
                  title: "Home",
                  address: "7421 Pacific Horizon Blvd, Honolulu, Hawaii 96825, USA",
                  isSelected: true,
                  onTap: () {},
                ),
                AddressItem(
                  icon: Icons.home_outlined,
                  title: "Parents House",
                  address: "7421 Pacific Horizon Blvd, Honolulu, Hawaii 96825, USA",
                  isSelected: false,
                  onTap: () {},
                ),
                AddressItem(
                  icon: Icons.garage_outlined,
                  title: "Farm House",
                  address: "7421 Pacific Horizon Blvd, Honolulu, Hawaii 96825, USA",
                  isSelected: false,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildAddNewAddressButton(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.SELECT_PAYMENT_METHOD),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
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
