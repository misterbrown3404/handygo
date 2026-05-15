class ServiceModel {
  final int? id;
  final String? name;
  final String? category;
  final String? description;
  final String? icon;
  final double? basePrice;
  final bool? isActive;
  final double? rating;
  final int? reviewsCount;
  final bool isFavorite;

  ServiceModel({
    this.id,
    this.name,
    this.category,
    this.description,
    this.icon,
    this.basePrice,
    this.isActive,
    this.rating,
    this.reviewsCount,
    this.isFavorite = false,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      icon: json['icon'],
      basePrice: json['base_price'] != null
          ? double.tryParse(json['base_price'].toString())
          : null,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : 4.5, // Default for now
      reviewsCount: json['reviews_count'] ?? 0,
      isFavorite: json['is_favorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'icon': icon,
      'base_price': basePrice,
      'is_active': isActive,
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_favorite': isFavorite,
    };
  }
}
