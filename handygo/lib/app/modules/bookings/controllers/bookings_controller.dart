import 'package:get/get.dart';
import 'package:handygo/app/data/models/app_models.dart';

class BookingsController extends GetxController {
  final ongoingBookings = <BookingModel>[].obs;
  final completedBookings = <BookingModel>[].obs;
  final cancelledBookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    final cleaningService = ServiceModel(
      id: '1',
      name: 'Kitchen Cleaning',
      providerName: 'Mile Roy',
      category: 'Cleaning',
      rating: 4.8,
      reviewsCount: 120,
      price: 1900,
      image: 'assets/images/favourite.jpg',
    );

    final repairService = ServiceModel(
      id: '2',
      name: 'AC Repairing',
      providerName: 'John Mike',
      category: 'Repairing',
      rating: 4.5,
      reviewsCount: 80,
      price: 500,
      image: 'assets/images/favourite_2.jpg',
    );

    final carService = ServiceModel(
      id: '3',
      name: 'Car Repairing',
      providerName: 'Luke Thomas',
      category: 'Repairing',
      rating: 4.9,
      reviewsCount: 250,
      price: 2500,
      image: 'assets/images/favourite_3.jpg',
    );

    ongoingBookings.assignAll([
      BookingModel(id: 'b1', service: cleaningService, date: DateTime.now().add(const Duration(days: 2)), status: 'Ongoing'),
      BookingModel(id: 'b4', service: repairService, date: DateTime.now().add(const Duration(days: 5)), status: 'Ongoing'),
      BookingModel(id: 'b8', service: carService, date: DateTime.now().add(const Duration(days: 7)), status: 'Ongoing'),
      BookingModel(id: 'b9', service: cleaningService, date: DateTime.now().add(const Duration(days: 9)), status: 'Ongoing'),
    ]);

    completedBookings.assignAll([
      BookingModel(id: 'b2', service: carService, date: DateTime.now().subtract(const Duration(days: 5)), status: 'Completed'),
      BookingModel(id: 'b5', service: cleaningService, date: DateTime.now().subtract(const Duration(days: 12)), status: 'Completed'),
      BookingModel(id: 'b6', service: repairService, date: DateTime.now().subtract(const Duration(days: 20)), status: 'Completed'),
      BookingModel(id: 'b10', service: carService, date: DateTime.now().subtract(const Duration(days: 25)), status: 'Completed'),
      BookingModel(id: 'b11', service: cleaningService, date: DateTime.now().subtract(const Duration(days: 30)), status: 'Completed'),
    ]);

    cancelledBookings.assignAll([
      BookingModel(id: 'b3', service: cleaningService, date: DateTime.now().subtract(const Duration(days: 10)), status: 'Cancelled'),
      BookingModel(id: 'b7', service: carService, date: DateTime.now().subtract(const Duration(days: 15)), status: 'Cancelled'),
      BookingModel(id: 'b12', service: repairService, date: DateTime.now().subtract(const Duration(days: 18)), status: 'Cancelled'),
      BookingModel(id: 'b13', service: cleaningService, date: DateTime.now().subtract(const Duration(days: 22)), status: 'Cancelled'),
    ]);
  }
}
