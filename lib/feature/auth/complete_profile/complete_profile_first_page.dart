import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pmayard_app/app/helpers/menu_show_helper.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/custom_assets/fonts.gen.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

import '../../../widgets/widgets.dart';

class CompleteProfileFirstPage extends StatefulWidget {
  const CompleteProfileFirstPage({super.key});

  @override
  State<CompleteProfileFirstPage> createState() => _CompleteProfileFirstPageState();
}

class _CompleteProfileFirstPageState extends State<CompleteProfileFirstPage> {


  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _subjectsController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  PhoneNumber number = PhoneNumber(isoCode: 'US');

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Complete Your Profile',
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Stack(
              children: [
                CustomImageAvatar(
                  radius: 60.r,
                  image: '',
                ),

                Positioned(
                  bottom: 8.h,
                  right: 0,
                  child: Assets.icons.profileCamera.svg(),
                )

              ],
            ),
            CustomText(text: 'Upload Photo',color: AppColors.secondaryColor,fontSize: 12.sp,top: 4.h,),
            Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  CustomTextField(
                    labelText: 'Name',
                    controller: _nameController,
                    hintText: "Enter Name",
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Phone',
                      color: AppColors.darkColor,
                      bottom: 4.h,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),


                  InternationalPhoneNumberInput(
                    selectorTextStyle: TextStyle(
                      fontSize: 12.sp, // ছোট font size
                    ),
                    onInputChanged: (PhoneNumber num) {
                      print("Changed: ${num.phoneNumber}");
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                      setSelectorButtonAsPrefixIcon: true,
                      leadingPadding: 0,
                      trailingSpace: false,
                    ),
                    cursorColor: Colors.black,
                    textFieldController: _numberController,
                    initialValue: number,
                    formatInput: true,
                    inputDecoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: AppColors.appGreyColor,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.inter,
                      ),
                      hintText: "enter your phone no.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular( 8.r),
                        borderSide:
                        BorderSide(color: AppColors.grayShade100.withOpacity(0.2), width: 1),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    selectorButtonOnErrorPadding: 0, // flag আর text এর মাঝে কম gap
                    spaceBetweenSelectorAndTextField: 0, // spacing কমানো
                  ),



                  CustomTextField(
                    labelText: 'Bio',
                    controller: _bioController,
                    hintText: "Enter Bio",
                  ),
                  CustomTextField(
                    labelText: 'Qualification',
                    controller: _qualificationController,
                    hintText: "Enter qualification",
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
                    label: "Next",
                    onPressed: (){
                      if (!_globalKey.currentState!.validate()) return;

                    },
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
}
