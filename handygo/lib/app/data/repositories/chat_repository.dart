import '../providers/api_client.dart';
import 'package:get/get.dart';

class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'] == 1 || json['is_read'] == true,
    );
  }
}

class ChatThreadModel {
  final int userId;
  final String userName;
  final String? userAvatar;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  ChatThreadModel({
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      userId: json['user_id'],
      userName: json['user_name'],
      userAvatar: json['user_avatar'],
      lastMessage: json['last_message'],
      lastMessageAt: DateTime.parse(json['last_message_at']),
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

class ChatRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<List<ChatThreadModel>> getThreads() async {
    final response = await apiClient.get('/chat/threads');
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => ChatThreadModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load chat threads');
    }
  }

  Future<List<MessageModel>> getMessages(int userId) async {
    final response = await apiClient.get('/chat/threads/$userId');
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<MessageModel> sendMessage(int receiverId, String message) async {
    final response = await apiClient.post(
      '/chat/message',
      data: {'receiver_id': receiverId, 'message': message},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return MessageModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to send message');
    }
  }
}
