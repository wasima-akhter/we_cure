import 'dart:developer';

import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/views/profile/model/doctor_profile_model.dart';

import '../../../core/api/services/auth_services.dart';
import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../model/user_profile_model.dart';

class ProfileController extends GetxController {
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
      onSuccess: (result) {
        userProfileModel = result;

        log("userId: ${result.data.id}");
        log("user patient token: ${AppStorage.token}");
      },
    );
  }
}
