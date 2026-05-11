import 'package:get/get.dart';
import 'package:handygo/app/data/models/app_models.dart';

class ServiceDetailController extends GetxController {
  final service = Rxn<ServiceModel>();
  final rating = 5.obs;
  final tipAmount = 50.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    service.value = ServiceModel(
      id: '1',
      name: 'Home Cleaning',
      providerName: 'Robert Kelvin',
      category: 'Cleaning',
      rating: 4.5,
      reviewsCount: 532,
      price: 1600,
      isFavorite: true,
      description: 'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took.',
      happyCustomers: '200K+',
      clientSatisfaction: '99%',
    );
  }

  void setRating(int value) {
    rating.value = value;
  }
}
