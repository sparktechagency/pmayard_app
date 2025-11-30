import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/resources/resource_controller.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  final controller = Get.find<ResourceController>();

  final titleName = Get.arguments['title'];
  final materialsID = Get.arguments['materialsID'];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMetarials(materialsID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: titleName ?? '',
      ),

      body: GetBuilder<ResourceController>(
        builder: (controller) {
          return ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10.h),
            itemCount: controller.metarialsModel.length ?? 0,
            itemBuilder: (context, index) => ResourceGradeWidget(
              title: controller.metarialsModel[index].title,
              downloader: (){
                downloadFile(controller.metarialsModel[index].fileUrl);
              },
              icon: Icons.download,
            ),
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
          );
        },
      ),
    );
  }

  // File Downloader Function are here
  void downloadFile(String url) async {
    var dio = Dio();
    Directory directory = await getApplicationDocumentsDirectory();

    var response = await dio.download(
      url,
      '${directory.path}/${url.split('/').last}', // Save file with real name
    );

    print(response.data);
  }

}
