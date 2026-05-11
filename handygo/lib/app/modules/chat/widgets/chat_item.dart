import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/core/constant/image_string.dart';

class ChatItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final VoidCallback onTap;

  const ChatItem({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Stack(
        children: [
           CircleAvatar(
            radius: 28,
           backgroundColor: Colors.white,
            backgroundImage: AssetImage(ImageStrings.profilePic),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 14,
                width: 14,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: onTap,
    );
  }
}
