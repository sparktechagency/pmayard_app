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

    // 1. Create ScrollController
    _scrollController = ScrollController();

    // 2. Load initial data
    print('🚀 Initializing screen...');
    controller.fetchResource();

    // 3. Setup scroll listener
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Debug: print scroll position
      print('📜 Scroll position: ${_scrollController.position.pixels}');
      print('📜 Max scroll: ${_scrollController.position.maxScrollExtent}');
      print('📜 Extent after: ${_scrollController.position.extentAfter}');

      if (_shouldLoadMore()) {
        print('🎯 Bottom reached! Loading more data...');
        controller.loadMoreData();
      }
    });
  }

  bool _shouldLoadMore() {
    // 1. Check if already loading
    if (controller.isLoadingResourceMore) {
      print('⏳ Already loading more data...');
      return false;
    }

    // 2. Check if has more data
    if (!controller.hasMoreData) {
      print('🏁 No more data to load');
      return false;
    }

    // 3. Check if scroll position reached bottom (200px threshold)
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final distanceFromBottom = maxScroll - currentScroll;

    // Load when 200px from bottom
    bool shouldLoad = distanceFromBottom <= 200.0;

    if (shouldLoad) {
      // print('📍 Distance from bottom: $distanceFromBottompx (threshold: 200px)');
    }

    return shouldLoad;
  }

  @override
  void dispose() {
    // Dispose ScrollController to prevent memory leaks
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
          print('🔄 Pull to refresh triggered');
          await controller.refreshData();
        },
        child: GetBuilder<ResourceController>(
          builder: (controller) {
            print('🔄 UI Rebuilding...');
            print('📊 Current items: ${controller.gradeData.length}');
            print('📊 Has more data: ${controller.hasMoreData}');
            print('📊 Is loading more: ${controller.isLoadingResourceMore}');

            // 1. Initial loading state
            if (controller.isLoadingResource && controller.gradeData.isEmpty) {
              return const Center(
                child: CustomLoader(),
              );
            }

            // 2. Empty state (no data found)
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

            // 3. Calculate total items (data + loading indicator if needed)
            int totalItems = controller.gradeData.length;
            if (controller.hasMoreData) {
              totalItems = totalItems + 1; // +1 for loading indicator
            }

            print('📈 Total items in ListView: $totalItems');

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
                // 4. Check if this is the loading indicator position
                if (index == controller.gradeData.length) {
                  // This is the loading indicator
                  return _buildLoadMoreIndicator();
                }

                // 5. Normal data item
                final grade = controller.gradeData[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                          () => SubjectScreen(),
                      arguments: {
                        "subjectID": grade.id,
                        'gradeName': grade.name,
                        // 'gradeModel': grade
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
                // 6. Don't add separator after loading indicator
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
    print('🎬 Building load more indicator...');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          // Show circular progress if loading
          if (controller.isLoadingResourceMore)
            const Center(
              child: CircularProgressIndicator(),
            )
          // Show "Load More" text if not loading but has more data
          else if (controller.hasMoreData)
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
          // Show end of list message
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