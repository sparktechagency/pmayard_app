import 'package:get/get.dart';
import 'package:pmayard_app/models/assigned/assigned_response_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class AssignedController extends GetxController {
  List<AssignedResponseData> assignedData = [];
  bool isLoadingAssigned = false;

  Future<void> getAssigned() async {
    assignedData.clear();
    isLoadingAssigned = true;
    update();

    final response = await ApiClient.getData(ApiUrls.assigned);
    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      final dataList = data.map((item) => AssignedResponseData.fromJson(item)).toList();
      assignedData.addAll(dataList);
    }
    isLoadingAssigned = false;
    update();
  }
}
