import 'package:intl/intl.dart';

class TransactionModel {
  final int id;
  final String? jobId;
  final String type;
  final double amount;
  final String status;
  final DateTime? date;

  TransactionModel({
    required this.id,
    required this.jobId,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      jobId: json['job_id'] != null ? json['job_id'].toString() : null,
      type: json['type'] ?? 'Job Payment',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'completed',
      date: json['date'] != null ? DateTime.parse(json['date'].toString()) : null,
    );
  }

  String get formattedAmount {
    final format = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    return '${amount >= 0 ? '+' : ''} ${format.format(amount)}';
  }

  String get formattedDate {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date!);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${date!.day}/${date!.month}/${date!.year}';
  }

  bool get isCredit => amount > 0;
}