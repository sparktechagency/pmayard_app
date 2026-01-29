import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/resources/resource_controller.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/feature/profile/resources/title_screen.dart';
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

  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setUpScrollListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSubjectData(subjectID);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.clearSubjectData();
    super.dispose();
  }

  void _setUpScrollListener() {
    _scrollController.addListener(() {
      if (_scrollLoadMode() && !_isLoadingMore) {
        _loadMoreData();
      }
    });
  }

  bool _scrollLoadMode() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      return true;
    }
    return false;
  }

  void _loadMoreData() async {
    if (controller.isLoadingSubjectMore || !controller.hasMoreSubjectData) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    await controller.loadMoreSubjectData();

    setState(() {
      _isLoadingMore = false;
    });
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
          await controller.refreshSubjectData();
        },
        child: GetBuilder<ResourceController>(
          builder: (controller) {
            if (controller.isLoadingSubject && controller.subjectDatas.isEmpty) {
              return const Center(child: CustomLoader());
            }

            if (controller.subjectDatas.isEmpty) {
              return Center(
                child: Text(
                  'No Data Found',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.secondaryColor,
                  ),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    _scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent &&
                    !controller.isLoadingSubjectMore &&
                    controller.hasMoreSubjectData) {
                  _loadMoreData();
                }
                return false;
              },
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.subjectDatas.length +
                    (controller.hasMoreSubjectData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.subjectDatas.length) {
                    if (controller.isLoadingSubjectMore) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    }

                    if (controller.hasMoreSubjectData) {
                      return SizedBox(height: 50.h);
                    }

                    return SizedBox.shrink();
                  }

                  final subject = controller.subjectDatas[index];

                  return GestureDetector(
                    onTap: () => Get.to(
                      TitleScreen(),
                      arguments: {
                        'title': subject.name,
                        'materialsID': subject.id,
                      },
                    ),
                    child: ResourceGradeWidget(
                      title: subject.name,
                      icon: Icons.keyboard_arrow_right_rounded,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  if (index >= controller.subjectDatas.length) {
                    return SizedBox.shrink();
                  }
                  return SizedBox(height: 15.h);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}