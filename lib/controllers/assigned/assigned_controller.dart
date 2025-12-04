import 'package:get/get.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/time_slot_model.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
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
  final RxList<Map<String, dynamic>> professionalList = <Map<String, dynamic>>[].obs;

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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('*************************************************');
    print('*************************************************');
    print('*************************************************');
    print(timeSlotDatas.length);
  }

  // Schedule Are fetch here
  final RxBool isScheduleLoading = false.obs;
  final RxList<AvailabilityModel> availabilityData = <AvailabilityModel>[].obs;
  final List<TimeSlotModel> timeSlotDatas = <TimeSlotModel>[];

  final RxList slotsData = [].obs;

  Future<void> fetchAvailabilityData(String scheduleID) async {
    availabilityData.clear();
    isScheduleLoading.value = true;
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

            // timeSlotDatas.clear();

            timeSlotDatas.add(items);

            print(
              '///////////////////////////////////////////////////////////////////////',
            );
            print(timeSlotDatas.length);
            print(timeSlotDatas.first.startTime);
            print(timeSlotDatas.first.endTime);

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

        // print('✅ Loaded ${timeSlotDatas.length} days of availability');
      } else {
        // availabilityData = [];
        if( response.statusCode == 404 ){
          Get.toNamed(AppRoutes.notFoundScreen);
        }
        showToast('=========   ${response.status}  ==== Something Went Wrong');
      }
    } catch (e) {
      print('❌ Error: $e');
      // availabilityData = [];
      showToast('Error ');
    }

    isScheduleLoading.value = false;
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
  RxString? startTime = ''.obs;
  RxString? endTime = ''.obs;

  Map<String, String>? timeSlot;

  void dataOnchangeHandler() {
    scheduleDate;
    timeSlot = {"startTime": startTime!.value, "endTime": endTime!.value};

    update();
  }

  Future<void> confirmSchedule({String sessionID = ''}) async {

    final String userID = Get.find<UserController>().user?.sId ?? '';

    print("===================>>>>> $userID");

    // print("=====================================   $userID  ====================== Assigned Controller 171 no line ");
    // isConfirmScheduleLoading = true;
    // update();
    //

    final reqBody = {"date": date, "time": timeSlot};
    print('maruf =========> $reqBody');


    final response = await ApiClient.postData(
      ApiUrls.confirmSchedule(userID),
      reqBody,
    );

    if (response.statusCode == 200) {
      Get.offNamed(AppRoutes.customBottomNavBar);
    } else {
      showToast('Something Went Wrong');
    }

    isConfirmScheduleLoading = false;
    update();
  }
}
