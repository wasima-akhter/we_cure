import 'dart:developer';

import 'package:glady/views/auth/login/model/login_model.dart';
import 'package:glady/views/navigation/controller/navigation_controller.dart';

import '../../../views/auth/otp/model/otp_verify_model.dart';
import '../../../views/bank_details/model/bank_details_model.dart';
import '../../helpers/timezone_service.dart';
import '../../utils/app_storage.dart';
import '../../utils/basic_import.dart';
import '../../widgets/confirmation_widget.dart';
import '../end_point/api_end_points.dart';
import '../model/basic_success_model.dart';
import 'api_request.dart';
import 'push_notification_service.dart';

class AuthService {
  static final ApiRequest _api = ApiRequest();

  /// =============================================== ✅ Login ================================================== ///

  static Future<LoginModel> loginService({
    required RxBool isLoading,
    required String email,
    required String password,
  }) async {
    log("🟡 LOGIN START");
    log("➡️ Email: $email");
    log("➡️ Role BEFORE login: ${AppStorage.isUser}");
    log("➡️ Token BEFORE login: ${AppStorage.token}");

    Map<String, dynamic> inputBody = {
      'email': email.trim(),
      'password': password,
    };

    return await _api.post(
      fromJson: LoginModel.fromJson,
      endPoint: ApiEndPoints.login,
      isLoading: isLoading,
      body: inputBody,
      queryParams: {},

      showSuccessSnackBar: false,
      onSuccess: (result) async {
        log("🟢 LOGIN RESPONSE RECEIVED");
        log("➡️ API Role: ${result.data?.role}");
        log("➡️ API Token: ${result.data?.accessToken}");

        log("➡️ API ROLE: ${result.data?.role}");

        await AppStorage.save(
          token: result.data?.accessToken,
          isUser: result.data?.role?.toString().toUpperCase(),
          isLoggedIn: true,
        );

        log("💾 AFTER SAVE STORAGE");
        log("➡️ Saved Role: ${AppStorage.isUser}");
        log("➡️ Saved Token: ${AppStorage.token}");

        await NotificationService.syncTokenAfterLogin();

        if (Get.isRegistered<NavigationController>()) {
          NavigationController.to.reloadScreens(); // ✅ Add this
        }

        ///

        ///

        // log("✅ Login complete");
        log("🚀 Checking user role navigation");

        if (result.data?.role?.toUpperCase() == "DOCTOR") {
          await checkDoctorBankDetailsAndNavigate(
            token: result.data?.accessToken ?? '',
          );
        } else {
          Get.offAllNamed(Routes.navigationScreen);
          // Wait until navigation is completed
          Future.delayed(const Duration(milliseconds: 500), () async {
            await TimezoneService.checkAndSyncTimezone();
          });
        }

        log("✅ Login complete");
      },
    );
  }

  static Future<BasicSuccessModel> registerService({
    required RxBool isLoading,
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? doctorId,
    String? timezone,
    String? phone,
  }) async {
    Map<String, dynamic> inputBody = {
      'name': fullName.trim(),
      'email': email.trim(),
      'password': password,
      'role': role,
      'doctorId': doctorId,
      'timezone': timezone ?? '',
    };

    return await _api.post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.register,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: true,
      onSuccess: (result) {
        Get.toNamed(
          Routes.verificationScreen,
          arguments: {"email": email.trim()},
        );
        log('✅ Registration successful - Token saved');
      },
    );
  }

  static Future<LoginModel> registerOtpVerifyService({
    required RxBool isLoading,
    required String code,
    required String email,
  }) async {
    Map<String, dynamic> inputBody = {
      'email': email.trim(),
      'otp': code.trim(),
    };

    return await _api.post(
      fromJson: LoginModel.fromJson,
      endPoint: ApiEndPoints.verifyOtp,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: false,

      onSuccess: (result) async {
        if (result.data?.role == 'USER') {
          // Users are immediately logged in
          await AppStorage.save(
            isLoggedIn: true,
            token: result.data?.accessToken,
            isUser: result.data?.role?.toUpperCase(),
          );
          await NotificationService.syncTokenAfterLogin();
          if (Get.isRegistered<NavigationController>()) {
            NavigationController.to.reloadScreens();
          }

          Get.offAllNamed(Routes.navigationScreen);

          await TimezoneService.checkAndSyncTimezone();
        } else {
          // Doctor
          Get.offNamed(
            Routes.createDoctorProfileScreen,
            arguments: {"email": email, "token": result.data?.accessToken},
          );
        }
      },
    );
  }

  static Future<ResetOtpVerifyModel> forgotOtpVerifyService({
    required RxBool isLoading,
    required String code,
    required String email,
  }) async {
    Map<String, dynamic> inputBody = {
      'email': email.trim(),
      'otp': code.trim(),
    };

    return await _api.post(
      fromJson: ResetOtpVerifyModel.fromJson,
      endPoint: ApiEndPoints.verifyResetOtp,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: false,
      onSuccess: (result) {
        debugPrint(
          '   ApiEndPoints.verifyResetOtp result : ${result.message} ',
        );
        AppStorage.save(
          isLoggedIn: true,
          temporaryToken: result.data?.resetToken,
        );
        Get.toNamed(Routes.resetPasswordScreen);
        log('✅ OTP verified successfully');
      },
    );
  }

  static Future<BasicSuccessModel> resendOtpService({
    required RxBool isLoading,
    required String email,
  }) async {
    Map<String, dynamic> inputBody = {'email': email.trim()};

    return await _api.post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.resendOtp,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: true,
      onSuccess: (result) {
        log('✅ OTP resent successfully');
      },
    );
  }

  static Future<BasicSuccessModel> forgotPasswordService({
    required RxBool isLoading,
    required String email,
  }) async {
    Map<String, dynamic> inputBody = {'email': email.trim()};

    return await _api.post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.forgotPassword,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: true,
      onSuccess: (result) {
        Get.toNamed(Routes.otpScreen);

        log('✅ Forgot password email sent - OTP verification required');
      },
    );
  }

  static Future<BasicSuccessModel> resetPasswordService({
    required RxBool isLoading,
    required String password,
  }) async {
    final token = AppStorage.temporaryToken;

    if (token.isEmpty) {
      throw Exception('Reset token is missing. Please restart the process.');
    }

    final Map<String, dynamic> inputBody = {
      'resetToken': token,
      'newPassword': password,
    };

    final result = await _api.post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.resetPassword,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: false, // handle manually
    );

    // ✅ Show snackbar before navigation
    if (Get.overlayContext != null) {
      CustomSnackBar.success(title: Strings.success, message: result.message);
    }

    AppStorage.save(temporaryToken: '');

    // ✅ Let the finally block in post() finish before disposing controller
    Future.microtask(() {
      Get.offAllNamed(Routes.loginScreen);
    });

    log('✅ Password reset successful');
    return result;
  }

  static Future<BasicSuccessModel> changePasswordService({
    required RxBool isLoading,
    required String oldPassword,
    required String newPassword,
  }) async {
    Map<String, dynamic> inputBody = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      // 'confirmPassword': newPassword,
    };

    return await _api.post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.changePassword,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: false,
      onSuccess: (result) {
        Get.offAll(
          ConfirmationWidget(
            iconPath: Assets.icons.vector,
            title: "Password Update Successfully",
            subtitle: 'your password has been changed successfully',
          ),
        );
        log('✅ Password changed successfully');
      },
    );
  }

  static Future<void> logoutService({
    RxBool? isLoading,
    bool callApi = false,
    bool showSuccessSnackBar = true,
  }) async {
    log("🔴 LOGOUT START");
    log("➡️ Role BEFORE logout: ${AppStorage.isUser}");
    log("➡️ Token BEFORE logout: ${AppStorage.token}");

    try {
      if (callApi) {
        await _api.post(
          fromJson: BasicSuccessModel.fromJson,
          endPoint: ApiEndPoints.logout,
          isLoading: isLoading ?? false.obs,
          body: {'token': AppStorage.temporaryToken},
          showSuccessSnackBar: showSuccessSnackBar,
        );
      }
    } catch (e) {
      log('⚠️ Logout API failed, continuing cleanup → $e');
    } finally {
      // await AppStorage.clear();
      await AppStorage.clearLoginData();

      log("🧹 STORAGE CLEARED COMPLETELY");
      log("➡️ Raw storage role: ${GetStorage().read('isUser')}");
      log("➡️ AppStorage.isUser (getter): ${AppStorage.isUser}");

      if (Get.isRegistered<NavigationController>()) {
        NavigationController.to.selectedIndex.value = 0;
        NavigationController.to.update();
      }

      Get.offAllNamed(Routes.loginScreen);

      log("🚪 Navigated to login");
    }
  }

  static Future<void> checkDoctorBankDetailsAndNavigate({
    required String token,
  }) async {
    try {
      final response = await _api.get(
        fromJson: BankDetailsModel.fromJson,
        endPoint: ApiEndPoints.addDoctorBankAccount,
        isLoading: false.obs,
        showResponse: false,
      );

      final accountNumber = response.data?.accountNumber;

      if (accountNumber == null || accountNumber.trim().isEmpty) {
        Get.offNamed(
          Routes.bankDetailsScreen,
          arguments: {"token": token, "isFirstTime": true},
        );
      } else {
        Get.offAllNamed(Routes.navigationScreen);
      }
    } catch (e) {
      log("Bank check error: $e");
      Get.offAllNamed(Routes.navigationScreen);
    }
  }
}
