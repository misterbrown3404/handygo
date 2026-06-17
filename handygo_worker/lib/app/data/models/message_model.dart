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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: '${json['sender_id'] ?? 0}',
      text: json['content'] ?? '',
      time: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now(),
      isMe: false,
    );
  }
}
