import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/simmer_helper.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/controllers/chat/chat_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import '../../app/utils/app_colors.dart';
import '../../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ChatController _chatController = Get.find<ChatController>();

  @override
  void initState() {
    _chatController.getChat(_chatController.selectedValueType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Inbox'),
      body: Column(
        children: [
          GetBuilder<ChatController>(
            builder: (controller) {
              return TwoButtonWidget(
                buttons: controller.chatType,
                selectedValue: controller.selectedValueType,
                onTap: (value) => controller.onTapChatType(value),
              );
            },
          ),

          SizedBox(height: 12.h),
          CustomTextField(
            contentPaddingVertical: 14.h,
            borderRadio: 16.r,
            filColor: Colors.white,
            onChanged: (val) {},
            validator: (_) {
              return null;
            },
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.secondaryColor,
            ),
            controller: _searchController,
            hintText: 'Search people to chat...',
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.secondaryColor,
              onRefresh: () async {
                await _chatController.getChat(
                  _chatController.selectedValueType,
                );
              },
              child: GetBuilder<ChatController>(
                builder: (controller) {
                  if (controller.isLoadingChat) {
                    return ShimmerHelper.upcomingSessionsShimmer();
                  }
                  if (controller.chatData.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: 'No chats available.',
                        fontSize: 14.sp,
                        color: AppColors.appGreyColor,
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: controller.chatData.length,
                    itemBuilder: (context, index) {
                      final chatItem = controller.chatData[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.0.h),
                        child: CustomListTile(
                          selectedColor:
                              chatItem.lastMsg != null &&
                                  chatItem.lastMsg?.isRead != true
                              ? Color(0xffDAE9F3)
                              : null,
                          borderColor: Color(0xffE8E9EB),
                          borderRadius: 8.r,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.inboxScreen,
                              arguments: chatItem.sId ?? '',
                            );
                          },
                          image:
                              chatItem.users?.first.roleId?.profileImage ??
                              'N/A',
                          title: chatItem.users?.first.roleId?.name ?? 'N/A',
                          subTitle: chatItem.lastMsg?.messageType == 'text'
                              ? chatItem.lastMsg?.messageText ?? ''
                              : chatItem.lastMsg?.messageType ?? '',
                          trailing: CustomText(
                            text: TimeFormatHelper.timeFormat(
                              chatItem.lastMsg?.createdAt ?? '',
                            ),
                            color: AppColors.appGreyColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
