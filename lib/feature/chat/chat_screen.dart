import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
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

  @override
  void initState() {
    super.initState();
  }


  final chatType = [
    {'label': 'Chat', 'value': 'chat'},
    {'label': 'Group', 'value': 'group'},
  ];

  String selectedValueType = 'chat';



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Inbox',
      ),
      body: Column(
        children: [

          TwoButtonWidget(buttons: chatType, selectedValue: selectedValueType, onTap: (value){
            selectedValueType = value;
            setState(() {
            });
          }),

          SizedBox(height: 12.h),
          CustomTextField(
            contentPaddingVertical: 14.h,
            borderRadio: 16.r,
            filColor: Colors.white,
            onChanged: (val) {},
            validator: (_) {
              return null;
            },
            prefixIcon: const Icon(Icons.search,color: AppColors.secondaryColor,),
            controller: _searchController,
            hintText: 'Search people to chat...',
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.secondaryColor,
              onRefresh: () async {
              },
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.only(bottom: 8.0.h),
                    child: CustomListTile(
                      selectedColor: index == 0 ? Color(0xffDAE9F3) : null,
                      borderColor: Color(0xffE8E9EB),
                        borderRadius: 8.r,
                        onTap: () {
                        Get.toNamed(AppRoutes.inboxScreen);
                        },
                        image: '',
                        title: 'Tanvir Hridoy',
                        activeColor: Colors.green,
                        subTitle: 'hy how are you ??',
                        trailing: CustomText(
                          text: TimeFormatHelper.timeFormat(DateTime.now()),
                          color: AppColors.appGreyColor,
                          fontSize: 10.sp,
                        )
                    ),
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
