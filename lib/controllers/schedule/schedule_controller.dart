import 'package:get/get.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class ScheduleController extends GetxController {


  bool isLoading = false;




  Future<void> editSchedule(String roleID,Map<String,dynamic> body) async {
    isLoading = true;
    update();



    final response = await ApiClient.patch(
      ApiUrls.editSchedule(roleID),
      body,
    );
    final responseBody = response.body;
    if (response.statusCode == 200) {
      Get.back();
      Get.find<UserController>().userData();
    } else {
      showToast(responseBody['message']);
    }

    isLoading = false;
    update();
  }

}