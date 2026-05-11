import 'package:flutter/material.dart';
import 'package:handygo/app/data/models/app_models.dart';

class ServiceStatsSection extends StatelessWidget {
  final ServiceModel service;
  const ServiceStatsSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(service.happyCustomers, "Happy Customer")),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(service.clientSatisfaction, "Client Satisfaction")),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
