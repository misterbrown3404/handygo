import 'package:flutter/material.dart';
import 'package:handygo/app/data/models/service_model.dart';

class ServiceTitleSection extends StatelessWidget {
  final ServiceModel service;
  const ServiceTitleSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.name ?? "Unknown Service",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    service.category ?? "General",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(
                    " ${service.rating ?? 4.5} (${service.reviewsCount ?? 0} Reviews)",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildFavoriteToggle(service.isFavorite),
      ],
    );
  }

  Widget _buildFavoriteToggle(bool isFav) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
        size: 24,
      ),
    );
  }
}
