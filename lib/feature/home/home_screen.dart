import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/auth_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_button.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
import 'package:pmayard_app/widgets/custom_image_avatar.dart';
import 'package:pmayard_app/widgets/custom_list_tile.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_text.dart';

import '../../custom_assets/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    _userController.userData();
    // _authController.userData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 0,
      appBar: CustomAppBar(
        titleWidget: GetBuilder<UserController>(builder: (controller){
          final userData = _userController.user;
          return CustomListTile(
            imageRadius: 24.r,
            contentPaddingHorizontal: 16.w,
            titleColor: Colors.white,
            title: 'Welcome!',
            titleFontSize: 12.sp,
            subTitle: userData?.email,
            subtitleFontSize: 14.sp,
            statusColor: Colors.white,
          );
        }),
        actions: [

          IconButton(
              onPressed: () {

              }, icon: Assets.icons.notification.svg())
        ],
        toolbarHeight: 90.h,
        backgroundColor: AppColors.secondaryColor,
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                top: 24.h,
                bottom: 24.h,
                left: 16.w,
                right: 16.w,
                text: 'Assigned Parent',fontWeight: FontWeight.w600,fontSize: 16.sp),

            SizedBox(
              height: 180.h,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(4, (index) {
                    return CustomContainer(
                      paddingVertical: 10.h,
                      paddingHorizontal: 10.w,
                      marginRight: 14.w,
                      marginLeft: index == 0 ? 14.w : 0,
                      radiusAll: 8.r,
                      height: 170.h,
                      width: 170.w,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),

                      ],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageAvatar(radius: 26.r),
                          SizedBox(height: 8.h),
                          CustomText(text: 'Eva',fontWeight: FontWeight.w500,fontSize: 16.sp,),
                          CustomText(
                              bottom: 8.h,
                              text: 'Parent',color: AppColors.appGreyColor),

                          Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                    height: 28.h,
                                    fontSize: 10.sp,
                                    backgroundColor: AppColors.primaryColor,
                                    onPressed: (){
                                      Get.toNamed(AppRoutes.profileViewScreen);
                                    },label: 'View Profile',)),
                              SizedBox(width: 4.w),
                              Expanded(child: CustomButton(
                                height: 28.h,
                                fontSize: 10.sp,
                                backgroundColor: AppColors.primaryColor,
                                onPressed: (){
                                  Get.toNamed(AppRoutes.inboxScreen);
                                },label: 'Message',)),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            CustomText(
                top: 24.h,
                bottom: 10.h,
                left: 16.w,
                right: 16.w,
                text: 'Upcoming Sessions',fontWeight: FontWeight.w600,fontSize: 16.sp),



            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 6.h),
                  child: CustomListTile(
                    contentPaddingVertical: 6.h,
                    borderRadius: 8.r,
                    borderColor: AppColors.borderColor,
                    image: '',
                    title: 'Annette Black',
                    subTitle: '08/08/25 at 4:30 PM',
                    titleFontSize: 16.sp,
                    trailing: CustomButton(
                        radius: 8.r,
                        height: 25.h,
                        fontSize: 10.sp,
                        onPressed: (){
                          Get.find<CustomBottomNavBarController>().onChange(1);
                        },label: 'View Detail'),
                  ),
                );
              },),

            SizedBox(height: 44.h),

          ],
        ),
      ),
    );
  }
}

