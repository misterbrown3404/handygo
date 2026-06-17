import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../providers/api_client.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<ChatModel>> getThreads() async {
    final dio.Response response = await _apiClient.get('/chat/threads');
    final List list = response.data['data'] ?? response.data;
    return list.map((e) => ChatModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MessageModel>> getMessages(int userId) async {
    final dio.Response response = await _apiClient.get('/chat/threads/$userId');
    final List list = response.data['data'] ?? response.data;
    return list.map((e) => MessageModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MessageModel> sendMessage(int receiverId, String content) async {
    final dio.Response response = await _apiClient.post('/chat/message', data: {
      'receiver_id': receiverId,
      'content': content,
    });
    final Map<String, dynamic> data = response.data['data'] ?? response.data;
    return MessageModel.fromJson(data);
  }
}
