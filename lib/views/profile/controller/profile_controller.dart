import 'dart:developer';

import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/views/profile/model/doctor_profile_model.dart';

import '../../../core/api/services/auth_services.dart';
import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart' hide Data;
import '../model/user_profile_model.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();
  List<Map<String, dynamic>> profileList = [
    {
      'title': 'Account Settings',
      'icon': Icons.settings,
      'onTap': Routes.settingScreen,
    },
    {
      'title': 'Contact & Support',
      'icon': Icons.support_agent,
      'onTap': Routes.supportScreen,
    },
    {
      'title': 'Terms & Conditions',
      'icon': Icons.terminal_sharp,
      'onTap': Routes.termsScreen,
    },
    {
      'title': 'Privacy Policy',
      'icon': Icons.policy,
      'onTap': Routes.policyScreen,
    },
    {'title': 'Logout', 'icon': Icons.logout},
  ];

  @override
  void onInit() {
    super.onInit();
    if (AppStorage.isUser == 'DOCTOR') {
      getDoctorProfile();
    } else {
      getUserProfile();
    }
  }

  RxBool isLoading = false.obs;

  Future<void> logoutProcess() async {
    await AuthService.logoutService(isLoading: isLoading, callApi: true);
  }

  RxBool getDoctorProfileLoading = false.obs;
  DoctorProfileModel? doctorProfileModel;

  Future<DoctorProfileModel> getDoctorProfile() async {
    return await ApiRequest().get(
      fromJson: DoctorProfileModel.fromJson,
      endPoint: ApiEndPoints.doctorProfile,
      isLoading: getDoctorProfileLoading,
      showResponse: true,
      onSuccess: (result) {
        doctorProfileModel = result;

        print("doctor user ID from profile: ${result.data.id}");
        print("doctor token: ${AppStorage.token}");
      },
    );
  }

  UserProfileModel? userProfileModel;
  RxBool getUserProfileLoading = false.obs;
  Future<UserProfileModel> getUserProfile() async {
    return await ApiRequest().get(
      fromJson: UserProfileModel.fromJson,
      endPoint: ApiEndPoints.userProfile,
      isLoading: getUserProfileLoading,
      showResponse: true,
      onSuccess: (result) {
        userProfileModel = result;

        log("userId: ${result.data.id}");
        log("user patient token: ${AppStorage.token}");
        log("user timezone: ${result.data.timezone}");
      },
    );
  }

  //
  // PLaceholder data

  final UserProfileModel userProfilePlaceholder = UserProfileModel(
    success: true,
    statusCode: 200,
    message: "No user data",
    data: UserData(
      id: '',
      email: '',
      v: 0,
      createdAt: DateTime(2000),
      emailVerificationOtp: null,
      emailVerificationOtpExpires: null,
      isEmailVerified: false,
      name: 'User Name',
      role: '',
      status: '',
      updatedAt: DateTime(2000),
      refreshToken: '',
      dateOfBirth: null,
      phone: '',
      profileImage: '',
      passwordResetOtp: null,
      passwordResetOtpExpires: null,
      bloodGroup: '',
      allergies: [],
      accountName: '',
      accountNumber: '',
      bankName: '',
    ),
  );

  final DoctorProfileModel doctorProfilePlaceholder = DoctorProfileModel(
    success: true,
    statusCode: 200,
    message: "No doctor data",
    data: Data(
      id: '',
      userId: UserId(
        id: '',
        name: 'Doctor Name',
        phone: '',
        profileImage: '',
        email: '',
      ),
      currentOrganization: 'Organization Not Available',
      specialtyId: SpecialtyId(id: '', name: 'Specialty Not Available'),
      about: '',
      consultationFee: 0,
      verificationDocuments: [],
      verificationStatus: '',
      isVerified: false,
      createdAt: DateTime(2000),
      updatedAt: DateTime(2000),
      v: 0,
      verificationNote: '',
      accountName: '',
      accountNumber: '',
      bankName: '',
      paystackRecipientCode: '',
      pendingPayouts: 0,
      recipientCreatedAt: null,
      totalEarnings: 0,
      totalPayouts: 0,
      totalExperienceYears: 0,
      dateOfBirth: '',
      services: [],
      averageRating: 0,
    ),
  );
}
