import 'package:flutter/material.dart';
import 'package:handygo/app/data/models/service_model.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';

class ServiceImageHeader extends StatelessWidget {
  final ServiceModel service;
  const ServiceImageHeader({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: double.infinity,
          child: service.icon != null && service.icon!.startsWith('http')
              ? Image.network(
                  service.icon!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/favourite.jpg',
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  service.icon ?? 'assets/images/favourite.jpg',
                  fit: BoxFit.cover,
                ),
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
