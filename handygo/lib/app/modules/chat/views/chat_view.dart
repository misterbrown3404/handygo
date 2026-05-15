import 'package:handygo/app/modules/chat/controllers/chat_controller.dart';
import 'package:handygo/app/modules/chat/widgets/chat_item.dart';
import 'package:handygo/app/modules/chat/widgets/messages_search_bar.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.threads.isEmpty) {
                return const Center(child: Text("No messages yet"));
              }

              return ListView.separated(
                padding: const EdgeInsets.only(top: 10, bottom: 100),
                itemCount: controller.threads.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey[100], height: 1),
                itemBuilder: (context, index) {
                  final thread = controller.threads[index];
                  return ChatItem(
                    thread: thread,
                    onTap: () => Get.toNamed(Routes.INDIVIDUAL_CHAT, arguments: thread),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
