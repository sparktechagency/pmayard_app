import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/assigned/assigned_professional_model_data.dart';
import 'package:pmayard_app/models/assigned/assigned_response_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class AssignedController extends GetxController {

  List<AssignedParentModelData> assignedParentData = [];
  List<AssignedProfessionalModelData> assignedProfessionalData = [];
  bool isLoadingAssigned = false;

  Future<void> getAssigned() async {
    final role = Get.find<UserController>().user?.role ?? '';
    assignedParentData.clear();
    assignedProfessionalData.clear();
    isLoadingAssigned = true;
    update();

    final response = await ApiClient.getData(ApiUrls.assigned);

    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];
      if(role == 'professional'){
        final professional = data.map((item) => AssignedProfessionalModelData.fromJson(item)).toList();
        assignedProfessionalData.addAll(professional);
      }else{
        final parent = data.map((item) => AssignedParentModelData.fromJson(item)).toList();
        assignedParentData.addAll(parent);
      }
    }
    isLoadingAssigned = false;
    update();
  }

  // Schedule Are fetch here
  bool isScheduleLoading = false;
  List<AvailabilityModel> availabilityData = [];

  Future<void> fetchAvailabilityData(String scheduleID) async{
    isScheduleLoading = true;
    update();

    final response = await ApiClient.getData(ApiUrls.professionalAvailability(scheduleID));

    if( response.statusCode == 200 ){

      final List<dynamic> datas = response.body['data']['availability'] ?? [];
      if( datas.isNotEmpty ){
          AvailabilityModel availabilityModel = new AvailabilityModel();
          datas.map((e) => AvailabilityModel.fromJson(e)).toList();
        // availabilityData =
        // datas.map((e)=> print(e)).toList();
        datas.map((e)=> print('=================Maruf Maruf Maruf=================================> $e')).toList();
        // print('=================Maruf Maruf Maruf=================================> $datas');
      }
    }else{
      showToast('Something Went Wrong');
    }
    isScheduleLoading = false;
    update();
  }
}
