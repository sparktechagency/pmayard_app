import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
import 'package:pmayard_app/widgets/custom_loader.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

import '../../app/helpers/menu_show_helper.dart';
import '../../custom_assets/assets.gen.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_avatar.dart';
import '../../widgets/custom_text_field.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _userController = Get.find<UserController>();
  late final user = _userController.user;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: user!.role == 'parent' ? 'Edit Information' : 'Personal Info',
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            GetBuilder<UserController>(
              builder: (controller) {
                return Stack(
                  children: [
                    CustomImageAvatar(
                      radius: 44.r,
                      image: controller.user?.roleId?.profileImage ?? '',
                      fileImage: controller.selectedImage,
                    ),
                    Positioned.fill(
                      child: CustomContainer(
                        onTap: () => controller.onTapImageShow(context),
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                        child: Padding(
                          padding: EdgeInsets.all(32.r),
                          child: Assets.icons.cameraAdd.svg(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 32.h),
                  CustomTextField(
                    readOnly: true,
                    labelText: 'Email',
                    controller: _userController.emailController,
                    hintText: '',
                    isEmail: true,
                  ),
                  CustomTextField(
                    labelText: 'Name',
                    controller: _userController.nameController,
                    hintText: '',
                  ),
                  if( user!.role == 'professional')...[
                    CustomTextField(
                      labelText: 'Bio maruf',
                      controller: _userController.bioController,
                      hintText: '',
                    )
                  ],

                  if( user!.role == 'parent')...[
                    CustomTextField(
                      labelText: 'Phone',
                      controller: _userController.phoneController,
                      hintText: '',
                    )
                  ],


                  // Multiple Subject Related work are here
                  if( user!.role == 'professional')...[
                    GestureDetector(
                      onTapDown: (TapDownDetails details) async {
                        final currentSubjects = _userController
                            .subjectsController
                            .text
                            .split(", ")
                            .where((s) => s.isNotEmpty)
                            .toList();

                        final selectedList =
                        await MenuShowHelper.showMultiSelectMenu(
                          context: context,
                          details: details,
                          options: MenuShowHelper.subjects,
                          preSelectedItems: currentSubjects,
                        );

                        if (selectedList != null) {
                          _userController.subjectsController.text = selectedList
                              .join(", ");

                          _userController.subjectList
                            ..clear()
                            ..addAll(selectedList);
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          readOnly: true,
                          labelText: 'Subjects You Teach',
                          controller: _userController.subjectsController,
                          hintText: "Subjects You Teach",
                        ),
                      ),
                    ),
                  ],


                  SizedBox(height: 60.h),
                  GetBuilder<UserController>(
                    builder: (controller) {
                      return controller.isProfileUpdateLoader
                          ? CustomLoader()
                          : CustomButton(label: "Update", onPressed: () {
                        if (!_globalKey.currentState!.validate()) return;
                        controller.profileUpdate();
                      });
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
