import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/utils/app_colors.dart';
import '../../widgets/widgets.dart';
import '../bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final CustomBottomNavBarController _navBarController = Get.put(CustomBottomNavBarController());


  final List<Widget> _screens = const [
    // HomeScreen(),
    // PlanScreen(),
    // ProgressScreen(),
    // ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _screens[_navBarController.selectedIndex.value],
          bottomNavigationBar: CustomContainer(
            paddingTop: 6.h,
            linearColors: <Color>[
              Color(0xff393939),
              Color(0xff393939).withOpacity(0.5),
            ],
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    _navItems.length, (index) => _buildNavItem(index)),
              ),
            ),
          ),
        ));
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _navBarController.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => _navBarController.onChange(index),
      child: SizedBox(
        width: 60.w,
        height: 36.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              _navItems[index]["icon"],
              color: isSelected ? AppColors.primaryColor : Colors.grey,
              width: isSelected ? 16.w : 18.w,
              height: isSelected ? 16.h : 18.h,
            ),
            SizedBox(height: 4.h),
            Text(
              _navItems[index]["label"],
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _navItems = [
    // {"icon": Assets.icons.homeBottom.path, "label": "Home"},
    // {"icon": Assets.icons.planBottom.path, "label": "Plan"},
    // {"icon": Assets.icons.progress.path, "label": "Progress"},
    // {"icon": Assets.icons.profileNav.path, "label": "Profile"},
  ];
}
