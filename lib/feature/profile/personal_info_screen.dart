import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_container.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _subjectsController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        borderColor: AppColors.secondaryColor,
        title: 'General Information',
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Stack(
              children: [
                CustomImageAvatar(
                  radius: 44.r,
                  image: '',
                ),

                Positioned.fill(
                  child: CustomContainer(
                    onTap: (){
                      PhotoPickerHelper.showPicker(context: context, onImagePicked: (image){});
                    },
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                    child: Padding(
                      padding:  EdgeInsets.all(32.r),
                      child: Assets.icons.cameraAdd.svg(),
                    ),
                  ),
                )

              ],
            ),
            Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  CustomTextField(
                    labelText: 'Email',
                    controller: _emailController,
                    hintText: "Enter Email",
                    isEmail: true,
                  ),
                  CustomTextField(
                    labelText: 'Name',
                    controller: _nameController,
                    hintText: "Enter Name",
                  ),
                  CustomTextField(
                    labelText: 'Bio',
                    controller: _bioController,
                    hintText: "Enter Bio",
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
                          _subjectsController.text = selected;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        readOnly: true,
                        labelText: 'Subjects You Teach',
                        controller: _subjectsController,
                        //hintText: "Subjects You Teach",
                      ),
                    ),
                  ),
        
                  SizedBox(height: 60.h,),
                  CustomButton(
                    label: "Update",
                    onPressed: _onUpdate,
                  ),
                  SizedBox(
                    height:24.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdate(){
    if(!_globalKey.currentState!.validate()) return;
    // Get.offAllNamed(AppRoutes.resetPasswordSuccess);
  }
}
