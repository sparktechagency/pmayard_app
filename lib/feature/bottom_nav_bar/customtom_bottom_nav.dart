import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/custom_assets/fonts.gen.dart';
import 'package:pmayard_app/feature/chat/chat_screen.dart';
import 'package:pmayard_app/feature/home/home_screen.dart';
import 'package:pmayard_app/feature/profile/profile_screen.dart';
import 'package:pmayard_app/feature/session/session_screen.dart';
import '../../app/utils/app_colors.dart';
import '../bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final CustomBottomNavBarController _navBarController = Get.put(
    CustomBottomNavBarController(),
  );

  final List<Widget> _screens = [
    HomeScreen(),
    SessionScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {"icon": Assets.icons.home.path, "label": "Home"},
    {"icon": Assets.icons.session.path, "label": "Session"},
    {"icon": Assets.icons.chat.path, "label": "Chat"},
    {"icon": Assets.icons.bottomProfile.path, "label": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: _screens[_navBarController.selectedIndex.value],
        bottomNavigationBar: SafeArea(
          top: false,
          child: CurvedNavigationBar(
            backgroundColor: Colors.white,
            color: AppColors.primaryColor,
            buttonBackgroundColor: AppColors.secondaryColor,
            index: _navBarController.selectedIndex.value,
            items: List.generate(_navItems.length, (index) {
              bool isSelected = _navBarController.selectedIndex.value == index;
              return CurvedNavigationBarItem(
                child: SvgPicture.asset(
                  _navItems[index]["icon"],
                  color: isSelected ? Colors.white : AppColors.secondaryColor,
                  width: isSelected ? 24.w : 24.w,
                  height: isSelected ? 24.h : 24.h,
                ),
                label: _navItems[index]["label"],
                labelStyle: TextStyle(
                  fontFamily: FontFamily.inter,
                  fontSize: 10.sp,
                  color: isSelected
                      ? Colors.transparent
                      : AppColors.secondaryColor,
                ),
              );
            }),
            onTap: (index) => _navBarController.onChange(index),
          ),
        ),
      ),
    );
  }
}
