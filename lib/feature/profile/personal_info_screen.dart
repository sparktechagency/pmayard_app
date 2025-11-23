import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
import 'package:pmayard_app/widgets/custom_network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: 'General Information Maruf',
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Stack(
              children: [
                _userController.selectedImage != null
                    ? Image.file(
                        _userController.selectedImage! as File, // <-- correct
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.cover,
                      )
                    : _userController.user?.roleId?.profileImage != null
                    ? CustomNetworkImage(
                        imageUrl:
                            _userController.user?.roleId?.profileImage ?? '',
                        height: 80.h,
                        width: 80.w,
                        borderRadius: 44.r,
                      )
                    : CustomImageAvatar(radius: 44.r, image: ''),

                // CustomImageAvatar(
                //   radius: 44.r,
                //   image:  _userController.user?.roleId?.profileImage,
                // ),
                Positioned.fill(
                  child: CustomContainer(
                    onTap: () {
                      PhotoPickerHelper.showPicker(
                        context: context,
                        onImagePicked: (image) {
                          _userController.selectedImage = image;
                        },
                      );
                    },
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                    child: Padding(
                      padding: EdgeInsets.all(32.r),
                      child: Assets.icons.cameraAdd.svg(),
                    ),
                  ),
                ),
              ],
            ),
            Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 32.h),
                  CustomTextField(
                    labelText: 'Email',
                    controller: _userController.emailController,
                    hintText: _userController.user?.email,
                    isEmail: true,
                  ),
                  CustomTextField(
                    labelText: 'Name',
                    controller: _userController.nameController,
                    hintText: _userController.user?.roleId?.name,
                  ),
                  CustomTextField(
                    labelText: 'Bio',
                    controller: _userController.bioController,
                    hintText: '',
                  ),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) async {
                      final selected = await MenuShowHelper.showCustomMenu(
                        context: context,
                        details: details,
                        options: MenuShowHelper.subjects,
                      );
                      if (selected != null) {
                        setState(() {
                          _userController.subjectsController.text = selected;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        readOnly: true,
                        labelText: 'Subjects You Teach',
                        controller: _userController.subjectsController,
                        // hintText: "Subjects You Teach",
                      ),
                    ),
                  ),

                  SizedBox(height: 60.h),
                  CustomButton(label: "Update", onPressed: _onUpdate),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdate() {
    if (!_globalKey.currentState!.validate()) return;
    // Get.offAllNamed(AppRoutes.resetPasswordSuccess);
  }
}
