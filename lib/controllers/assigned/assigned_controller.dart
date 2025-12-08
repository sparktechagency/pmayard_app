import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/models/time_slot_model.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/assigned/assign_model.dart';
import 'package:pmayard_app/models/assigned/assign_view_profile_model.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

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
         final List  data = responseBody['data'];
         final  assign = data.map((e) => AssignModelData.fromJson(e)).toList();
        assignModel.addAll(assign);
        }else{
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

   // Variables
   DateTime? selectedDate;
   List<TimeSlots> allTimeSlots = []; // সব সময়ের সব স্লট

   // Selected time slot
   String? startTime;
   String? endTime;

   // Loading states
   bool isConfirmScheduleLoading = false;

   // Data
   AssignViewProfileModel? profileData;

   @override
   void onInit() {
     super.onInit();
     initializeData();
   }

   void initializeData() {
     if (Get.arguments != null && Get.arguments is AssignViewProfileModel) {
       profileData = Get.arguments as AssignViewProfileModel;
       loadAllTimeSlots(); // শুধু একবার লোড করবে
     }
   }

   void loadAllTimeSlots() {
     allTimeSlots.clear();

     final availability = profileData?.professional?.availability ?? [];

     // সব ডে এর সব স্লট একসাথে নাও
     for (var dayAvailability in availability) {
       if (dayAvailability.timeSlots != null) {
         allTimeSlots.addAll(dayAvailability.timeSlots!);
       }
     }

     update();
   }

   void setSelectedDate(DateTime date) {
     selectedDate = date;
     update(); // শুধু ডেট আপডেট, স্লট ফিল্টার না
   }

   void selectTimeSlot(String start, String end) {
     startTime = start;
     endTime = end;
     update();
   }

   bool isTimeSlotSelected(String start, String end) {
     return startTime == start && endTime == end;
   }

   void clearSelection() {
     startTime = null;
     endTime = null;
     update();
   }

   bool get hasSelectedTimeSlot {
     return startTime != null && endTime != null;
   }

   bool get hasSelectedDate {
     return selectedDate != null;
   }

   Future<void> confirmSchedule({String sessionID = ''}) async {
     if (!hasSelectedDate) {
       showToast('Please select a date');
       return;
     }

     if (!hasSelectedTimeSlot) {
       showToast('Please select a time slot');
       return;
     }

     isConfirmScheduleLoading = true;
     update();

     try {
       final formattedDate = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

       final reqBody = {
         "date": formattedDate,
         "time": {
           "startTime": startTime,
           "endTime": endTime
         }
       };

       final response = await ApiClient.postData(
         ApiUrls.confirmSchedule(sessionID),
         reqBody,
       );

       if (response.statusCode == 200) {
         showToast('Schedule confirmed successfully');
         selectedDate = null;
         startTime = null;
         endTime = null;
         Get.back(result: true);
       } else {
         showToast('Failed to confirm schedule');
       }
     } catch (e) {
       showToast('An error occurred: $e');
     } finally {
       isConfirmScheduleLoading = false;
       update();
     }
   }
}
