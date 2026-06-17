class JobRequestModel {
  final String id;
  final String customerName;
  final String serviceType;
  final String location;
  final double distance;
  final String price;
  final DateTime dateTime;
  final String status; // 'Pending', 'Accepted', 'Ongoing', 'Completed'
  final String? customerImage;

  JobRequestModel({
    required this.id,
    required this.customerName,
    required this.serviceType,
    required this.location,
    required this.distance,
    required this.price,
    required this.dateTime,
    this.status = 'Pending',
    this.customerImage,
  });

  factory JobRequestModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;
    final service = json['service'] as Map<String, dynamic>?;
    
    DateTime dt;
    try {
      dt = json['scheduled_at'] != null ? DateTime.parse(json['scheduled_at']) : DateTime.now();
    } catch (_) {
      dt = DateTime.now();
    }

    // Amount can be a string or number, format with Currency sign (₦)
    final amountVal = json['amount'] ?? service?['base_price'];

    return JobRequestModel(
      id: json['id']?.toString() ?? '',
      customerName: customer?['name']?.toString() ?? 'Customer',
      serviceType: service?['name']?.toString() ?? 'Service',
      location: json['address']?.toString() ?? '',
      distance: 0.0,
      price: amountVal != null ? '₦$amountVal' : '₦0',
      dateTime: dt,
      status: json['status']?.toString() ?? 'Pending',
      customerImage: customer?['avatar']?.toString(),
    );
  }
}
