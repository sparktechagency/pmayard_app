import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmayard_app/models/user_model/user_data_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class UserController extends GetxController {


  UserDataModel? user;

  bool isUserDataComing = false;


  @override
  void onInit() {
    userData();
    update();
    super.onInit();
  }

  Future<void> userData() async {
    isUserDataComing = true;
    update();

    final response = await ApiClient.getData(ApiUrls.userData);
    if (response.statusCode == 200) {
      user = UserDataModel.fromJson(response.body['data']);
    }
    isUserDataComing = false;
    update();
  }

  late TextEditingController emailController = TextEditingController( text:  user?.email ?? '');
  late TextEditingController nameController = TextEditingController( text: user!.roleId?.name ?? '');
  late TextEditingController bioController = TextEditingController( text: user!.roleId?.bio ?? '');
  late TextEditingController subjectsController = TextEditingController( text: user!.roleId?.name ?? '');
  XFile? selectedImage;
}