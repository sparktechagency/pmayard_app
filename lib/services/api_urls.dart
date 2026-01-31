class ApiUrls {

  // Base, Image, Socket
  // static const String baseUrl = "https://mihadhome4000.merinasib.shop/api/v1";
  static const String baseUrl = "https://api.fondationlms.org/api/v1";

  // static const String imageBaseUrl = "https://mihadhome4000.merinasib.shop";
  static const String imageBaseUrl = "https://api.fondationlms.org";

  // static const String socketUrl = "https://mihadhome4000.merinasib.shop";
  static const String socketUrl = "https://api.fondationlms.org";

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
      '/auth/resend-otp/$userEmail';

  // Legal
  static const String terms = '/terms';
  static const String about = '/about';
  static const String privacy = '/privacy';

  // User Profile Related Work
  static const String updateProfile = '/users/update-profile';
  static const String changePassword = '/auth/change-password';
  static const String parentCreate = '/parents/parent';
  static const String professionalCreate = '/professionals/professional';

  static const String assigned = '/sessions/assigned-roles';
  static const String verifySession = '/parents/verify-session';
  static const String upcomingSessions = '/sessions/upcoming-sessions';
  static String todaySessions(String formattedDate) {
    return '/sessions/upcoming-sessions?date=$formattedDate';
  }
  static const String notification = '/notifications';

  //static String sessionViewProfile(String id) => '/sessions/$id/role';
  static String sessionViewProfile(String sessionID) => '/sessions/$sessionID';
  static String deleteUser(String userID) => '/users/$userID';

  //Message Related work
  static String conversations(String type) => '/conversations/?type=$type';
  static String inbox(String chatID) => '/messages/$chatID';
  static String sendMessage(String conversationID) => '/messages/$conversationID/send-message';
  static String sendAttachments(String conversationID) => '/attachments/$conversationID/send-attachment';

  // Resource
  // https://api.fondationlms.org/api/v1/grades?searchTerm=&page=1&limit=10
  static String gradeSearch( int page ) => '/grades/?searchTerm=&page=$page&limit=10';

  // static String subjectsSearch( String userId ) => '/subjects/$userId';
  static String subjectsSearch( String userId, int page ) => '/subjects/$userId?page=$page&limit=10';

  // static String materialsSearch( String materialsID ) => '/materials/$materialsID';
  static String materialsSearch( String materialsID,int currentPage ) => '/materials/$materialsID?page=$currentPage&limit=10';


  static String completeSession(String userID) => '/sessions/$userID/status';
  static String professionalAvailability( String scheduleID ) => '/professionals/$scheduleID';
  static String editAvailabilitySchedule( String availabilityID ) => '/professionals/$availabilityID/availability';
  static String confirmSchedule( String userID ) => '/professionals/$userID/confirm-session';
  static String editSchedule( String roleID ) => '/professionals/$roleID/availability';

  static String eventGet(String date) {
    return date.isNotEmpty ? '/events/?eventDate=$date' : '/events/';
  }
  static String sessionSearch(String date){
    return  date.isNotEmpty ? '/sessions/my-sessions?date=$date' :  '/sessions/my-sessions';
  }
}
