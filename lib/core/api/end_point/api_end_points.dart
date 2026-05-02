class ApiEndPoints {
  // static const String baseUrl = 'https://bvh0nlc7-3001.inc1.devtunnels.ms/api';
  static const String baseUrl = 'https://api.wecurehealth.com/api';

  // AUTH ENDPOINTS
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/send-reset-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-reg-otp';
  static const String verifyResetOtp = '/auth/verify-reset-otp';
  static const String resendOtp = '/auth/resend-otp';

  //  USER ENDPOINTS
  static const String wellnessTips = '/wellness-tips';
  static const String updateProfile = '/user/profile';
  static const String doctorUpdateProfile = '/doctors/me/profile';
  static const String changePassword = '/users/change-password';
  static const String deleteAccount = '/user/delete';
  static const String getSpecialties = '/specialist';
  static const String createDoctorInfo = '/doctors/me/profile';
  static const String docUpload = '/doctors/me/documents';
  static const String notifications = '/notifications';
  static const String terms = '/legal-content/terms-and-conditions';
  static const String policy = '/legal-content/privacy-policy';
  static const String support = '/contact';
  static const String doctorHome = '/appointments/doctor/dashboard';
  static const String addDoctorBankAccount = '/doctors/me/bank-details';
  static const String addUserBankAccount = '/users/me/bank-details';
  static const String doctorAppointmentDetails = '/appointments/doctor';
  static const String userAppointmentDetails = '/appointments/me';
  static const String appointments = '/appointments/me';
  static const String donationPayment = '/payments/donations/initialize';
  static const String appointmentsBook = '/appointments/me';
  static const String doctorAppointments = '/appointments/doctor/me';
  static const String getPopularDoctors = '/doctors/popular';
  static const String getAllSpecialDoctor = '/doctors/specialty';

  static const String addServiceDoctor = '/doctors/me/services';
  static const String addExperiencesDoctor = '/doctors/me/experiences';
  static const String getAllExperience = '/doctors/me/experiences';

  static const String getALlSchedule = '/doctors/me/availability';
  static const String createSchedule = '/doctors/me/availability';

  // PROFILE
  static const String doctorProfile = '/doctors/me/profile';
  static const String userProfile = '/users/me';
  static const String userUpdateProfile = '/users/profile';

  //  PRODUCT ENDPOINTS
  static const String products = '/products';
  static const String productDetails = '/products';
  static const String deleteProduct = '/products';

  // UPLOAD ENDPOINTS
  static const String uploadImage = '/upload/image';
  static const String uploadGallery = '/upload/gallery';
  static const String uploadDocument = '/upload/document';

  // FAVORITE ENDPOINTS
  static const String toggleFavorite = '/favorites/toggle';
  static const String getFavorites = '/favorites';

  // SEARCH ENDPOINTS
  static const String searchDoctors = '/doctors/search?q=';
  static const String availableDates = '/appointments/available-dates';
  static const String availableSlots = '/appointments/available-slots';
}
