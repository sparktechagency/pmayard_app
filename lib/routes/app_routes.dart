import 'package:flutter/material.dart';
import 'package:pmayard_app/feature/bottom_nav_bar/customtom_bottom_nav.dart';
import 'package:pmayard_app/feature/chat/inbox_screen.dart';
import 'package:pmayard_app/feature/profile/personal_info_screen.dart';
import 'package:pmayard_app/feature/profile/setting/about_screen.dart';
import 'package:pmayard_app/feature/profile/setting/change%20password/setting_change_password.dart';
import 'package:pmayard_app/feature/profile/setting/privacy_policy_screen.dart';
import 'package:pmayard_app/feature/profile/setting/setting_screen.dart';
import 'package:pmayard_app/feature/profile/setting/terms_screen.dart';

import '../feature/splash_screen/splash_screen.dart';
abstract class AppRoutes {

  ///  ============= > initialRoute < ==============
  static const String initialRoute = splashScreen;



  ///  ============= > routes name < ==============
  static const String splashScreen = '/';
  static const String onboardingScreen = '/onboardingScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String forgotScreen = '/forgotScreen';
  static const String otpScreen = '/otpScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String uploadPhotoScreen = '/uploadPhotoScreen';
  static const String goalsScreen = '/goalsScreen';
  static const String bioScreen = '/bioScreen';
  static const String interestsScreen = '/interestsScreen';
  static const String enableLocationScreen = '/enableLocationScreen';
  static const String customBottomNavBar = '/customBottomNavBar';
  static const String notificationScreen = '/notificationScreen';
  static const String commentScreen = '/commentScreen';
  static const String settingScreen = '/settingScreen';
  static const String termsScreen = '/termsScreen';
  static const String policyScreen = '/policyScreen';
  static const String aboutScreen = '/aboutScreen';
  static const String changePassScreen = '/changePassScreen';
  static const String supportScreen = '/supportScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String walletScreen = '/walletScreen';
  static const String chatScreen = '/chatScreen';
  static const String loveScreen = '/loveScreen';
  static const String giftsScreen = '/giftsScreen';
  static const String postCreateScreen = '/postCreateScreen';
  static const String reportScreen = '/reportScreen';
  static const String reportDetailsScreen = '/reportDetailsScreen';
  static const String mediaScreen = '/mediaScreen';
  static const String profileDetailsScreen = '/profileDetailsScreen';
  static const String giftsMemberScreen = '/giftsMemberScreen';
  static const String bankInfoScreen = '/bankInfoScreen';
  static const String joinGuestScreen = '/joinGuestScreen';
  static const String galleryScreen = '/galleryScreen';
  static const String personalInfoScreen = '/personalInfoScreen';
  static const String inboxScreen = '/inboxScreen';




  ///  ============= > routes < ==============
  static final routes = <String, WidgetBuilder>{
    splashScreen : (context) => SplashScreen(),
    customBottomNavBar : (context) => CustomBottomNavBar(),
    settingScreen : (context) => SettingScreen(),
    termsScreen : (context) => TermsScreen(),
    policyScreen : (context) => PrivacyPolicyScreen(),
    aboutScreen : (context) => AboutScreen(),
    changePassScreen : (context) => SettingChangePassword(),
    personalInfoScreen : (context) => PersonalInfoScreen(),
    inboxScreen : (context) => InboxScreen(),

  };
}
