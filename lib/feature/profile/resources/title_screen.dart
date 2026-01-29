import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/resources/resource_controller.dart';
import 'package:pmayard_app/feature/profile/resources/resources_widgets/ResourceGradeWidget.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  final controller = Get.find<ResourceController>();

  final titleName = Get.arguments['title'];
  final materialsID = Get.arguments['materialsID'];

  Dio dio = Dio();
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setUpScrollListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMetarials(materialsID);
    });
  }

  @override
  void didUpdateWidget(covariant TitleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if we're navigating away and need to clear data
    if (!mounted) {
      _clearData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Don't call update() in dispose - it causes the error
    // Instead, clear data without update
    Future.delayed(Duration.zero, () {
      if (Get.isRegistered<ResourceController>()) {
        controller.metarialsModel.clear();
        controller.currentMaterialId = null;
        controller.currentMaterialPage = 1;
        controller.hasMoreMaterialData = true;
      }
    });
    super.dispose();
  }

  void _clearData() {
    // Alternative: Use a delayed update if really needed
    Future.delayed(Duration(milliseconds: 100), () {
      if (Get.isRegistered<ResourceController>() && mounted) {
        controller.metarialsModel.clear();
        controller.currentMaterialId = null;
        controller.currentMaterialPage = 1;
        controller.hasMoreMaterialData = true;
        controller.update();
      }
    });
  }

  void _setUpScrollListener() {
    _scrollController.addListener(() {
      if (_isAtBottom() && !_isLoadingMore) {
        _loadMoreData();
      }
    });
  }

  bool _isAtBottom() {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load more when user is 50 pixels from bottom
    return currentScroll >= (maxScroll - 50);
  }

  void _loadMoreData() async {
    if (controller.isLoadingMaterialMore || !controller.hasMoreMaterialData) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    await controller.loadMoreMaterialData();

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: titleName ?? '',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshMaterialData();
        },
        child: GetBuilder<ResourceController>(
          builder: (controller) {
            // Show loading indicator (initial load only)
            if (controller.isLoadingMaterial && controller.metarialsModel.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }

            // Show empty state
            if (controller.metarialsModel.isEmpty) {
              return Center(
                child: Text(
                  'No materials available',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              );
            }

            // Show list with pagination
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    _scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent &&
                    !controller.isLoadingMaterialMore &&
                    controller.hasMoreMaterialData) {
                  _loadMoreData();
                }
                return false;
              },
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 10.h,
                  bottom: 20.h,
                  left: 16.w,
                  right: 16.w,
                ),
                itemCount: controller.metarialsModel.length +
                    (controller.hasMoreMaterialData ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the bottom
                  if (index == controller.metarialsModel.length) {
                    if (controller.isLoadingMaterialMore || _isLoadingMore) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    }

                    if (controller.hasMoreMaterialData) {
                      return SizedBox(height: 50.h);
                    }

                    return const SizedBox.shrink();
                  }

                  final material = controller.metarialsModel[index];
                  final fileUrlPath = material.fileUrl?.url ?? '';
                  final fullUrl = fileUrlPath.isNotEmpty
                      ? '${ApiUrls.imageBaseUrl}$fileUrlPath'
                      : '';

                  return ResourceGradeWidget(
                    title: material.title ?? 'Untitled',
                    downloader: () {
                      if (fullUrl.isNotEmpty) {
                        _downloadFile(fullUrl, material.title ?? 'file');
                      } else {
                        showToast("File URL not available");
                      }
                    },
                    icon: Icons.download,
                  );
                },
                separatorBuilder: (context, index) {
                  if (index >= controller.metarialsModel.length) {
                    return const SizedBox.shrink();
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

  // File Downloader Function
  Future<void> _downloadFile(String url, String fileName) async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Safe path (No permission needed)
      Directory directory = await getApplicationDocumentsDirectory();

      // Extract extension
      String extension = _getFileExtension(url);

      // Full file path
      String savePath = "${directory.path}/$fileName$extension";

      print("Saving file to: $savePath");

      // Create folder if not exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Download
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("Downloading: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      Get.back();

      showToast(
        "File downloaded successfully",
      );

      _showOpenFileDialog(savePath, "$fileName$extension");
    } catch (e) {
      Get.back();
      print("Download error: $e");
      showToast(
        "Download failed",
      );
    }
  }

  // Get file extension from URL
  String _getFileExtension(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      final dotIndex = path.lastIndexOf('.');
      if (dotIndex != -1) {
        return path.substring(dotIndex);
      }
      return '.pdf'; // default extension
    } catch (e) {
      return '.pdf';
    }
  }

  // Show dialog to open downloaded file
  void _showOpenFileDialog(String filePath, String fileName) {
    Get.defaultDialog(
      title: 'Download Complete',
      content: Column(
        children: [
          Text('$fileName downloaded successfully'),
          SizedBox(height: 20.h),
          Text('Do you want to open the file?'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('NO'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            _openFile(filePath);
          },
          child: const Text('OPEN'),
        ),
      ],
    );
  }

  // Open downloaded file
  Future<void> _openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      print('Open file result: ${result.message}');
    } catch (e) {
      Get.snackbar(
        'Cannot Open File',
        'Make sure you have an app that can open this file type',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}