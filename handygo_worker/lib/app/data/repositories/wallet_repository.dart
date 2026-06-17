import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../core/constant/api_constants.dart';
import '../providers/api_client.dart';
import '../models/transaction_model.dart';

class WalletRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<double> getBalance() async {
    final dio.Response response = await _apiClient.get(ApiConstants.walletBalance);
    final Map<String, dynamic> data = response.data;
    if (data['success'] == true) {
      final balance = data['data']?['balance'];
      return double.tryParse(balance?.toString() ?? '') ?? 0.0;
    }
    throw Exception(data['message'] ?? 'Failed to fetch balance');
  }

  Future<List<TransactionModel>> getTransactions() async {
    final dio.Response response = await _apiClient.get(ApiConstants.walletTransactions);
    final Map<String, dynamic> data = response.data;
    if (data['success'] == true) {
      final List list = data['data'] ?? [];
      return list.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> withdraw({
    required String bankName,
    required String accountNumber,
    required String accountName,
    required double amount,
  }) async {
    await _apiClient.post(
      ApiConstants.walletWithdraw,
      data: {
        'bank_name': bankName,
        'account_number': accountNumber,
        'account_name': accountName,
        'amount': amount,
      },
    );
  }
}