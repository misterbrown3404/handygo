import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/data/models/app_models.dart';

class ServiceGridCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const ServiceGridCard({
    super.key,
    required this.service,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildImageSection(),
            ),
            _buildDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              service.image ?? 'assets/images/favourite_3.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                service.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    "${service.rating}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            service.providerName,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: "${service.price.toStringAsFixed(0)}",
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: const [
                TextSpan(
                  text: "/hour",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
