import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/routes/app_routes.dart';
import 'package:pmayard_app/services/internet/connectivity.dart';
import 'package:pmayard_app/services/socket_services.dart';
import 'app/dependancy_injaction.dart';
import 'app/helpers/device_utils.dart';
import 'app/theme/app_theme.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityController());
  DeviceUtils.lockDevicePortrait();


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
      builder:
          (_, _) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initialRoute,
        theme: AppThemeData.lightThemeData,
        darkTheme: AppThemeData.darkThemeData,
        themeMode: ThemeMode.light,
        initialBinding: DependencyInjection(),
        routes: AppRoutes.routes,
        // builder: (context, child) => Scaffold(body: NoInternetWrapper(child: child!)),
      ),
    );
  }
}



