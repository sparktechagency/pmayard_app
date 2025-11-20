import 'package:get/get.dart';
import 'package:pmayard_app/models/user_model/user_data_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class UserController extends GetxController {
  UserDataModel? user;

  bool isUserDataComing = false;
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
}
