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
          // Show loading indicator
          if (controller.isLoadingMaterial) {
            return Center(child: CircularProgressIndicator());
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

          // Show list
          return ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10.h),
            itemCount: controller.metarialsModel.length,
            itemBuilder: (context, index) {
              final material = controller.metarialsModel[index];
              return ResourceGradeWidget(
                title: material.title ?? 'Untitled',
                downloader: () {
                  final fileUrl = material.fileUrl?.url;
                  if (fileUrl != null && fileUrl.isNotEmpty) {
                    _downloadFile(fileUrl, material.title ?? 'file');
                  } else {
                    showToast("File URL not available");
                  }
                },
                icon: Icons.download,
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
          );
        },
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
          child: Text('NO'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            _openFile(filePath);
          },
          child: Text('OPEN'),
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