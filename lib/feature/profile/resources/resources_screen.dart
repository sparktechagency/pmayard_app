import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/resources/resource_controller.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/feature/profile/resources/subject_screen.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final controller = Get.find<ResourceController>();

  @override
  void initState() {
    controller.fetchResource('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: 'Resources',
      ),

      body: GetBuilder<ResourceController>(
        builder: (controller) {
          if (controller.isLoadingResource) {
            return Center(child: CustomLoader());
          }
          if (controller.gradeDatas.isEmpty) {
            return Center(child: Text(' No Data Yet '));
          }
          return ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10.h),
            itemCount: controller.gradeDatas.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Get.to(
                  () => SubjectScreen(),
                  arguments: {
                    "subjectID": controller.gradeDatas[index].id,
                    'gradeName': controller.gradeDatas[index].name,
                  },
                );
              },
              child: ResourceGradeWidget(
                title: controller.gradeDatas[index].name,
                icon: Icons.keyboard_arrow_right_rounded,
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
          );
        },
      ),
    );
  }
}
