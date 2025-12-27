import 'package:get/get.dart';
import 'package:pmayard_app/models/notification/notification_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class NotificationController extends GetxController{
  @override
  void onInit(){
    super.onInit();
    fetchNotificationData();
  }
  RxBool isLoadingNotification = false.obs;
  RxList notificationModelData = <NotificationModel>[].obs;

  Future<void> fetchNotificationData() async {
    isLoadingNotification.value = true;
    notificationModelData.clear();
    update();

    try{
      final response = await ApiClient.getData(ApiUrls.notification);

      if( response.statusCode == 200 ){
        final data = response.body['data']['result'] ?? [];
        final items = data.map((e) => NotificationModel.fromJson(e)).toList();
        notificationModelData.addAll(items);

      }else{
       // showToast('Something went wrong');
      }
    }catch(e){
     // showToast('Something Went Wrong $e');
    }

    isLoadingNotification.value = false;
    update();
  }
}