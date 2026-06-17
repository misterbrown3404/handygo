import 'package:flutter/material.dart';
import 'package:handygo/app/data/models/service_model.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';

class ServiceImageHeader extends StatelessWidget {
  final ServiceModel service;
  const ServiceImageHeader({super.key, required this.service});

  static bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final trimmed = url.trim().toLowerCase();
    return trimmed.startsWith('http://') ||
        trimmed.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: double.infinity,
          child: _isValidImageUrl(service.icon)
              ? Image.network(
                  service.icon!.trim(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const _ServicePlaceholder(),
                )
              : const _ServicePlaceholder(),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          child: const CircularBackButton(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicePlaceholder extends StatelessWidget {
  const _ServicePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF55B436),
            Color(0xFF2E7D32),
          ],
        ),
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white70,
        size: 64,
      ),
    );
  }
}
