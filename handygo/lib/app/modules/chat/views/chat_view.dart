import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/chat/widgets/chat_item.dart';
import 'package:handygo/app/modules/chat/widgets/messages_search_bar.dart';
import 'package:handygo/app/routes/app_pages.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Messages",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const MessagesSearchBar(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 10, bottom: 100),
              itemCount: 10,
              separatorBuilder: (context, index) => Divider(color: Colors.grey[100], height: 1),
              itemBuilder: (context, index) {
                return ChatItem(
                  name: index == 1 ? "Oliver James" : "User $index",
                  lastMessage: "Lorem Ipsum is simply dummy text...",
                  time: "10:45 AM",
                  isOnline: index % 3 == 0,
                  onTap: () => Get.toNamed(Routes.INDIVIDUAL_CHAT),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
