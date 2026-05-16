import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _currentRangeValues = const RangeValues(120, 500);
  String selectedCategory = 'Cleaning';
  double selectedRating = 5.0;
  String selectedLocation = "Any Location";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSectionTitle("Location"),
          const SizedBox(height: 12),
          _buildLocationDropdown(),
          const SizedBox(height: 24),
          _buildSectionTitle("Category"),
          const SizedBox(height: 12),
          _buildCategoryList(),
          const SizedBox(height: 24),
          _buildSectionTitle("Price Range"),
          const SizedBox(height: 12),
          _buildPriceRangeSlider(),
          const SizedBox(height: 24),
          _buildSectionTitle("Available Date"),
          const SizedBox(height: 12),
          _buildDatePicker(),
          const SizedBox(height: 24),
          _buildSectionTitle("Ratings"),
          const SizedBox(height: 12),
          _buildRatingList(),
          const SizedBox(height: 32),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          "Filter",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48), // Spacer to balance back button
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLocation,
          isExpanded: true,
          items: ["Any Location", "London, UK", "New York, USA", "Paris, France", "Lagos, Nigeria", "Abuja, Nigeria"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => selectedLocation = val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem("Cleaning", Icons.cleaning_services_outlined, true),
        _buildCategoryItem("Repairing", Icons.build_outlined, false),
        _buildCategoryItem("Painting", Icons.format_paint_outlined, false),
      ],
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, bool isSelected) {
    return Container(
      width: (Get.width - 72) / 3,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.grey[100]!,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? AppColors.primaryColor : Colors.grey, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        // Dummy histogram placeholder
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              20,
              (index) => Container(
                width: 4,
                height: 10 + (index % 5) * 6.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 1000,
          divisions: 100,
          activeColor: AppColors.primaryColor,
          inactiveColor: Colors.grey[200],
          labels: RangeLabels(
            "\$${_currentRangeValues.start.round()}",
            "\$${_currentRangeValues.end.round()}",
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPriceBox("Minimum Price", "\$${_currentRangeValues.start.round()}.00"),
            _buildPriceBox("Maximum Price", "\$${_currentRangeValues.end.round()}.00"),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Wed, 18 Apr, 2025", style: TextStyle(fontWeight: FontWeight.w500)),
          Icon(Icons.calendar_month_outlined, color: Colors.grey[400], size: 20),
        ],
      ),
    );
  }

  Widget _buildRatingList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRatingItem(5.0, true),
          _buildRatingItem(4.0, false),
          _buildRatingItem(3.0, false),
          _buildRatingItem(2.0, false),
        ],
      ),
    );
  }

  Widget _buildRatingItem(double rating, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: isSelected ? Colors.white : Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            rating.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (rating < 5)
            Text(
              "-4.9",
              style: TextStyle(
                color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                selectedLocation = "Any Location";
              });
              Get.find<MainController>().fetchWorkers();
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              side: BorderSide(color: Colors.grey[100]!),
            ),
            child: const Text("Reset", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final loc = selectedLocation == "Any Location" ? null : selectedLocation.split(",").first;
              Get.find<MainController>().fetchWorkers(location: loc);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
