class ApiUrls {

  // Base, Image, Socket
  static const String baseUrl = "https://mihad4000.merinasib.shop/api/v1";
  static const String imageBaseUrl = "https://mihad4000.merinasib.shop/";
  static const String socketUrl = "https://mihad4000.merinasib.shop";

  // Authentication
  static const String userData = '/users/me';
  static const String editProfile = '/users/edit-profile';
  static const String register = '/users/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String login = '/auth/login';
  static const String forgetPassword = '/auth/forget-password';
  static const String resendOtp = '/auth/resend-otp';
  static const String resetPassword = '/auth/reset-password';
  static String resendVerifyOtp(String userEmail) =>
      'auth/resend-otp/$userEmail';

  // Legal
  static const String terms = '/rules/terms';
  static const String about = '/rules/aboutus';
  static const String privacy = '/rules/privacy';

  // User Profile Related Work
  static const String updateProfile = '/users/update-profile';
  static const String changePassword = '/auth/change-password';
  static const String parentCreate = '/parents/parent';
  static const String professionalCreate = '/professionals/professional';

  static const String assigned = '/sessions/assigned-roles';
  static const String upcomingSessions = '/sessions/upcoming-sessions';
  static const String notification = '/notifications';

  static String sessionViewProfile(String id) => '/sessions/$id/role';

  //Message Related work
  static String conversations(String type) => '/conversations/?type=$type';
  static String inbox(String chatID) => '/messages/$chatID';
  static String sendMessage(String conversationID) =>
      '/messages/$conversationID/send-message';

  // Resource

  static String gradeSearch( String searchTerm ) => '/grades/?searchTerm=$searchTerm';
  static String subjectsSearch( String userId ) => '/subjects/$userId';
  static String materialsSearch( String materialsID ) => '/materials/$materialsID';
  static String completeSession(String userID) => '/sessions/$userID/status';
  static String professionalAvailability( String scheduleID ) => '/professionals/$scheduleID';
  static String editAvailabilitySchedule( String availabilityID ) => '/professionals/$availabilityID/availability';
  static String confirmSchedule( String userID ) => '/professionals/$userID/confirm-session';
  static String editSchedule( String roleID ) => '/professionals/$roleID/availability';


  static String eventGet(String date) {
    return date.isNotEmpty ? '/events/?eventDate=$date' : '/events/';
  }
  static String sessionSearch(String date){
    print('=============== 59 this is with data related >/sessions/my-sessions?date=$date');
    print('===============60 this is without data related >/sessions/my-sessions');

    return  date.isNotEmpty ? '/sessions/my-sessions?date=$date' :  '/sessions/my-sessions';
  }
}
