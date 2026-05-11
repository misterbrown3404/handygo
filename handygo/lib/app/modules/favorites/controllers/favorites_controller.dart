import 'package:get/get.dart';
import 'package:handygo/app/data/models/app_models.dart';

class FavoritesController extends GetxController {
  final favoriteServices = <ServiceModel>[].obs;
  final categories = ["All", "Cleaning", "Repairing", "Plumbing"].obs;
  final selectedCategory = "All".obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    favoriteServices.assignAll([
      ServiceModel(
        id: '1',
        name: 'Home Cleaning',
        providerName: 'Robert Kelvin',
        category: 'Cleaning',
        rating: 4.5,
        reviewsCount: 530,
        price: 1600,
        isFavorite: true,
        image: 'assets/images/favourite.jpg',
      ),
      ServiceModel(
        id: '2',
        name: 'AC Repair',
        providerName: 'John Mike',
        category: 'Repairing',
        rating: 4.5,
        reviewsCount: 300,
        price: 500,
        isFavorite: true,
        image: 'assets/images/favourite_2.jpg',
      ),
      ServiceModel(
        id: '3',
        name: 'Kitchen Cleaning',
        providerName: 'Mile Roy',
        category: 'Cleaning',
        rating: 4.2,
        reviewsCount: 200,
        price: 1900,
        isFavorite: true,
        image: 'assets/images/favourite_3.jpg',
      ),
      ServiceModel(
        id: '4',
        name: 'Home Cleaning',
        providerName: 'Luke Hay',
        category: 'Cleaning',
        rating: 3.2,
        reviewsCount: 150,
        price: 1400,
        isFavorite: true,
        image: 'assets/images/home_image.jpg',
      ),
      ServiceModel(
        id: '5',
        name: 'Car Repairing',
        providerName: 'Luke Thomas',
        category: 'Repairing',
        rating: 4.9,
        reviewsCount: 250,
        price: 2500,
        isFavorite: true,
        image: 'assets/images/favourite_3.jpg',
      ),
      ServiceModel(
        id: '6',
        name: 'Plumbing Service',
        providerName: 'David Wilson',
        category: 'Plumbing',
        rating: 4.7,
        reviewsCount: 180,
        price: 1200,
        isFavorite: true,
        image: 'assets/images/favourite.jpg',
      ),
      ServiceModel(
        id: '7',
        name: 'House Painting',
        providerName: 'Alex Brown',
        category: 'Repairing',
        rating: 4.6,
        reviewsCount: 95,
        price: 3000,
        isFavorite: true,
        image: 'assets/images/favourite_2.jpg',
      ),
      ServiceModel(
        id: '8',
        name: 'Laundry Service',
        providerName: 'Sarah Jenkins',
        category: 'Cleaning',
        rating: 4.8,
        reviewsCount: 420,
        price: 800,
        isFavorite: true,
        image: 'assets/images/favourite_3.jpg',
      ),
      ServiceModel(
        id: '9',
        name: 'Electrician',
        providerName: 'Mark Spencer',
        category: 'Repairing',
        rating: 4.9,
        reviewsCount: 110,
        price: 700,
        isFavorite: true,
        image: 'assets/images/home_image.jpg',
      ),
      ServiceModel(
        id: '10',
        name: 'Garden Care',
        providerName: 'Emma Watson',
        category: 'Cleaning',
        rating: 4.4,
        reviewsCount: 65,
        price: 1500,
        isFavorite: true,
        image: 'assets/images/favourite_2.jpg',
      ),
    ]);
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  List<ServiceModel> get filteredServices {
    if (selectedCategory.value == "All") return favoriteServices;
    return favoriteServices.where((s) => s.category == selectedCategory.value).toList();
  }
}
