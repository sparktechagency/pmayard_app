import 'package:get/get.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/time_slot_model.dart';
import 'package:pmayard_app/models/assigned/assign_model.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class AssignedController extends GetxController {
  // Assigned Data Are here
  final isLoadingAssigned = false.obs;
  final RxList<AssignModel> assignModel = <AssignModel>[].obs;
  final RxList<Map<String, dynamic>> parentList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> professionalList =
      <Map<String, dynamic>>[].obs;

  Future<void> getAssigned() async {
    assignModel.clear();
    parentList.clear();
    professionalList.clear();
    isLoadingAssigned.value = true;
    update();

    try {
      final response = await ApiClient.getData(ApiUrls.assigned);

      if (response.statusCode == 200) {
        final List<dynamic> datas = response.body['data'] ?? [];

        for (var item in datas) {
          assignModel.add(AssignModel.fromJson(item));
          parentList.add(item['parent']);
          professionalList.add(item['professional']);
        }
      }
    } catch (e) {
      print("❌ Error Assigned: $e");
    } finally {
      isLoadingAssigned.value = false;
      update();
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
      final response = await ApiClient.getData(
        ApiUrls.professionalAvailability(scheduleID),
      );

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

  Future<void> editAvailabilityScheduleHandler(String availabilityID) async {
    isScheduleUpdateLoader = true;
    update();
    final request = {};

    final response = await ApiClient.patch(
      ApiUrls.editAvailabilitySchedule(availabilityID),
      request,
    );
    if (response.statusCode == 200) {
      Get.offNamed(AppRoutes.customBottomNavBar);
    } else {
      showToast('Something went wrong Please Try Again');
    }
  }

  // Set Schedule Related Work are here
  bool isConfirmScheduleLoading = false;
  DateTime scheduleDate = DateTime.now();
  late String date = scheduleDate.toIso8601String().split('T')[0];

  Map<String, String>? timeSlot;

  void dataOnchangeHandler() {
    scheduleDate;
    update();
  }

  Future<void> confirmSchedule(String userID) async {
    isConfirmScheduleLoading = true;
    update();

    final reqBody = {"date": date, "time": timeSlot};
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
