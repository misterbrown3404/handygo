import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/data/models/app_models.dart';
import 'package:handygo/app/routes/app_pages.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onCancel;
  final VoidCallback? onRebook;
  final VoidCallback? onReview;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
    this.onRebook,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[100],
                  child: Image.asset(
                    booking.service.image ?? 'assets/images/home_image.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.service.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.service.providerName,
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEE, dd MMM, yyyy').format(booking.date),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Date",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  text: "\$${booking.service.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: "/hour",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 20),
          _buildActionButtons(context),
          
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (booking.status == 'Ongoing') {
      return Row(
        children: [
          Expanded(
            child: _buildButton(
              label: "Cancel",
              onPressed: onCancel,
              isOutlined: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildButton(
              label: "E-Receipt",
              onPressed: () => Get.toNamed(Routes.E_RECEIPT),
              isOutlined: false,
            ),
          ),
        ],
      );
    } else if (booking.status == 'Completed') {
      return Row(
        children: [
          Expanded(
            child: _buildButton(
              label: "Leave Review",
              onPressed: onReview,
              isOutlined: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildButton(
              label: "Re-Book",
              onPressed: onRebook,
              isOutlined: false,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildButton(
              label: "Delete",
              onPressed: onReview,
              isOutlined: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildButton(
              label: "Re-Book",
              onPressed: onRebook,
              isOutlined: false,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildButton({
    required String label,
    VoidCallback? onPressed,
    required bool isOutlined,
  }) {
    return SizedBox(
      height: 48,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                side: BorderSide(color: AppColors.primaryColor.withOpacity(0.1)),
                backgroundColor: AppColors.primaryColor.withOpacity(0.05),
                elevation: 0,
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
    );
  }
}
