import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../../core/api/services/auth_services.dart';
import '../../../../core/utils/basic_import.dart';

class ResetPasswordController extends GetxController {
  // password
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();
  final confirmPasswordFocus = FocusNode();
  final isPasswordValid = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  RxBool isLoading = false.obs;

  resetPasswordProcess() async {
    try {
      await AuthService.resetPasswordService(
        isLoading: isLoading,
        password: passwordController.text,
      );
    } catch (e) {
      log('Reset password failed: $e');
    }
  }

  @override
  void onInit() {
    if (kDebugMode) {
      passController.text = "1234567A";
      passConfirmController.text = "1234567A";
    }
    super.onInit();
  }
}
