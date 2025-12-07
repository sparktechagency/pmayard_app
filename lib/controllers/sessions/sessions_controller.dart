import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/session/my_session_parent_model.dart';
import 'package:pmayard_app/models/session/my_session_professional_model.dart';
import 'package:pmayard_app/models/session/session_professional_model_data.dart';
import 'package:pmayard_app/models/session/session_response_data.dart';
import 'package:pmayard_app/models/session/upcomming_session_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class SessionsController extends GetxController {

  // =================  Upcoming Sessions (Using Models) ===============
  final RxList<UpComingSessionModel>upComingSession = <UpComingSessionModel>[].obs;
  final RxList<UpComingSessionModel> upComingSessionParentList = <UpComingSessionModel>[].obs;
  final RxList<UpComingSessionModel> upComingSessionProfessionalList = <UpComingSessionModel>[].obs;
  final isLoadingSession = false.obs;

  // Future<void> getSessions() async {
  //   upComingSession.clear();
  //   upComingSessionParentList.clear();
  //   upComingSessionProfessionalList.clear();
  //   isLoadingSession.value = true;
  //   update();
  //
  //   try {
  //     final response = await ApiClient.getData(ApiUrls.upcomingSessions);
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> datas = response.body['data'] ?? [];
  //       for( var item in datas ){
  //         upComingSession.add(UpComingSessionModel.fromJson(item));
  //         upComingSessionParentList.add(item['parent']);
  //         upComingSessionProfessionalList.add(item['professional']);
  //       }
  //
  //       print('======>>>>>>> Parent $upComingSessionParentList');
  //       print('======>>>>>>> Professional $upComingSessionProfessionalList');
  //     }
  //   } catch (e) {
  //     print('❌ [SESSIONS] Error: $e');
  //   } finally {
  //     isLoadingSession.value = false;
  //     update();
  //   }
  // }

  Future<void> getSessions() async {
    upComingSession.clear();
    upComingSessionParentList.clear();
    upComingSessionProfessionalList.clear();
    isLoadingSession.value = true;
    update();

    try {
      final response = await ApiClient.getData(ApiUrls.upcomingSessions);

      if (response.statusCode == 200) {
        final List<dynamic> datas = response.body['data'] ?? [];
        for (var item in datas) {
          final session = UpComingSessionModel.fromJson(item);
          upComingSession.add(session);
          upComingSessionParentList.add(session);
          upComingSessionProfessionalList.add(session);
        }

        print('======>>>>>>> Sessions: ${upComingSession.length}');
      }
    } catch (e) {
      print('❌ [SESSIONS] Error: $e');
    } finally {
      isLoadingSession.value = false;
      update();
    }
  }

  // =================  MY Sessions (Using Raw Maps - No Models) =====================
  final isLoadingMySection = false.obs;
  final mySessionData = <Map<String, dynamic>>[].obs;

  final mySessionParentData = <MySessionParentModelData>[].obs;
  final mySessionProfessionalData = <MySessionProfessionalModelData>[].obs;

  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rxn<DateTime> selectedDay = Rxn<DateTime>();
  RxString stringDate = ''.obs;

  void onHandle(String date) {
    stringDate.value = date;
    fetchMySection(date);
  }

  Future<void> fetchMySection(String date) async {
    mySessionData.clear();
    mySessionParentData.clear();
    mySessionProfessionalData.clear();

    isLoadingMySection.value = true;
    update();

    try {
      final response = await ApiClient.getData(ApiUrls.sessionSearch(date));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];
        mySessionData.assignAll(data.cast<Map<String, dynamic>>());
        debugPrint('Fetched ${mySessionData.length} my sessions');
      }
    } catch (e) {
      print('Error fetching my sessions: $e');
    } finally {
      isLoadingMySection.value = false;
      update(); // Notify listeners after data is loaded
    }
  }

  // =================  Selected Session =====================
  final isLoadingSelectedSession = false.obs;

  // Future<void> fetchSelectedSession(String date) async {
  //   try {
  //     isLoadingSelectedSession.value = true;
  //     update(); // Notify listeners
  //
  //     final role = Get.find<UserController>().user?.role ?? '';
  //     final response = await ApiClient.getData(ApiUrls.sessionSearch(date));
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.body['data'] ?? [];
  //
  //       // if (role == 'professional') {
  //       //   final professionalData = data
  //       //       .map((e) => SessionProfessionalModelData.fromJson(e))
  //       //       .toList();
  //       //   sessionProfessionalData.assignAll(professionalData);
  //       // } else {
  //       //   final parentData = data
  //       //       .map((e) => SessionParentModelData.fromJson(e))
  //       //       .toList();
  //       //   sessionParentData.assignAll(parentData);
  //       // }
  //     }
  //   } catch (err) {
  //     showToast('Something Went Wrong $err');
  //   } finally {
  //     isLoadingSelectedSession.value = false;
  //     update(); // Notify listeners after data is loaded
  //   }
  // }

  final isLoadingAssignViewProfile = false.obs;
  Map<String, dynamic>? assignViewProfileData;

  AssignViewProfileModel? get assignViewProfileModel {
    if (assignViewProfileData == null) return null;
    return AssignViewProfileModel(
      sId: assignViewProfileData?['_id'] ?? '',
      profileImage: assignViewProfileData?['profileImage'] ?? '',
      name: assignViewProfileData?['name'] ?? '',
      childsName: assignViewProfileData?['childs_name'] ?? '',
      childsGrade: assignViewProfileData?['childs_grade'] ?? '',
      phoneNumber: assignViewProfileData?['phoneNumber'] ?? '',
      user: UserData(
        role: assignViewProfileData?['user']?['role'] ?? '',
        email: assignViewProfileData?['user']?['email'] ?? '',
      ),
    );
  }



  Future<void> fetchAssignViewProfile(String userId) async {
    isLoadingAssignViewProfile.value = true;
    assignViewProfileData?.clear();
    update();

    try {
      final response = await ApiClient.getData(ApiUrls.sessionViewProfile(userId));
      if (response.statusCode == 200) {
        assignViewProfileData = response.body['data'];
        debugPrint('Fetched profile data');
        update();
      } else {
        showToast('Something Went Wrong');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      showToast('Error: $e');
    } finally {
      isLoadingAssignViewProfile.value = false;
    }
  }

  // =================  Complete Session =====================
  final isChangeStatus = false.obs;

  Future<void> completeSessionDBHandler(String userID, String newStatus) async {
    isChangeStatus.value = true;

    try {
      final responseBody = {
        'status': newStatus,
      };

      final response = await ApiClient.patch(
        ApiUrls.completeSession(userID),
        responseBody,
      );

      if (response.statusCode == 200) {
        showToast('Session status updated successfully');
        await fetchMySection('');
        Get.back();
      } else {
        showToast('Failed to update session status');
      }
    } catch (e) {
      print('Error updating session: $e');
      showToast('Error: $e');
    } finally {
      isChangeStatus.value = false;
    }
  }
}

// Simple model classes for compatibility
class AssignViewProfileModel {
  final String sId;
  final String profileImage;
  final String name;
  final String childsName;
  final String childsGrade;
  final String phoneNumber;
  final UserData user;

  AssignViewProfileModel( {
    required this.profileImage,
    required this.name,
    required this.childsName,
    required this.childsGrade,
    required this.phoneNumber,
    required this.user,
    required this.sId
  });
}

class UserData {
  final String role;
  final String email;

  UserData({
    required this.role,
    required this.email,
  });
}