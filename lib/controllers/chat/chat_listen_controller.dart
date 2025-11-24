import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/chat/chat_controller.dart';
import 'package:pmayard_app/models/chat/inbox_model_data.dart';
import 'package:pmayard_app/services/socket_services.dart';

class SocketChatController extends GetxController {
  SocketServices socketService = SocketServices();
  final ChatController _chatController = Get.find<ChatController>();




   /// ===============> Listen for new messages via socket.
  void listenMessage(String conversationID) {
    SocketServices.socket?.on("new_message-$conversationID", (data) {
      if (data != null) {
        debugPrint("New message received: $data");

        final socketData = SocketModelData.fromJson(data);

        final convertedMessage = convertSocketToMessage(socketData);

        _chatController.inboxData?.messages?.insert(0, convertedMessage);
        _chatController.refresh();
      }
    });
  }



  Messages convertSocketToMessage(SocketModelData socketData) {
    final msg = socketData.message;

    return Messages(
      sId: "",
      conversationId: socketData.conversationId,
      senderId: SenderId(
        sId: msg?.senderId,
        email: null,
        role: null,
        roleId: null,
      ),
      attachmentId: msg?.attachment?.map((a) {
        return AttachmentId(
          sId: a.id,
          fileUrl: a.fileUrl,
          mimeType: a.mimeType,
        );
      }).toList(),
      messageText: msg?.lastMessage,
      messageType: msg?.messageType,
      isDeleted: false,
      createdAt: msg?.timestamp,
      updatedAt: msg?.timestamp,
      iV: 0,
    );
  }



  void removeListeners(String conversationId) {
    SocketServices.socket?.off("new_message-$conversationId");
  }


}

