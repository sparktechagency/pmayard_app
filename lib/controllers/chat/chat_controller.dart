import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/models/chat/chat_model_data.dart';
import 'package:pmayard_app/models/chat/group_chat_model_data.dart';
import 'package:pmayard_app/models/chat/inbox_model_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getChat(selectedValueType.value);
  }

  // bool isLoadingChat = false;
  RxBool isLoadingChat = false.obs;

  // List<ChatModelData> chatData = [];
  // List<GroupChatMessageModel> groupChatData = [];
  //

  var  chatData = <ChatModelData>[].obs;
  var groupChatData =<GroupChatMessageModel>[].obs;

  final chatType = [
    {'label': 'Chat', 'value': 'individual'},
    {'label': 'Announcement', 'value': 'group'},
  ];

  // String selectedValueType = 'individual';

  RxString selectedValueType = 'individual'.obs;

  void onTapChatType(String value) {
    selectedValueType.value = value;
    getChat(value);
    print('Selected chat type: $value');
  }

  Future<void> getChat(String type) async {
    chatData.clear();
    groupChatData.clear();
    isLoadingChat.value = true;
    // isLoadingChat = true;
    update();

    final response = await ApiClient.getData(ApiUrls.conversations(type));
    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      if( selectedValueType == 'individual'){
        final chats = data.map((item) => ChatModelData.fromJson(item)).toList();
        chatData.addAll(chats);
        print('=============> Message $chats');
      }else if( selectedValueType == 'group') {
        final chats = data.map((item) => GroupChatMessageModel.fromJson(item)).toList();
        groupChatData.addAll(chats);
        print('=====================> group $chats');
      }
    }
    // isLoadingChat = false;
    isLoadingChat.value = false;
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

  final TextEditingController messageController = TextEditingController();

  bool isSendingMessage = false;

  Future<void> sendMessage(String conversationID) async {
    isSendingMessage = true;
    update();

    final response = await ApiClient.postData(
      ApiUrls.sendMessage(conversationID),
      {"message_text": messageController.text.trim()},
    );
    if (response.statusCode == 200) {}
    isSendingMessage = false;
    update();
  }
}
