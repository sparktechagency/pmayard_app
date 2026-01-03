import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/no_internate_screen.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/get_fcm_token.dart';
import 'package:pmayard_app/services/internet/connectivity.dart';
import 'package:pmayard_app/services/socket_services.dart';
import 'app/dependancy_injaction.dart';
import 'app/helpers/device_utils.dart';
import 'app/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityController());
  DeviceUtils.lockDevicePortrait();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance;
  await FirebaseNotificationService.printFCMToken();
  await FirebaseNotificationService.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SocketServices.init();
  runApp(const PmayardApp());
}

class PmayardApp extends StatelessWidget {
  const PmayardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: Size(375, 812),
      builder: (_, _) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initialRoute,
        theme: AppThemeData.lightThemeData,
        darkTheme: AppThemeData.darkThemeData,
        themeMode: ThemeMode.light,
        initialBinding: DependencyInjection(),
        routes: AppRoutes.routes,
        builder: (context, child) => Scaffold(body: NoInterNetScreen(child: child!)),
      ),
    );
  }
}
