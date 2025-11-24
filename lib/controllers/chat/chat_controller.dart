import 'package:get/get.dart';
import 'package:pmayard_app/models/chat/chat_model_data.dart';
import 'package:pmayard_app/models/chat/inbox_model_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class ChatController extends GetxController {
  bool isLoadingChat = false;

  List<ChatModelData> chatData = [];

  final chatType = [
    {'label': 'Chat', 'value': 'individual'},
    {'label': 'Announcement', 'value': 'group'},
  ];

  String selectedValueType = 'individual';

  void onTapChatType(value) {
    selectedValueType = value;
    update();
    getChat(selectedValueType);
  }

  Future<void> getChat(String type) async {
    chatData.clear();
    isLoadingChat = true;
    update();

    final response = await ApiClient.getData(ApiUrls.conversations(type));
    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      final chats = data.map((item) => ChatModelData.fromJson(item)).toList();

      chatData.addAll(chats);
    }
    isLoadingChat = false;
    update();
  }

  bool isLoadingInbox = false;
  InboxModelData? inboxData;

  Future<void> getInbox(String chatID) async {
    isLoadingInbox = true;
    update();

    final response = await ApiClient.getData(ApiUrls.inbox(chatID));
    if (response.statusCode == 200) {
      final data = response.body['data'];

      if (data != null) {
        inboxData = InboxModelData.fromJson(data);
      }
    }
    isLoadingInbox = false;
    update();
  }
}
