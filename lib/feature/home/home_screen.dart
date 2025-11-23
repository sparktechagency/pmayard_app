import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:pmayard_app/feature/home/widgets/assigned_card_widget.dart';
import 'package:pmayard_app/widgets/widgets.dart';
import '../../custom_assets/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssignedController _assignedController = Get.find<AssignedController>();



  @override
  void initState() {
      _assignedController.getAssigned();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 0,
      appBar: CustomAppBar(
        titleWidget: GetBuilder<UserController>(
          builder: (controller) {
            final userData = controller.user;
            return CustomListTile(
              image: userData?.roleId?.profileImage,
              imageRadius: 24.r,
              contentPaddingHorizontal: 16.w,
              titleColor: Colors.white,
              title: 'Welcome!',
              titleFontSize: 12.sp,
              subTitle: userData?.roleId!.name ?? 'Enter Your Name',
              subtitleFontSize: 14.sp,
              statusColor: Colors.white,
            );
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Assets.icons.notification.svg()),
        ],
        toolbarHeight: 90.h,
        backgroundColor: AppColors.secondaryColor,
      ),

      body: SingleChildScrollView(
        child: GetBuilder<UserController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  top: 24.h,
                  bottom: 24.h,
                  left: 16.w,
                  right: 16.w,
                  text: 'Assigned ${controller.user?.roleId?.name == 'parent' ? 'Professionals' : 'Parents'}',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),

                GetBuilder<AssignedController>(
                    builder: (controller) {
                    if (controller.isLoadingAssigned) {
                      return Center(child: CustomLoader());
                    }

                    if (controller.assignedData.isEmpty) {
                      return Center(
                        child: CustomText(
                          text: 'No assigned',
                          fontSize: 14.sp,
                        ),
                      );
                    }
                    return SizedBox(
                      height: 180.h,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(controller.assignedData.length, (index) {
                            final assigned = controller.assignedData[index];
                            final professionalInfo = assigned.professionalInfo;
                            final parentInfo = assigned.parentInfo;
                            String name = '';
                            String role = '';
                            String imageUrl = '';
                            if (professionalInfo != null) {
                              name = professionalInfo.name ?? 'No Name';
                              role = parentInfo?.user?.role ?? 'parent';
                              imageUrl = professionalInfo.profileImage ?? '';
                            } else if (parentInfo != null) {
                              name = parentInfo.name ?? 'No Name';
                              role = parentInfo.user?.role ?? 'Professional';
                              imageUrl = parentInfo.profileImage ?? '';
                            }

                            return AssignedCardWidget(
                              index: index,
                              name: name,
                              role: role,
                              imageUrl: imageUrl,
                            );
                          }),
                        ),
                      ),
                    );
                  }
                ),


                /// ===================>>>>    Upcoming Sessions =================>>>> ///
                CustomText(
                  top: 24.h,
                  bottom: 10.h,
                  left: 16.w,
                  right: 16.w,
                  text: 'Upcoming Sessions',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),

                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
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
                          onPressed: () {
                            Get.find<CustomBottomNavBarController>().onChange(1);
                          },
                          label: 'View Detail',
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 44.h),
              ],
            );
          }
        ),
      ),
    );
  }
}

