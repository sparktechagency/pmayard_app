import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/resources/resource_controller.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/feature/profile/resources/title_screen.dart';
import 'package:pmayard_app/models/resources/grade_model.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final controller = Get.find<ResourceController>();
  final subjectID = Get.arguments['subjectID'];
  final gradeName = Get.arguments['gradeName'];
  // final GradesModel? grade  = Get.arguments['gradeModel'] ;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSubjectData(subjectID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: gradeName,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchSubjectData(subjectID);
        },
        child: controller.isLoadingSubject == true ? CustomLoader() : SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: GetBuilder<ResourceController>(
            builder: (controller) {

              if (controller.isLoadingSubject == true) {
                return Center(child: CustomLoader());
              }

              if (controller.subjectDatas.isEmpty) {
                return Center(child: Text('No Data Found yet'));
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 10.h),
                itemCount: controller.subjectDatas.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Get.to(
                    TitleScreen(),
                    arguments: {
                      'title': controller.subjectDatas[index].name,
                      'materialsID': controller.subjectDatas[index].id,

                    },
                  ),
                  child: ResourceGradeWidget(
                    title: controller.subjectDatas[index].name,
                    icon: Icons.keyboard_arrow_right_rounded,
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
              );
            },
          ),
        ),
      ),
    );
  }
}
