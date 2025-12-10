import 'package:get/get.dart';
import 'package:pmayard_app/models/event/event_model_data.dart';

import '../../services/api_client.dart';
import '../../services/api_urls.dart';
import '../../widgets/custom_tost_message.dart';

class EventController extends GetxController {
  /// <======================= event ===========================>
  bool isLoadingEvent = false;

  List<EventModelData> eventData = [];

  Future<void> eventGet({String? date}) async {
    eventData.clear();
    isLoadingEvent = true;
    update();
    final response = await ApiClient.getData(ApiUrls.eventGet(date ?? ''));
    final responseBody = response.body;
    if (response.statusCode == 200) {
      final List data = responseBody['data']['result'];
      final events = data.map((json) => EventModelData.fromJson(json)).toList();
      eventData.addAll(events);
    } else {
      showToast(responseBody['message']);
    }

    isLoadingEvent = false;
    update();
  }


  void onDateChanged (selectedDate) {
    final String date = selectedDate.toIso8601String().split('T')[0];
  eventGet(date:date);
  update();
  }
}
