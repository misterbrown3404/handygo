class ServiceModel {
  final String id;
  final String name;
  final String providerName;
  final String category;
  final double rating;
  final int reviewsCount;
  final double price;
  final String? image;
  final bool isFavorite;
  final String description;
  final String happyCustomers;
  final String clientSatisfaction;

  ServiceModel({
    required this.id,
    required this.name,
    required this.providerName,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    this.image,
    this.isFavorite = false,
    this.description = '',
    this.happyCustomers = '',
    this.clientSatisfaction = '',
  });
}

class BookingModel {
  final String id;
  final ServiceModel service;
  final DateTime date;
  final String status; // 'Ongoing', 'Completed', 'Cancelled'

  BookingModel({
    required this.id,
    required this.service,
    required this.date,
    required this.status,
  });
}
