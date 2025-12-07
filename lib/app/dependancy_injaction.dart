import 'package:get/get.dart';
import 'package:pmayard_app/controllers/assigned/assigned_controller.dart';
import 'package:pmayard_app/controllers/auth/auth_controller.dart';
import 'package:pmayard_app/controllers/auth/profile_confirm/profile_confirm_controller.dart';
import 'package:pmayard_app/controllers/chat/chat_controller.dart';
import 'package:pmayard_app/controllers/chat/chat_listen_controller.dart';
import 'package:pmayard_app/controllers/event_controller.dart';
import 'package:pmayard_app/controllers/legal/legal_controller.dart';
import 'package:pmayard_app/controllers/resources/resource_controller.dart';
import 'package:pmayard_app/controllers/schedule/schedule_controller.dart';
import 'package:pmayard_app/controllers/sessions/sessions_controller.dart';
import 'package:pmayard_app/controllers/user/user_controller.dart';
import 'package:pmayard_app/feature/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
class DependencyInjection implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(ProfileConfirmController());
    Get.put(UserController());
    Get.put(AssignedController());
    Get.put(SessionsController());
    Get.put(ChatController());
    Get.put(SocketChatController());
    Get.put(LegalController());
    Get.put(ResourceController());
    Get.put(SocketChatController());
    Get.put(EventController());
    Get.put(ScheduleController());
    Get.put(CustomBottomNavBarController());
  }}