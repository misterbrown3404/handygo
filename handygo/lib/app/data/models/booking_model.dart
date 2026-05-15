import 'service_model.dart';
import 'worker_model.dart';
import 'customer_model.dart';

class BookingModel {
  final int? id;
  final CustomerModel? customer;
  final WorkerModel? worker;
  final ServiceModel? service;
  final DateTime? scheduledAt;
  final String? status;
  final String? notes;
  final String? address;
  final double? amount;
  final double? rating;
  final String? review;
  final DateTime? createdAt;

  BookingModel({
    this.id,
    this.customer,
    this.worker,
    this.service,
    this.scheduledAt,
    this.status,
    this.notes,
    this.address,
    this.amount,
    this.rating,
    this.review,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      customer: json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null,
      worker: json['worker'] != null ? WorkerModel.fromJson(json['worker']) : null,
      service: json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
      scheduledAt: json['scheduled_at'] != null ? DateTime.tryParse(json['scheduled_at']) : null,
      status: json['status'],
      notes: json['notes'],
      address: json['address'],
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      review: json['review'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer?.toJson(),
      'worker': worker?.toJson(),
      'service': service?.toJson(),
      'scheduled_at': scheduledAt?.toIso8601String(),
      'status': status,
      'notes': notes,
      'address': address,
      'amount': amount,
      'rating': rating,
      'review': review,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
