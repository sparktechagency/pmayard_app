import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:pmayard_app/models/event/event_model_data.dart';

import '../../app/helpers/prefs_helper.dart';
import '../../app/utils/app_constants.dart';
import '../../routes/app_routes.dart';
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
