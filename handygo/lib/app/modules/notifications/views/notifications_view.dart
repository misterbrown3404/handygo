import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/notifications/widgets/notification_item.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Notification",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("Today", "Mark All As Read"),
          const SizedBox(height: 16),
          const NotificationItem(
            icon: Icons.calendar_today,
            title: "Booking Updated!",
            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem",
            time: "4:00 PM",
            iconColor: AppColors.primaryColor,
          ),
          const NotificationItem(
            icon: Icons.check_circle_outline,
            title: "Booking Received!",
            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem",
            time: "3:39 PM",
            iconColor: AppColors.primaryColor,
          ),
          const NotificationItem(
            icon: Icons.star_border,
            title: "Rate Your Recent Service!",
            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem",
            time: "2:10 PM",
            iconColor: AppColors.primaryColor,
          ),
          const NotificationItem(
            icon: Icons.local_offer_outlined,
            title: "Get 70% Off on AC Serv...",
            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem",
            time: "9:00 AM",
            iconColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader("Yesterday", ""),
          const SizedBox(height: 16),
          const NotificationItem(
            icon: Icons.check_circle_outline,
            title: "Booking Received!",
            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem",
            time: "1D",
            iconColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (action.isNotEmpty)
          TextButton(
            onPressed: () {},
            child: Text(
              action,
              style: const TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
