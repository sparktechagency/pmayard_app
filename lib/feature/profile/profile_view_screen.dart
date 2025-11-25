import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import '../../widgets/widgets.dart';
class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: AppColors.secondaryColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              alignment: Alignment.bottomCenter,
              bottomLeft: 70.r,
              bottomRight: 70.r,
              height: 150.h,
              width: double.infinity,
              color: AppColors.secondaryColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageAvatar(
                    radius: 48.r,
                    image: '',
                  ),
                  CustomText(text: "Eva", fontSize: 18.h,fontWeight: FontWeight.w500,top: 4.h,bottom : 8.h ,color: Colors.white),
                ],
              ),
            ),
            Center(child: CustomText(text: "Parent", fontSize: 12.h,fontWeight: FontWeight.w500,top: 4.h,color: AppColors.appGreyColor)),
            SizedBox(height: 44.h),
            _buildListTile(title: 'Child’s Name', subtitle: 'Max'),
            _buildListTile(title: 'Child’s Grade', subtitle: '5th'),
            _buildListTile(title: 'Subjects', subtitle: 'Mathematics'),
            _buildListTile(title: 'Email', subtitle: 'eva@gmail.com'),
            _buildListTile(title: 'Phone Number', subtitle: '987654'),
            _buildListTile(title: 'Confirmed Session', subtitle: '08/08/25 at 4:30 PM'),
        
            SizedBox(height: 44.h),
        
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:  16.w),
              child: CustomButton(onPressed: (){},label: 'Set Schedule'),
            ),
        
            SizedBox(height: 44.h),
        
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({required String title,required String subtitle}) {
    return Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title, fontSize: 16.h,fontWeight: FontWeight.w600,top: 4.h,color: Color(0xff333333)),
              CustomText(text: subtitle, fontSize: 12.h,fontWeight: FontWeight.w500,top: 4.h,color: AppColors.appGreyColor,bottom: 8.h,),
            ],
          ),
        );
  }
}