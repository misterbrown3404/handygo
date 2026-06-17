import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo_worker/app/data/repositories/wallet_repository.dart';
import 'package:handygo_worker/app/data/models/transaction_model.dart';
import 'package:flutter/material.dart';

class WalletController extends GetxController {
  final WalletRepository _repository = WalletRepository();
  final GetStorage _storage = Get.find<GetStorage>();

  var balance = 0.0.obs;
  var totalWithdrawn = 0.0.obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var transactionsLoading = false.obs;
  var transactionsError = false.obs;

  final transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final token = _storage.read('token');
    if (token == null) return;
    fetchBalance();
    fetchTransactions();
  }

  Future<void> fetchBalance() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      balance.value = await _repository.getBalance();
    } catch (e) {
      debugPrint('Error fetching wallet balance: $e');
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Failed to load wallet balance: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactions() async {
    try {
      transactionsLoading.value = true;
      transactionsError.value = false;
      final data = await _repository.getTransactions();
      transactions.assignAll(data);
      totalWithdrawn.value = data
          .where((t) => t.type.toLowerCase().contains('withdrawal'))
          .fold(0.0, (sum, t) => sum + t.amount.abs());
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      transactionsError.value = true;
      Get.snackbar(
        'Error',
        'Failed to load transactions: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      transactionsLoading.value = false;
    }
  }

  Future<void> withdraw({
    required String bankName,
    required String accountNumber,
    required String accountName,
    required double amount,
  }) async {
    try {
      isLoading.value = true;
      await _repository.withdraw(
        bankName: bankName,
        accountNumber: accountNumber,
        accountName: accountName,
        amount: amount,
      );
      Get.snackbar(
        'Withdrawal Initiated',
        'Your withdrawal request has been submitted.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchBalance();
    } catch (e) {
      debugPrint('Error during withdrawal: $e');
      Get.snackbar(
        'Withdrawal Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}