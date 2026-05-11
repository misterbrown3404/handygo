import 'package:flutter/material.dart';
import 'package:handygo/app/data/models/app_models.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';

class ServiceImageHeader extends StatelessWidget {
  final ServiceModel service;
  const ServiceImageHeader({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(service.image ?? 'assets/images/favourite.jpg'),
              fit: BoxFit.cover,
            ),
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
