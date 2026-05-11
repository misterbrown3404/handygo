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
}
