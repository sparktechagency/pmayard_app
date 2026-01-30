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
  final ResourceController controller = Get.find<ResourceController>();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    controller.fetchResource();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_shouldLoadMore()) {
        controller.loadMoreResourceData();
      }
    });
  }

  bool _shouldLoadMore() {
    if (controller.isLoadingResourceMore) {
      return false;
    }
    if (!controller.hasMoreResourceData) {
      return false;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final distanceFromBottom = maxScroll - currentScroll;
    bool shouldLoad = distanceFromBottom <= 200.0;
    return shouldLoad;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: 'Resources',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshResourceData();
        },
        child: GetBuilder<ResourceController>(
          builder: (controller) {
            if (controller.isLoadingResource && controller.gradeData.isEmpty) {
              return const Center(
                child: CustomLoader(),
              );
            }
            if (controller.gradeData.isEmpty && !controller.isLoadingResource) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 60.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No Data Available',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Pull down to refresh',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            int totalItems = controller.gradeData.length;
            if (controller.hasMoreResourceData) {
              totalItems = totalItems + 1;
            }
            return ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 10.h,
                bottom: 10.h,
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                if (index == controller.gradeData.length) {
                  return _buildLoadMoreIndicator();
                }
                final grade = controller.gradeData[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                          () => SubjectScreen(),
                      arguments: {
                        "subjectID": grade.id,
                        'gradeName': grade.name,
                      },
                    );
                  },
                  child: ResourceGradeWidget(
                    title: grade.name,
                    icon: Icons.keyboard_arrow_right_rounded,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                if (index == controller.gradeData.length) {
                  return const SizedBox();
                }
                return SizedBox(height: 15.h);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          if (controller.isLoadingResourceMore)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (controller.hasMoreResourceData)
            Column(
              children: [
                Icon(
                  Icons.arrow_downward,
                  size: 24.sp,
                  color: Colors.grey[500],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Scroll down to load more',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            )
          else
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Text(
                '🎉 All data loaded',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.green[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}