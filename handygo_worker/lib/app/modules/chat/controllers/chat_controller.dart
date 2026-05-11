import 'package:get/get.dart';

class ChatController extends GetxController {
  final chats = <Map<String, String>>[
    {
      'name': 'Sarah Williams',
      'lastMsg': 'Thanks for the quick AC fix!',
      'time': '2m ago',
      'unread': '1',
      'image': 'assets/images/user1.png'
    },
    {
      'name': 'Michael Chen',
      'lastMsg': 'Are you available for plumbing tomorrow?',
      'time': '1h ago',
      'unread': '0',
      'image': 'assets/images/user2.png'
    },
  ].obs;
}
