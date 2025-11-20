import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pmayard_app/app/helpers/menu_show_helper.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/profile_confirm_controller.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/custom_assets/fonts.gen.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/widgets/multiple_selection.dart';
import 'package:pmayard_app/widgets/widgets.dart';

class CompleteProfileFirstPage extends StatefulWidget {
  const CompleteProfileFirstPage({super.key});

  @override
  State<CompleteProfileFirstPage> createState() => _CompleteProfileFirstPageState();
}

class _CompleteProfileFirstPageState extends State<CompleteProfileFirstPage> {

  final ProfileConfirmController profileController = Get.find<
      ProfileConfirmController>();


  final TextEditingController _qualificationController = TextEditingController();
  final List<String> subjectList = [];
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  PhoneNumber number = PhoneNumber(isoCode: 'US');


  File? _image;
  String selected = MenuShowHelper.subjects.first;

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
                  fileImage: _image,
                  radius: 60.r,
                  image: '',
                ),

                Positioned(
                  bottom: 12.h,
                  right: 6.w,
                  child: GestureDetector(
                    onTap: (){
                      PhotoPickerHelper.showPicker(context: context, onImagePicked: (image){
                        _image = File(image.path);
                        setState(() {
                        });

                      });
                    },
                      child: Assets.icons.profileCamera.svg()),
                )

              ],
            ),
            CustomText(text: 'Upload Photo',color: AppColors.secondaryColor,fontSize: 12.sp,top: 4.h,),
            Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  CustomTextField(
                    labelText: 'Name',
                    controller: profileController.nameController,
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
                      fontSize: 12.sp,
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
                    textFieldController: profileController.numberController,
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
                    selectorButtonOnErrorPadding: 0,
                    spaceBetweenSelectorAndTextField: 0,
                  ),

                  CustomTextField(
                    labelText: 'Bio',
                    controller: profileController.bioController,
                    hintText: "Enter Bio",
                  ),
                  CustomTextField(
                    labelText: 'Qualification',
                    controller: profileController.qualificationController,
                    hintText: "Enter qualification",
                  ),
                  Text(
                    'Subjects You Teach',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),),
                  SizedBox(height: 8.h,),
                  // CustomTextField(
                  //   hintText: 'Select Subjects',
                  //   labelText: 'Subjects you Teach',
                  //   controller: _qualificationController,
                  //   readOnly: true,
                  //
                  // ),
                  GestureDetector(
                    onTap: _showMultiSelectionSubject,
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3)
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Select Subjects',style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.withOpacity(0.9)
                      ),),
                    ),
                  ),
                  // Select Subjects

                  // DropdownButton(
                  //   onChanged: (value){
                  //       selected == value;
                  //       onTapSubjectAdded(value!);
                  //   },
                  //     value: selected,
                  //     items: MenuShowHelper.subjects.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList()
                  // ),


                  // GestureDetector(
                  //   onTapDown: (TapDownDetails details) async {
                  //     final selected = await MenuShowHelper.showCustomMenu(
                  //       context: context,
                  //       details: details,
                  //       options: MenuShowHelper.subjects,
                  //     );
                  //     if (selected != null) {
                  //       setState(() {
                  //         _subjectsController.text = selected;
                  //       });
                  //     }
                  //   },
                  //   child: AbsorbPointer(
                  //     child: CustomTextField(
                  //       suffixIcon: Icon(Icons.keyboard_arrow_down),
                  //       readOnly: true,
                  //       labelText: 'Subjects You Teach',
                  //       controller: _subjectsController,
                  //       hintText: "Subjects You Teach",
                  //     ),
                  //   ),
                  // ),
                  //

                  // SizedBox(
                  //   height: 100, // must add height
                  //   child: ListView.builder(
                  //       itemCount: AppSubjectList.allSubjects.length,
                  //       itemBuilder: (context, index) {
                  //         return GestureDetector(
                  //           child: Text(AppSubjectList.allSubjects[index]),
                  //           onTap: ( ) => onTapSubjectAdded(AppSubjectList.allSubjects[index]),
                  //         );
                  //       }
                  //   ),
                  // ),
                  SizedBox(height: 20.h,),
                  CustomButton(
                    label: "Next",
                    onPressed: (){
                      if (!_globalKey.currentState!.validate()) return;
                      Get.toNamed(AppRoutes.scheduleScreen);
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

  // subject added list
  void onTapSubjectAdded(String subName) {
    profileController.subjectList.add(subName);
  }

  void _showMultiSelectionSubject() async {
    final List<String> subjectsList = MenuShowHelper.subjects;
    List<String>selectedSubject = [];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultipleSelection(
          items: subjectsList, selectedSubject: selectedSubject,);
      },
    );

    if (results != null) {
      selectedSubject = results;
    }
    print(selectedSubject);
  }
}
