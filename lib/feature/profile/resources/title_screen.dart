import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/feature/profile/resources/subject_screen.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
          borderColor: AppColors.secondaryColor,
          title: 'Grade 1',
        ),

        body: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10.h),
          itemCount: 15,
          itemBuilder:  (context, index) => ResourceGradeWidget(title: 'Title',icon: Icons.download),
          separatorBuilder: (context, index) => SizedBox(height:  15.h,),
        )
    );
  }
}

