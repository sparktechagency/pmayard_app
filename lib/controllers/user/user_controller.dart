import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/models/user_model/user_data_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

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

  late TextEditingController emailController = TextEditingController( text:  user?.email ?? '');
  late TextEditingController nameController = TextEditingController( text: user!.roleId?.name ?? '');
  late TextEditingController bioController = TextEditingController( text: user!.roleId?.bio ?? '');
  late TextEditingController subjectsController = TextEditingController( text: user!.roleId?.name ?? '');
  File? selectedImage;

  void onTapImageShow (context) {
  PhotoPickerHelper.showPicker(
  context: context,
  onImagePicked: (image) {
  selectedImage = File(image.path);
  update();
  },
  );
}
}