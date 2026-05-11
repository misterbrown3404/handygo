import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/payment/widgets/payment_method_item.dart';
import 'package:handygo/app/routes/app_pages.dart';

class PaymentMethodSelectionView extends StatelessWidget {
  const PaymentMethodSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Select Payment Methods",
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
                _buildSectionHeader("Cash"),
                PaymentMethodItem(
                  icon: Icons.payments_outlined,
                  title: "Cash",
                  isSelected: true,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildSectionHeader("More Payment Options"),
                PaymentMethodItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Paypal",
                  isSelected: false,
                  onTap: () {},
                ),
                PaymentMethodItem(
                  icon: Icons.payment,
                  title: "Google Pay",
                  isSelected: false,
                  onTap: () {},
                ),
                PaymentMethodItem(
                  icon: Icons.apple,
                  title: "Apple Pay",
                  isSelected: false,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildAddNewCardButton(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.REVIEW_SUMMARY),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildAddNewCardButton() {
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
              "Add New Card",
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
