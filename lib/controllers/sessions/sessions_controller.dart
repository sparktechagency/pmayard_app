import 'package:get/get.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/session/session_professional_model_data.dart';
import 'package:pmayard_app/models/session/session_response_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class SessionsController extends GetxController {
  List<SessionParentModelData> sessionParentData = [];
  List<SessionProfessionalModelData> sessionProfessionalData = [];
  bool isLoadingSession = false;

  Future<void> getSessions() async {
    final role = Get.find<UserController>().user?.role ?? '';
    sessionProfessionalData.clear();
    sessionParentData.clear();
    isLoadingSession = true;
    update();

    final response = await ApiClient.getData(ApiUrls.upcomingSessions);
    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];


      if(role == 'professional'){
        final professional = data.map((item) => SessionProfessionalModelData.fromJson(item)).toList();
        sessionProfessionalData.addAll(professional);
      }else{
        final parent = data.map((item) => SessionParentModelData.fromJson(item)).toList();
        sessionParentData.addAll(parent);
      }
    }
    isLoadingSession = false;
    update();
  }
}