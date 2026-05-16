import 'package:get/get.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final _chatRepo = ChatRepository();

  final threads = <ChatThreadModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchThreads();
  }

  Future<void> fetchThreads() async {
    try {
      isLoading(true);
      final data = await _chatRepo.getThreads();
      threads.assignAll(data);
    } catch (e) {
      print("Error fetching chat threads: $e");
    } finally {
      isLoading(false);
    }
  }
}
