class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? avatar;
  final String? address;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.avatar,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      avatar: json['avatar'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar': avatar,
      'address': address,
    };
  }
}
