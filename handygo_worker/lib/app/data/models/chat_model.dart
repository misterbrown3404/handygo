class ChatModel {
  final String id;
  final String senderName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? profileImage;

  ChatModel({
    required this.id,
    required this.senderName,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.profileImage,
  });
}

class MessageModel {
  final String senderId;
  final String text;
  final DateTime time;
  final bool isMe;

  MessageModel({
    required this.senderId,
    required this.text,
    required this.time,
    required this.isMe,
  });
}
