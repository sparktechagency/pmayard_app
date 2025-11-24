import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/feature/profile/resources/subject_screen.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: 'Resources',
      ),

      body: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10.h),
        itemCount: 15,
        itemBuilder:  (context, index) => GestureDetector(
          onTap: (){
            Get.to(()=> SubjectScreen());
          },
          child: ResourceGradeWidget(title: 'Grade 1',icon: Icons.keyboard_arrow_right_rounded,),
        ),
        separatorBuilder: (context, index) => SizedBox(height:  15.h,),
      )
    );
  }
}

