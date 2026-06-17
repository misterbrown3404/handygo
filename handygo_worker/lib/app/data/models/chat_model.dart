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

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: '${json['id'] ?? json['sender_id'] ?? json['receiver_id'] ?? 0}',
      senderName: json['name'] ?? 'User',
      lastMessage: json['last_message'] ?? json['content'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
      profileImage: json['profile_image'] ?? json['avatar'],
    );
  }
}
