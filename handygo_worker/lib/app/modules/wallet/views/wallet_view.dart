import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:handygo_worker/app/modules/wallet/widgets/withdrawal_sheet.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';
import 'package:handygo_worker/app/data/models/transaction_model.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text('My Wallet'), centerTitle: false),
      body: Obx(
        () => controller.isLoading.value && controller.transactions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : controller.hasError.value
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Failed to load wallet data'),
                        TextButton(
                          onPressed: () {
                            controller.fetchBalance();
                            controller.fetchTransactions();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FadeInAnimation(child: _GlassBalanceCard()),
                        const SizedBox(height: AppSpacing.xl),
                        const FadeInAnimation(
                          delay: 100,
                          child: Text(
                            'Transaction History',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Obx(() => controller.transactionsLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : controller.transactionsError.value
                                ? Center(
                                    child: Column(
                                      children: [
                                        const Text('Failed to load transactions', style: TextStyle(color: Colors.grey)),
                                        TextButton(
                                          onPressed: controller.fetchTransactions,
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  )
                                : controller.transactions.isEmpty
                                    ? const Center(child: Text('No transactions yet', style: TextStyle(color: Colors.grey)))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: controller.transactions.length,
                                        itemBuilder: (context, index) => FadeInAnimation(
                                          delay: 200 + (index * 100),
                                          child: _TransactionItem(data: controller.transactions[index]),
                                        ),
                                      )),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _GlassBalanceCard extends GetView<WalletController> {
  const _GlassBalanceCard();

  String _formatBalance(double amount) {
    return '₦${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF55B436), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF55B436).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      _formatBalance(controller.balance.value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _actionButton(Icons.add_rounded, 'Top Up'),
                      const SizedBox(width: 12),
                      _actionButton(
                        Icons.north_east_rounded,
                        'Withdraw',
                        onTap: () => WithdrawalSheet.show(controller.balance.value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionModel data;
  const _TransactionItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isCredit = data.isCredit;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCredit ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.add_rounded : Icons.north_east_rounded,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.type,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  data.formattedDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            data.formattedAmount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}