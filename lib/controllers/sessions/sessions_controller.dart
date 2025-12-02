import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/session/my_session_parent_model.dart';
import 'package:pmayard_app/models/session/my_session_professional_model.dart';
import 'package:pmayard_app/models/session/session_professional_model_data.dart';
import 'package:pmayard_app/models/session/session_response_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class SessionsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  // =================  Upcoming Sessions (Using Models) ===============
  final sessionParentData = <SessionParentModelData>[].obs;
  final sessionProfessionalData = <SessionProfessionalModelData>[].obs;
  final isLoadingSession = false.obs;

  Future<void> getSessions() async {
    print('🔵 [SESSIONS] Starting getSessions...');

    sessionParentData.clear();
    sessionProfessionalData.clear();

    final userController = Get.find<UserController>();
    String role = userController.user?.role ?? '';
    print('🔵 [SESSIONS] User role: $role');

    isLoadingSession.value = true;
    print('🔵 [SESSIONS] Set loading to TRUE, calling update()');
    update(); // Notify UI that loading started

    try {
      final response = await ApiClient.getData(ApiUrls.upcomingSessions);
      print('✅ [SESSIONS] Got response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];
        print('✅ [SESSIONS] Data count: ${data.length}');

        if (role == 'professional') {
          final professionalData = data
              .map((e) => SessionProfessionalModelData.fromJson(e))
              .toList();
          sessionProfessionalData.assignAll(professionalData);
          print('✅ [SESSIONS] Assigned ${sessionProfessionalData.length} professional sessions');
          print('✅ [SESSIONS] First item name: ${sessionProfessionalData.firstOrNull?.parent?.name}');
        } else {
          final parentData = data
              .map((e) => SessionParentModelData.fromJson(e))
              .toList();
          sessionParentData.assignAll(parentData);
          print('✅ [SESSIONS] Assigned ${sessionParentData.length} parent sessions');
          print('✅ [SESSIONS] First item name: ${sessionParentData.firstOrNull?.professional?.name}');
        }
      }
    } catch (e) {
      print('❌ [SESSIONS] Error: $e');
      // print('❌ [SESSIONS] Stack trace: ${StackTrace.current}');
    } finally {
      isLoadingSession.value = false;
      print('🔴 [SESSIONS] Set loading to FALSE, calling update()');
      update(); // THIS IS CRITICAL - Notify UI that data is ready
      print('🔴 [SESSIONS] Update called! UI should rebuild now.');
    }
  }

  // =================  MY Sessions (Using Raw Maps - No Models) =====================
  final isLoadingMySection = false.obs;
  final mySessionData = <Map<String, dynamic>>[].obs;

  // Keep these for backward compatibility (empty lists)
  final mySessionParentData = <MySessionParentModelData>[].obs;
  final mySessionProfessionalData = <MySessionProfessionalModelData>[].obs;

  Future<void> fetchMySection(String date) async {
    mySessionData.clear();
    mySessionParentData.clear();
    mySessionProfessionalData.clear();

    isLoadingMySection.value = true;
    update(); // Notify listeners

    try {
      final response = await ApiClient.getData(ApiUrls.sessionSearch(date));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];
        // Store as raw maps for the session screen
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

  Future<void> fetchSelectedSession(String date) async {
    try {
      isLoadingSelectedSession.value = true;
      update(); // Notify listeners

      final role = Get.find<UserController>().user?.role ?? '';
      final response = await ApiClient.getData(ApiUrls.sessionSearch(date));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];

        if (role == 'professional') {
          final professionalData = data
              .map((e) => SessionProfessionalModelData.fromJson(e))
              .toList();
          sessionProfessionalData.assignAll(professionalData);
        } else {
          final parentData = data
              .map((e) => SessionParentModelData.fromJson(e))
              .toList();
          sessionParentData.assignAll(parentData);
        }
      }
    } catch (err) {
      showToast('Something Went Wrong $err');
    } finally {
      isLoadingSelectedSession.value = false;
      update(); // Notify listeners after data is loaded
    }
  }

  // =================  Assign View Profile (Using Raw Map) =====================
  final isLoadingAssignViewProfile = false.obs;
  Map<String, dynamic>? assignViewProfileData;

  // Getter to maintain compatibility with existing code
  AssignViewProfileModel? get assignViewProfileModel {
    if (assignViewProfileData == null) return null;
    return AssignViewProfileModel(
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

    try {
      final response = await ApiClient.getData(ApiUrls.sessionViewProfile(userId));
      if (response.statusCode == 200) {
        assignViewProfileData = response.body['data'];
        debugPrint('Fetched profile data');
        update(); // Notify listeners
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
        // Refresh the session list
        await fetchMySection('');
        Get.back(); // Close the dialog
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
  final String profileImage;
  final String name;
  final String childsName;
  final String childsGrade;
  final String phoneNumber;
  final UserData user;

  AssignViewProfileModel({
    required this.profileImage,
    required this.name,
    required this.childsName,
    required this.childsGrade,
    required this.phoneNumber,
    required this.user,
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