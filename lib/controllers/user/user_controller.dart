import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/models/user_model/user_data_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class UserController extends GetxController {
  @override
  void onInit() {
    userData();
    super.onInit();
  }

  /// ========================>>> user data controller =======================>>>
  UserModelData? user;
  bool isUserDataComing = false;

  Future<void> userData() async {
    isUserDataComing = true;
    update();

    final response = await ApiClient.getData(ApiUrls.userData);
    if (response.statusCode == 200) {
      user = UserModelData.fromJson(response.body['data']);
    }
    isUserDataComing = false;
    update();
  }
  /// ========================>>> profile edit controller =======================>>>
  late TextEditingController emailController = TextEditingController(
    text: user?.email ?? '',
  );
  late TextEditingController nameController = TextEditingController(
    text: user!.roleId?.name ?? '',
  );
  late TextEditingController bioController = TextEditingController(
    text: user!.roleId?.bio ?? '',
  );

  late TextEditingController phoneController = TextEditingController(
    text: user!.roleId?.phoneNumber ?? '',
  );
  File? selectedImage;

  late TextEditingController subjectsController = TextEditingController(
    text: user?.roleId?.subjects?.map((s) => s).join(', ') ?? '',
  );

  final List<String> subjectList = [];
  List<Map<String, dynamic>> availability = [];
  DateTime? selectedDate;

  void onTapImageShow(context) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (image) {
        selectedImage = File(image.path);
        update();
      },
    );
  }

  /// Update Profile related work are here
  bool isProfileUpdateLoader = false;

  Future<void> profileUpdate() async {
    isProfileUpdateLoader = true;
    update();

    List<MultipartBody>? multipartBody;
    if (selectedImage != null) {
      multipartBody = [MultipartBody('image', selectedImage ?? File(''))];
    }

    final requestBody = {
      'data': jsonEncode({
        'name': nameController.text.trim(),
        'bio': bioController.text.trim(),
        'subjects': subjectList,
      }),
    };

    final response = await ApiClient.patchMultipartData(
      ApiUrls.editProfile,
      requestBody,
      multipartBody: multipartBody,
    );

    if (response.statusCode == 200) {
      Get.back();
      Get.find<UserController>().userData();
    } else {
      showToast('Something Went Wrong');
    }

    isProfileUpdateLoader = false;
    update();
  }
}
