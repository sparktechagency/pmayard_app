import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/time_slot_model.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/assigned/assigned_professional_model_data.dart';
import 'package:pmayard_app/models/assigned/assigned_response_data.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';
import 'package:timeago/timeago.dart';

class AssignedController extends GetxController {

  final assignedParentData = <AssignedParentModelData>[].obs;
  final assignedProfessionalData = <AssignedProfessionalModelData>[].obs;
  final isLoadingAssigned = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Removed automatic API call from onInit to prevent duplicate calls
    // The UI will handle calling getAssigned() explicitly
  }

  Future<void> getAssigned() async {
    final userController = Get.find<UserController>();
    String role = userController.user?.role ?? '';

    // Wait if role is not loaded yet
    if (role.isEmpty) {
      // Wait a bit for the user data to load
      await Future.delayed(Duration(milliseconds: 100));
      role = userController.user?.role ?? '';
    }

    assignedParentData.clear();
    assignedProfessionalData.clear();
    isLoadingAssigned.value = true;

    try {
      final response = await ApiClient.getData(ApiUrls.assigned);

      if (response.statusCode == 200) {
        final List data = response.body['data'] ?? [];
        if(role == 'professional'){
          final professional = data.map((item) => AssignedProfessionalModelData.fromJson(item)).toList();
          print('professional Data 31 no line ========================================> professional');
          assignedProfessionalData.assignAll(professional);
        }else{
          final parent = data.map((item) => AssignedParentModelData.fromJson(item)).toList();
          assignedParentData.assignAll(parent);
        }
      }
    } catch (e) {
      print('Error fetching assigned: $e');
    } finally {
      isLoadingAssigned.value = false;
    }
  }

  // Schedule Are fetch here
  bool isScheduleLoading = false;
  List<AvailabilityModel> availabilityData = [];

  List<TimeSlotModel> timeSlotDatas = [];

  List slotsData = [];

  Future<void> fetchAvailabilityData(String scheduleID) async {

    availabilityData.clear();
    isScheduleLoading = true;
    update();

    timeSlotDatas.clear();

    try {
      final response = await ApiClient.getData(ApiUrls.professionalAvailability(scheduleID));

      if (response.statusCode == 200) {

        final List<dynamic> datas = response.body['data']['availability'] ?? [];
        // final List<dynamic> datas = response.body['data'] ?? [];
        // datas.map((e) => print('maruif datadfsafsd ===> $e')).toList();
        print('== ++++++++++++++++++++++++++++++++ $datas');



        for (var dayData in datas) {
          for (var slot in dayData['timeSlots']) {
            // List<AvailabilityModel> items = datas.map((e) => AvailabilityModel.fromJson(e)).toList();
            // timeSlotDatas.addAll(slot);
            // timeSlotDatas.add(slot);
            final items = TimeSlotModel.fromJson(slot);
            timeSlotDatas.add(items);
            print('sloooooooooooooooottttttttttttt============> $slot');
          }
        }


        // print('this is 70 no line ${items}');


        // availabilityData.addAll(items);

        // availabilityData.map((e)=> print(e.timeSlots));

        // print('== ++++++++++++++++++++++++++++++++ 70 $maruf');
        // final maruf = datas.map((e) => AvailabilityModel.fromJson(e)).toList();
        // availabilityData.addAll(maruf);

        // print('=-=====================================> Maruf Maruf Maruf $maruf');

        // availabilityData.addAll(maruf);
        // final item = availabilityData.addAll(datas);

        // THIS IS THE ONLY LINE THAT MATTERS - ASSIGN THE DATA
        // availabilityData = datas.map((e) => AvailabilityModel.fromJson(e)).toList();

        print('✅ Loaded ${timeSlotDatas.length} days of availability');
      } else {
        availabilityData = [];
        showToast('Something Went Wrong');
      }
    } catch (e) {
      print('❌ Error: $e');
      availabilityData = [];
      showToast('Error loading data');
    }

    isScheduleLoading = false;
    update();
  }

  // Schedule Related work are here
  bool isScheduleUpdateLoader = false;
  Future<void>editAvailabilityScheduleHandler(String availabilityID) async{
    isScheduleUpdateLoader = true;
    update();
    final request = {

    };

    final response = await ApiClient.patch(ApiUrls.editAvailabilitySchedule(availabilityID), request);
    if( response.statusCode == 200 ){
      Get.offNamed(AppRoutes.customBottomNavBar);
    }else{
      showToast('Something went wrong Please Try Again');
    }
  }



  // Set Schedule Related Work are here
  bool isConfirmScheduleLoading = false;
  DateTime scheduleDate = DateTime.now();
  late String date = scheduleDate.toIso8601String().split('T')[0];

  Map<String,String>? timeSlot;
  void dataOnchangeHandler(){
    scheduleDate;
    update();
  }

  Future<void>confirmSchedule( String userID ) async {
    isConfirmScheduleLoading = true;
    update();

    final reqBody = {
      "date" : date,
      "time" : timeSlot
    };
    print('maruf =========> $reqBody');
    // final response = await ApiClient.postData( ApiUrls.confirmSchedule(userID), reqBody );
    // if( response.statusCode == 200 ){
    //   Get.offNamed(AppRoutes.customBottomNavBar);
    // }else{
    //   showToast('Something Went Wrong');
    // }

    isConfirmScheduleLoading = false;
    update();
  }
}
