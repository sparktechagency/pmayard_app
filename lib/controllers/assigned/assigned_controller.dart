import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/time_slot_model.dart';
import 'package:pmayard_app/models/assigned/assign_model.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

import '../../models/assigned/assign_view_profile_model.dart';

class AssignedController extends GetxController {
  bool isLoadingAssigned = false;
  final List<AssignModelData> assignModel = [];

  Future<void> getAssigned() async {
    assignModel.clear();
    isLoadingAssigned = true;
    update();

    final response = await ApiClient.getData(ApiUrls.assigned);

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'];
      final assign = data.map((e) => AssignModelData.fromJson(e)).toList();
      assignModel.addAll(assign);
    } else {
      debugPrint('${responseBody['message']}');
    }
    isLoadingAssigned = false;
    update();
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

        for (var dayData in datas) {
          for (var slot in dayData['timeSlots']) {
            final items = TimeSlotModel.fromJson(slot);

            timeSlotDatas.add(items);
          }
        }
      } else {}
    } catch (e) {
      print('❌ Error: $e');
      showToast('Error ');
    }

    isScheduleLoading.value = false;
    update();
  }

// Add these properties to your AssignedController class
  String selectedDate = '';
  TimeSlots? selectedTimeSlot;
  bool isConfirmScheduleLoading = false;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

// Initialize schedule screen
  void initScheduleScreen() {
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    selectedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    selectedTimeSlot = null;
  }

// Handle day selection
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    selectedDate = DateFormat('yyyy-MM-dd').format(selected);
    selectedTimeSlot = null;
    update();
  }

// Handle time slot selection
  void onTimeSlotSelected(TimeSlots slot) {
    selectedTimeSlot = slot;
    update();
  }

// Get current day name
  String getCurrentDayName() {
    return DateFormat('EEEE').format(selectedDay);
  }

// Get time slots for specific day
  List<TimeSlots> getTimeSlotsForDay(String dayName, AssignViewProfileModel? profileData) {
    final availability = profileData?.professional?.availability ?? [];
    final dayAvailability = availability.firstWhere(
          (a) => a.day?.toLowerCase() == dayName.toLowerCase(),
      orElse: () => Availability(),
    );
    return dayAvailability.timeSlots ?? [];
  }

// Updated confirmSchedule method
  Future<void> confirmSchedule({String sessionID = ''}) async {
    if (selectedTimeSlot == null) {
      showToast('Please select a time slot');
      return;
    }

    isConfirmScheduleLoading = true;
    update();

    final reqBody = {
      "date": selectedDate,
      "time": {
        "startTime": selectedTimeSlot?.startTime ?? '',
        "endTime": selectedTimeSlot?.endTime ?? ''
      },
    };

    try {
      final response = await ApiClient.postData(
        ApiUrls.confirmSchedule(sessionID),
        reqBody,
      );

      if (response.statusCode == 200) {
        showToast('Schedule confirmed successfully');
        Get.back();
      } else {
        showToast('Failed to confirm schedule');
      }
    } catch (e) {
      showToast('Error: ${e.toString()}');
    } finally {
      isConfirmScheduleLoading = false;
      update();
    }
  }
}
