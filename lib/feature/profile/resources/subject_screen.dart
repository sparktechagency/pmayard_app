import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: 'Grade 1',
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder:  (context, index) => ResourceGradeWidget(),
              separatorBuilder: (context, index) => SizedBox(height:  25.h,),
            )
          ],
        ),
      ),
    );
  }
}

