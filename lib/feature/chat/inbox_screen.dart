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
  final String chatID = Get.arguments['chatId'] as String;

  final ChatController _chatController = Get.find<ChatController>();
  final SocketChatController _socketChatController =
      Get.find<SocketChatController>();

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
        backAction: () {
          _socketChatController.removeListeners(chatID);
          Get.back();
        },
        titleWidget: GetBuilder<ChatController>(
          builder: (controller) {
            return CustomListTile(
              image: controller.inboxData?.oppositeUser?.userImage ?? '',
              statusColor: Colors.grey,
              title: controller.inboxData?.oppositeUser?.userName ?? 'Admin',
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChatController>(
              builder: (controller) {
                if (controller.isLoadingInbox) {
                  return Center(child: CustomLoader());
                }
                if (controller.inboxData == null ||
                    controller.inboxData?.messages == null ||
                    controller.inboxData!.messages!.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No messages yet. Start the conversation!',
                      fontSize: 16.sp,
                      color: AppColors.appGreyColor,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 8.w,
                  ),
                  itemCount: controller.inboxData?.messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    final message = controller.inboxData?.messages?.reversed
                        .toList()[index];
                    List<String>? fileUrls = message?.attachmentId
                        ?.map((attachment) => attachment.fileUrl as String)
                        .toList();
                    // ever( controller.inboxData?.messages!, (_){
                    //   controller.scrollBottom();
                    // });

                    return ChatBubbleMessage(
                      profileImage:
                          controller.inboxData?.oppositeUser?.userImage ?? '',
                      images:  message?.messageType == 'attachments' ? fileUrls : null,
                      audioUrls: message?.messageType == 'audio' ? fileUrls : null,
                      text: message?.messageText ?? '',
                      time: message?.createdAt ?? '',
                      isMe:
                          message?.senderId?.sId ==
                          Get.find<UserController>().user?.sId,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageSender(),
        ],
      ),
    );
  }

  Widget _buildMessageSender() {
    return GetBuilder<ChatController>(
      builder: (controller) {
        // 🔥 If uploading audio or image → show progress bubble
        if (controller.isLoadingAudio || controller.isLoadingImage) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(AppColors.secondaryColor),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            controller.isLoadingAudio
                                ? "Uploading audio..."
                                : "Uploading image...",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

        // 🔥 DEFAULT SENDER UI
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  enabled: !controller.isRecording,
                  validator: (_) => null,
                  controller: _chatController.messageController,
                  hintText: controller.isRecording
                      ? 'Recording... ${controller.recordingDuration.inSeconds}s'
                      : 'Type message...',
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (!controller.isRecording) {
                        controller.onTapImageShow(context, chatID);
                      }
                    },
                    icon: Icon(
                      Icons.attachment_outlined,
                      color: AppColors.appGreyColor,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 6.w),

              // 🎤 RECORD BUTTON
              GestureDetector(
                onTapDown: (_) {
                  if (!controller.isRecording) controller.startRecording();
                },
                onTapUp: (_) {
                  if (controller.isRecording) controller.stopRecording(chatID);
                },
                onLongPressEnd: (_) {
                  if (controller.isRecording) controller.cancelRecording();
                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.isRecording
                        ? AppColors.errorColor.withOpacity(0.1)
                        : Colors.transparent,
                    boxShadow: controller.showGlowEffect
                        ? [
                      BoxShadow(
                        color: AppColors.errorColor.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ]
                        : [],
                  ),
                  child: Icon(
                    controller.isRecording
                        ? Icons.mic
                        : Icons.keyboard_voice_rounded,
                    color: controller.isRecording
                        ? AppColors.errorColor.withOpacity(0.5)
                        : AppColors.appGreyColor,
                    size: 24.r,
                  ),
                ),
              ),

              SizedBox(width: 6.w),

              // 📤 SEND / CANCEL BUTTON
              controller.isRecording
                  ? CustomContainer(
                onTap: () {
                  controller.cancelRecording();
                },
                paddingVertical: 12.r,
                paddingHorizontal: 12.r,
                shape: BoxShape.circle,
                color: AppColors.appGreyColor,
                child: Icon(Icons.close, color: Colors.white),
              )
                  : CustomContainer(
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
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  dispose() {
    _socketChatController.removeListeners(chatID);
    super.dispose();
  }
}
