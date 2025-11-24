class ApiUrls {
  //static const String baseUrl = "http://217.15.170.117";
  static const String baseUrl = "https://mihad4000.merinasib.shop/api/v1";


  //static const String imageBaseUrl = "http://217.15.170.117/";
  static const String imageBaseUrl = "https://mihad4000.merinasib.shop/";


  //static const String socketUrl = "http://217.15.170.117";
  static const String socketUrl = "https://mihad4000.merinasib.shop";

  static const String userData = '/users/me';
  static const String register = '/users/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String login = '/auth/login';
  static const String forgetPassword = '/auth/forget-password';
  static  const String  resendOtp = '/auth/resend-otp';
  static  const String  resetPassword = '/auth/reset-password';
  static   String  resendVerifyOtp(String userEmail) => 'auth/resend-otp/$userEmail';

  static  const String  terms = '/rules/terms';
  static  const String  about = '/rules/aboutus';
  static  const String  privacy = '/rules/privacy';

  static  const String  changePassword = '/auth/change-password';

  static  const String  updateProfile = '/users/update-profile';
  static  const String  parentCreate = '/parents/parent';
  static  const String  professionalCreate = '/professionals/professional';
  static  const String  assigned = '/sessions/assigned-roles';
  static  const String  upcomingSessions = '/sessions/upcoming-sessions';
  static   String  conversations(String type) => '/conversations/?type=$type';
  static   String  inbox(String chatID) => '/messages/$chatID';

}
