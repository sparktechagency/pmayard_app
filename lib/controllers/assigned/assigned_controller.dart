import 'package:get/get.dart';
import 'package:pmayard_app/models/assigned/assigned_professional_model_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class AssignedController extends GetxController {
  List<AssignedProfessionalModelData> assignedProfessionalData = [];
  bool isLoadingProfessionals = false;

  Future<void> getAssignedProfessional() async {
    isLoadingProfessionals = true;
    update();

    final response = await ApiClient.getData(ApiUrls.assignedProfessional);
    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      final  dataList = data.map((item) => AssignedProfessionalModelData.fromJson(item)).toList();
      assignedProfessionalData.addAll(dataList);
    }
    isLoadingProfessionals = false;
    update();
  }
}
