class WorkerModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final double? lat;
  final double? lng;
  final String? avatar;
  final String? specialty;
  final String? status;
  final bool? isAvailable;
  final double? rating;
  final int? totalJobs;

  WorkerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.lat,
    this.lng,
    this.avatar,
    this.specialty,
    this.status,
    this.isAvailable,
    this.rating,
    this.totalJobs,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.tryParse(json['lng'].toString()) : null,
      avatar: json['avatar'],
      specialty: json['specialty'],
      status: json['status'],
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      totalJobs: json['total_jobs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'lat': lat,
      'lng': lng,
      'avatar': avatar,
      'specialty': specialty,
      'status': status,
      'is_available': isAvailable,
      'rating': rating,
      'total_jobs': totalJobs,
    };
  }
}
