import 'package:get/get.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/models/assigned/assigned_professional_model_data.dart';
import 'package:pmayard_app/models/assigned/assigned_response_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

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
}
