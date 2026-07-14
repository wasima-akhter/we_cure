part of 'routes.dart';

class RoutePageList {
  static var list = [
    //Page Route List
    GetPage(
      name: Routes.addExperienceScreen,
      page: () => const AddExperienceScreen(),
      binding: AddExperienceBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: Routes.serviceScreen,
      page: () => const ServiceScreen(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: Routes.experienceScreen,
      page: () => const ExperienceScreen(),
      binding: ExperienceBinding(),
    ),
    GetPage(
      name: Routes.aboutScreen,
      page: () => const AboutScreen(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: Routes.createScheduleScreen,
      page: () => const CreateScheduleScreen(),
      binding: CreateScheduleBinding(),
    ),
    GetPage(
      name: Routes.scheduleScreen,
      page: () => const ScheduleScreen(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: Routes.chatScreen,
      page: () => const ChatScreen(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: Routes.request_viewScreen,
      page: () => const RequestViewScreen(),
      binding: RequestViewBinding(),
    ),
    GetPage(
      name: Routes.doctor_homeScreen,
      page: () => const DoctorHomeScreen(),
      binding: DoctorHomeBinding(),
    ),
    GetPage(
      name: Routes.aditionalScreen,
      page: () => const AditionalScreen(),
      binding: AditionalBinding(),
    ),
    GetPage(
      name: Routes.createDoctorProfileScreen,
      page: () => const CreateDoctorProfileScreen(),
      binding: CreateDoctorProfileBinding(),
    ),
    GetPage(
      name: Routes.doctorRegisterScreen,
      page: () => const DoctorRegisterScreen(),
      binding: DoctorRegisterBinding(),
    ),

    GetPage(
      name: Routes.updateProfileScreen,
      page: () => const UpdateProfileScreen(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: Routes.bankDetailsScreen,
      page: () => const BankDetailsScreen(),
      binding: BankDetailsBinding(),
    ),
    GetPage(
      name: Routes.changePasswordScreen,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: Routes.policyScreen,
      page: () => const PolicyScreen(),
      binding: PolicyBinding(),
    ),
    GetPage(
      name: Routes.termsScreen,
      page: () => const TermsScreen(),
      binding: TermsBinding(),
    ),
    GetPage(
      name: Routes.supportScreen,
      page: () => const SupportScreen(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: Routes.settingScreen,
      page: () => const SettingScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.videoCallScreen,
      page: () => const VideoCallScreen(),
      binding: VideoCallBinding(),
    ),
    GetPage(
      name: Routes.inboxScreen,
      page: () => const InboxScreen(),
      binding: InboxBinding(),
    ),
    GetPage(
      name: Routes.appointmentDetailsScreen,
      page: () => const AppointmentDetailsScreen(),
      binding: AppointmentDetailsBinding(),
    ),
    GetPage(
      name: Routes.categoryDetailsScreen,
      page: () => const CategoryDetailsScreen(),
      binding: CategoryDetailsBinding(),
    ),
    GetPage(
      name: Routes.likedTipsScreen,
      page: () => const LikedTipsScreen(),
      binding: LikedTipsBinding(),
    ),
    GetPage(
      name: Routes.paymentScreen,
      page: () => const PaymentScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: Routes.bookInfoScreen,
      page: () => const BookInfoScreen(),
      binding: BookInfoBinding(),
    ),
    GetPage(
      name: Routes.allReviewScreen,
      page: () => const AllReviewScreen(),
      binding: AllReviewBinding(),
    ),
    GetPage(
      name: Routes.doctorDetailsScreen,
      page: () => const DoctorDetailsScreen(),
      binding: DoctorDetailsBinding(),
    ),
    GetPage(
      name: Routes.allDoctorsScreen,
      page: () => const AllDoctorsScreen(),
      binding: AllDoctorsBinding(),
    ),
    GetPage(
      name: Routes.allCategoryScreen,
      page: () => const AllCategoryScreen(),
      binding: AllCategoryBinding(),
    ),
    GetPage(
      name: Routes.notificationScreen,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.tipsScreen,
      page: () => const TipsScreen(),
      binding: TipsBinding(),
    ),
    GetPage(
      name: Routes.profileScreen,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.appointmentScreen,
      page: () => const AppointmentScreen(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: Routes.findScreen,
      page: () => const FindScreen(),
      binding: FindBinding(),
    ),
    GetPage(
      name: Routes.homeScreen,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.verificationScreen,
      page: () => const VerificationScreen(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: Routes.navigationScreen,
      page: () => const NavigationScreen(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: Routes.onboardScreen,
      page: () => const OnboardScreen(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: Routes.uploadDocScreen,
      page: () => const UploadDocScreen(),
      binding: UploadDocBinding(),
    ),
    GetPage(
      name: Routes.resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.otpScreen,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.registerScreen,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.offlineScreen,
      page: () => const OfflineScreen(),
      binding: OfflineBinding(),
    ),
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
  ];
}
