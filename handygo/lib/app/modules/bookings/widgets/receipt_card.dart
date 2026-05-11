import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barcode dummy
          Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://static.vecteezy.com/system/resources/previews/001/199/360/original/barcode-png.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          const SizedBox(height: 32),
          _buildReceiptRow("Service Name", "Home Cleaning"),
          _buildReceiptRow("Service Provider", "Robert Kelvin"),
          _buildReceiptRow("Booking Date", "18/04/2025"),
          _buildReceiptRow("Booking Time", "09:00-12:00"),
          _buildReceiptRow("Total Room", "07"),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          const SizedBox(height: 16),
          _buildReceiptRow("Amount", "\$4,800"),
          _buildReceiptRow("Tax & Fee", "\$1.25"),
          _buildReceiptRow("Total Amount", "\$4,801.25", isBold: true),
          _buildReceiptRow("Payment Method", "Cash", isGreen: true),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
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
