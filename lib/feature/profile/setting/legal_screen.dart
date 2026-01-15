import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/legal/legal_controller.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  final controller = Get.find<LegalController>();

  late final String title;
  @override
  void initState() {
    super.initState();
    title = Get.arguments?['title'] ?? 'Legal Contract';

    controller.getLegalController(
      url: Get.arguments["title"] == "Terms & Conditions"
          ? "/terms"
          : Get.arguments["title"] == "Privacy Policy"
          ? "/privacy"
          : "/about",
    );
  }

  @override
  void dispose() {
    controller.valueText.value = "";
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   title = Get.arguments?['title'] ?? 'Legal Contract';
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LegalController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: title,
            borderColor: AppColors.secondaryColor,
          ),
          body: controller.legalControllerLoading.value
              ? const CustomLoader()
              : Padding(
            padding: EdgeInsets.all(20.r),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0XFFF9F9F9),
                border: Border.all(color: const Color(0XFFC2B067)),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: HtmlWidget(
                controller.valueText.value.toString(),
              ),
            ),
          ),
        );

      },
    );
  }
}
