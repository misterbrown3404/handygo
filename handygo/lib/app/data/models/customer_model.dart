class CustomerModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final double? lat;
  final double? lng;
  final String? avatar;

  CustomerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.lat,
    this.lng,
    this.avatar,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.tryParse(json['lng'].toString()) : null,
      avatar: json['avatar'],
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
    };
  }
}
