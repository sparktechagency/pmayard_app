import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/simmer_helper.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/controllers/chat/chat_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_urls.dart';
import '../../app/utils/app_colors.dart';
import '../../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ChatController _chatController = Get.find<ChatController>();

  @override
  void initState() {
    _chatController.getChat(_chatController.selectedValueType.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Inbox'),
      body: Obx(() {
          return Column(
            children: [
              TwoButtonWidget(
                    buttons: _chatController.chatType,
                    selectedValue: _chatController.selectedValueType.value,
                    onTap: (value) => _chatController.onTapChatType(value),
              ),

              if(_chatController.selectedValueType.value != 'group')...[
                SizedBox(height: 12.h),
                CustomTextField(
                  contentPaddingVertical: 14.h,
                  borderRadio: 16.r,
                  filColor: Colors.white,
                  onChanged: (val) {
                    _chatController.filterChats(val);
                  },
                  validator: (_) {
                    return null;
                  },
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.secondaryColor,
                  ),
                  controller: _chatController.searchController,
                  hintText: 'Search people to chat...',
                ),
              ],
              SizedBox(height: 16.h),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.secondaryColor,
                  onRefresh: () async {
                    await _chatController.getChat(
                      _chatController.selectedValueType.value,
                    );
                  },
                  child: Obx(() {
                    if (_chatController.isLoadingChat.value) {
                      return ShimmerHelper.upcomingSessionsShimmer();
                    }

                    if (_chatController.selectedValueType.value == 'individual') {
                      if (_chatController.chatData.isEmpty) {
                        return Center(child: Text('No chats available'));
                      }
                      return GetBuilder<ChatController>(
                          builder: (controller) {
                            return ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _chatController.filteredChatData.length,
                              itemBuilder: (context, index) {
                                final chatItem = _chatController.filteredChatData[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: CustomListTile(
                                    selectedColor:
                                    chatItem.lastMsg != null &&
                                        chatItem.lastMsg?.isRead != true
                                        ? Color(0xffDAE9F3)
                                        : null,
                                    borderColor: AppColors.appGreyColor.withOpacity(0.1),
                                    borderRadius: 8.r,
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes.inboxScreen,
                                        arguments: {'chatId' : chatItem.sId ?? '',},
                                      );
                                    },
                                    image:
                                    '${ApiUrls.imageBaseUrl}${chatItem.otherUser?.roleId?.profileImage?.url ?? ''}',
                                    title: chatItem.otherUser?.roleId?.name ?? 'N/A',
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
                      );

                    } else {
                      if (_chatController.groupChatData.isEmpty) {
                        return Center(child: Text('No announcements available'));
                      }

                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _chatController.groupChatData.length,
                        itemBuilder: (context, index) {
                          final chatItem = _chatController.groupChatData[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.0.h),
                            child: CustomListTile(
                              borderColor: Color(0xffE8E9EB),
                              borderRadius: 8.r,
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.inboxScreen,
                                  arguments: {'chatId' : chatItem.sId ?? '',},
                                );
                              },

                              title: chatItem.conversationName ?? 'N/A',
                              subTitle: chatItem.type == 'text'
                                  ? chatItem.lastMsg?.messageText ?? ''
                                  : chatItem.lastMsg?.messageType ?? '',
                              trailing: CustomText(
                                text: TimeFormatHelper.timeFormat(
                                  chatItem.updatedAt ?? '',
                                ),
                                color: AppColors.appGreyColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  })
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
