import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/modules/wallet/controllers/wallet_controller.dart';

class WithdrawalSheet extends StatefulWidget {
  const WithdrawalSheet({super.key});

  static void show(double balance) {
    Get.bottomSheet(
      const WithdrawalSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<WithdrawalSheet> createState() => _WithdrawalSheetState();
}

class _WithdrawalSheetState extends State<WithdrawalSheet> {
  final amountController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Withdraw Funds',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
              'Available Balance: ₦${controller.balance.value.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey),
            )),
          const SizedBox(height: AppSpacing.xl),

          const Text(
            'Enter Amount',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: 'N ',
              hintText: '0.00',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Bank Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: bankNameController,
            decoration: InputDecoration(
              hintText: 'GTBank',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          const Text(
            'Account Number',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: accountNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0123456789',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          const Text(
            'Account Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: accountNameController,
            decoration: InputDecoration(
              hintText: 'John Doe',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          Obx(
            () => PrimaryButton(
              text: 'Withdraw Now',
              isLoading: controller.isLoading.value,
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null || amount < 1000) {
                  Get.snackbar('Invalid Amount', 'Minimum withdrawal is ₦1,000');
                  return;
                }
                if (amount > controller.balance.value) {
                  Get.snackbar('Insufficient Balance', 'You do not have enough funds');
                  return;
                }
                controller.withdraw(
                  bankName: bankNameController.text,
                  accountNumber: accountNumberController.text,
                  accountName: accountNameController.text,
                  amount: amount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}