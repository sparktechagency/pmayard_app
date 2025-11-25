import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/legal/legal_controller.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';

import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LegalController>(
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppBar(
              title: controller.privacyPolicyDataModel?.title ?? '',
              borderColor: AppColors.secondaryColor,
            ),

            body: controller.isPrivacyPolicyLoading
                ? CustomLoader()
                : Padding(
              padding: EdgeInsets.all(20.r),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Color(0XFFF9F9F9),
                  border: Border.all(color: Color(0XFFC2B067)),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: HtmlWidget(controller.privacyPolicyDataModel?.content ?? ''),
              ),
            ),
          );
        }
    );
  }
}
