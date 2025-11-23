import 'package:get/get.dart';
import 'package:pmayard_app/models/assigned/assigned_response_data.dart';
import 'package:pmayard_app/models/session/session_response_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class SessionsController extends GetxController {
  List<SessionsResponseData> sessionsData = [];
  bool isLoadingSession = false;

  Future<void> getSessions() async {
    sessionsData.clear();
    isLoadingSession = true;
    update();

    final response = await ApiClient.getData(ApiUrls.upcomingSessions);
    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      final dataList = data.map((item) => SessionsResponseData.fromJson(item)).toList();
      sessionsData.addAll(dataList);
    }
    isLoadingSession = false;
    update();
  }
}
