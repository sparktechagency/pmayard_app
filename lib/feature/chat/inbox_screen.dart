import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/chat/chat_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/widgets/chat_card.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_list_tile.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
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
  final TextEditingController _messageController = TextEditingController();

  final ChatController _chatController = Get.find<ChatController>();

  // Dummy Chat List
  final List<Map<String, dynamic>> _dummyMessages = [
    {"text": "Hey! How are you?", "time": "10:20 AM", "isMe": false},
    {"text": "I'm good, what about you?", "time": "10:22 AM", "isMe": true},
    {"text": "Doing well, thanks for asking!", "time": "10:25 AM", "isMe": false},
    {"text": "Are you free this evening?", "time": "10:28 AM", "isMe": false},
    {"text": "Yes, I am. Any plans?", "time": "10:30 AM", "isMe": true},
    {"text": "Let’s catch up at the café.", "time": "10:32 AM", "isMe": false},
    {"text": "Perfect, see you then!", "time": "10:35 AM", "isMe": true},
  ];



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.getInbox(chatID);
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
              controller: _messageController,
              hintText: 'Type message...',
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.attachment_outlined,
                    color: AppColors.appGreyColor),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          CustomContainer(
            onTap: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _dummyMessages.add({
                    "text": _messageController.text,
                    "time": "Now",
                    "isMe": true,
                  });
                });
                _messageController.clear();
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
  }
}
