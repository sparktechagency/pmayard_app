import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/chat/chat_controller.dart';
import 'package:pmayard_app/controllers/chat/chat_listen_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/widgets/chat_card.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_list_tile.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_text.dart';
import 'package:pmayard_app/widgets/custom_text_field.dart';

import '../../custom_assets/assets.gen.dart';
import '../../widgets/custom_container.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  final String chatID = Get.arguments as String;

  final ChatController _chatController = Get.find<ChatController>();
  final SocketChatController _socketChatController = Get.find<SocketChatController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.getInbox(chatID);
      _socketChatController.listenMessage(chatID);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 6.w,
      appBar: CustomAppBar(
        backAction: (){
          Get.back();
          _socketChatController.removeListeners(chatID);
        },
        titleWidget: GetBuilder<ChatController>(
          builder: (controller) {
            return CustomListTile(
              image: controller.inboxData?.oppositeUser?.userImage ?? '',
              statusColor: Colors.grey,
              title: controller.inboxData?.oppositeUser?.userName ?? 'N/A',
            );
          }
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChatController>(
              builder: (controller) {
                if(controller.isLoadingInbox){
                  return Center(
                    child: CustomLoader(),
                  );
                }if(controller.inboxData == null || controller.inboxData?.messages == null || controller.inboxData!.messages!.isEmpty){
                  return Center(
                    child: CustomText(
                      text: 'No messages yet. Start the conversation!',
                      fontSize: 16.sp,
                      color: AppColors.appGreyColor,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                  itemCount: controller.inboxData?.messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    final message = controller.inboxData?.messages?.reversed.toList()[index];
                    List<String>? fileUrls = message?.attachmentId?.map((attachment) => attachment.fileUrl as String).toList();

                    return ChatBubbleMessage(
                      profileImage: controller.inboxData?.oppositeUser?.userImage ?? '',
                      images: fileUrls,
                      text: message?.messageText ?? '',
                      time: message?.createdAt ?? '',
                      isMe: message?.senderId?.sId == Get.find<UserController>().user?.sId ,
                    );
                  },
                );
              }
            ),
          ),
          _buildMessageSender(),
        ],
      ),
    );
  }

  Widget _buildMessageSender() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              validator: (_) => null,
              controller: _chatController.messageController,
              hintText: 'Type message...',
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.attachment_outlined,
                    color: AppColors.appGreyColor),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GetBuilder<ChatController>(
            builder: (controller) {
              return CustomContainer(
                onTap: () {
                  if (controller.messageController.text.isNotEmpty) {
                    controller.sendMessage(chatID);
                    controller.messageController.clear();
                  }
                },
                paddingVertical: 12.r,
                paddingHorizontal: 12.r,
                shape: BoxShape.circle,
                color: AppColors.secondaryColor,
                child: Assets.icons.massegeSend.svg(),
              );
            }
          ),
        ],
      ),
    );
  }

  @override
  dispose() {
    _socketChatController.removeListeners(chatID);
    super.dispose();
  }
}
