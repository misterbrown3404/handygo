import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/routes/app_pages.dart';

class ReviewSummaryView extends StatelessWidget {
  const ReviewSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Review Summary",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildServiceCard(context),
            const SizedBox(height: 32),
            _buildSummaryDetails(context),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Pay Now",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/home_image.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Home Cleaning",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text("4.5", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text("Robert Kelvin", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                const SizedBox(height: 8),
                const Text(
                  "\$1,600 / hour",
                  style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          _buildDetailRow("Service Name", "Home Cleaning"),
          _buildDetailRow("Service Provider", "Robert Kelvin"),
          _buildDetailRow("Booking Date", "Wed, 18 Apr, 2025"),
          _buildDetailRow("Booking Time", "09:00-12:00"),
          _buildDetailRow("Total Room", "07"),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 16),
          _buildDetailRow("Amount", "\$4,800"),
          _buildDetailRow("Tax & Fee", "\$1.25"),
          _buildDetailRow("Total Amount", "\$4,801.25", isBold: true),
          InkWell(
            onTap: () => Get.toNamed(Routes.ADD_CARD),
            child: _buildDetailRow("Payment Method", "Cash", isGreen: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: label == "Payment Method" ? 0 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
              color: isGreen ? AppColors.primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
