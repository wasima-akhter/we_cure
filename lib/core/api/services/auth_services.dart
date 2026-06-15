import 'dart:developer';

import 'package:glady/core/api/services/push_notification_service.dart';
import 'package:glady/views/auth/login/model/login_model.dart';

import '../../../views/auth/otp/model/otp_verify_model.dart';
import '../../utils/app_storage.dart';
import '../../utils/basic_import.dart';
import '../../widgets/confirmation_widget.dart';
import '../end_point/api_end_points.dart';
import '../model/basic_success_model.dart';
import 'api_request.dart';

class AuthService {
  static final ApiRequest _api = ApiRequest();

  /// =============================================== ✅ Login ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  loginProcess() async {
    return await AuthService.loginService(
      isLoading: isLoading,
      email: emailController.text,
      password: passwordController.text,
    );
  }
  ──────────────────────────────────────────────────────────────────────────
  */
  static Future<LoginModel> loginService({
    required RxBool isLoading,
    required String email,
    required String password,
  }) async {
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
      onSuccess: (result) {
        AppStorage.save(
          token: result.data?.accessToken,
          isUser: result.data?.role,
          isLoggedIn: true,
        );
        Get.offAllNamed(Routes.navigationScreen);
        log('✅ Login successful - Token saved');

        // FCM Token পাঠাও
        NotificationService.getToken().then((fcmToken) {
          if (fcmToken != null) {
            log('✅ FCM Token: $fcmToken');
            NotificationService.sendTokenToServer(fcmToken);
            AppStorage.save(temporaryToken: fcmToken);
          }
        });
      },
    );
  }

  /// =============================================== ✅ Register ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  registerProcess() async {
    return await AuthService.registerService(
      isLoading: isLoading,
      fullName: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text, // optional
    );
  }
  ──────────────────────────────────────────────────────────────────────────
  */
  static Future<BasicSuccessModel> registerService({
    required RxBool isLoading,
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? doctorId,
    String? phone,
  }) async {
    Map<String, dynamic> inputBody = {
      'name': fullName.trim(),
      'email': email.trim(),
      'password': password,
      'role': role,
      'doctorId': doctorId,
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

  /// =============================================== ✅ OTP Verification ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  otpVerifyProcess() async {
    return await AuthService.registerOtpVerifyService(
      isLoading: isLoading,
      code: otpController.text,
      email: email,
    );
  }
  ──────────────────────────────────────────────────────────────────────────
  */
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
      onSuccess: (result) {
        AppStorage.save(
          isLoggedIn: true,
          token: result.data?.accessToken,
          isUser: result.data?.role,
        );
        print(result.data?.accessToken ?? '');
        if (result.data?.role == 'USER') {
          log('USER');
          Get.offAllNamed(Routes.navigationScreen);
        } else {
          log('DOCTOR');
          Get.toNamed(Routes.aditionalScreen);
        }
        log('✅ OTP verified successfully');
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

  /// =============================================== ✅ Resend OTP ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  RxBool isResending = false.obs;

  resendOtpProcess() async {
    return await AuthService.resendOtpService(
      isLoading: isResending,
      email: email,
    );
  }
  ──────────────────────────────────────────────────────────────────────────
  */
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

  /// =============================================== ✅ Forgot Password ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  forgotPasswordProcess() async {
    return await AuthService.forgotPasswordService(
      isLoading: isLoading,
      email: emailController.text,
    );
  }
  ──────────────────────────────────────────────────────────────────────────
  */
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

  /// =============================================== ✅ Reset Password ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  resetPasswordProcess() async {
    return await AuthService.resetPasswordService(
      isLoading: isLoading,
      password: passwordController.text,
      email: email,
    );
  }
  ──────────────────────────────────────────────────────────────────────────
  */

  /*
  static resetPasswordService({
    required RxBool isLoading,
    required String password,
    // required String email,
  }) async {
    final token = AppStorage.temporaryToken;

    if (token.isEmpty) {
      throw Exception('Reset token is missing. Please restart the process.');
    }

    Map<String, dynamic> inputBody = {
      // 'email': email.trim(),
      'resetToken': AppStorage.temporaryToken,
      'newPassword': password,
    };

    return await _api.post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.resetPassword,
      isLoading: isLoading,
      body: inputBody,
      showSuccessSnackBar: true,
      onSuccess: (result) {
        Get.offAllNamed(Routes.welcomeScreen);
        AppStorage.save(temporaryToken: '');
        log('✅ Password reset successful - Please login with new password');
      },
    );
  }
*/

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

  /// =============================================== ✅ Change Password ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  changePasswordProcess() async {
    return await AuthService.changePasswordService(
      isLoading: isLoading,
      oldPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
    );
  }
  ──────────────────────────────────────────────────────────────────────────
  */
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

  /// =============================================== ✅ Logout ================================================== ///
  /*
  Usage:
  ──────────────────────────────────────────────────────────────────────────
  // Option 1: Simple logout (no API call)
  logoutProcess() {
    AuthService.logoutService();
  }

  // Option 2: Logout with API call
  RxBool isLoading = false.obs;

  logoutProcess() async {
    await AuthService.logoutService(
      isLoading: isLoading,
      callApi: true, // if backend requires logout endpoint
    );
  }

  ──────────────────────────────────────────────────────────────────────────
  */
  static Future<void> logoutService({
    RxBool? isLoading,
    bool callApi = false,
    bool showSuccessSnackBar = true,
  }) async {
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

      AppStorage.clear();
      Get.offAllNamed(Routes.loginScreen);
      log('✅ Logout successful - All data cleared');
    } catch (e) {
      log('⚠️ Logout API failed, but clearing local data anyway');
      AppStorage.clear();
      Get.offAllNamed(Routes.loginScreen);
    }
  }
}
