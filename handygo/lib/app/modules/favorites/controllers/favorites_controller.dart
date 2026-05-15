import 'package:get/get.dart';
import 'package:handygo/app/data/repositories/favorite_repository.dart';
import 'package:handygo/app/data/models/service_model.dart';


class FavoritesController extends GetxController {
  final _favoriteRepo = FavoriteRepository();
  
  final favoriteServices = <ServiceModel>[].obs;
  final categories = <String>["All"].obs;
  final selectedCategory = "All".obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      isLoading(true);
      final data = await _favoriteRepo.getFavorites();
      favoriteServices.assignAll(data);
      _updateCategories();
    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateCategories() {
    final Set<String> cats = {"All"};
    for (var service in favoriteServices) {
      if (service.category != null) {
        cats.add(service.category!);
      }
    }
    categories.assignAll(cats.toList());
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  List<ServiceModel> get filteredServices {
    if (selectedCategory.value == "All") return favoriteServices;
    return favoriteServices.where((s) => s.category == selectedCategory.value).toList();
  }

  Future<void> toggleFavorite(ServiceModel service) async {
    try {
      if (service.id == null) return;
      await _favoriteRepo.toggleFavorite(service.id!);
      fetchFavorites(); // Refresh list
    } catch (e) {
      Get.snackbar("Error", "Could not update favorites");
    }
  }
}
