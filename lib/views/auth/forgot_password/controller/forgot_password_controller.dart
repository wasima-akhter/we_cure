import 'package:flutter/foundation.dart';

import '../../../../core/api/model/basic_success_model.dart';
import '../../../../core/api/services/auth_services.dart';
import '../../../../core/utils/basic_import.dart';

class ForgotPasswordController extends GetxController {
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  // email
  final emailController = TextEditingController();
  final emailFocus = FocusNode();
  final isEmailValid = false.obs;

  // Forget password api
  RxBool isLoading = false.obs;

  Future<BasicSuccessModel> forgotPasswordProcess() async {
    return await AuthService.forgotPasswordService(
      isLoading: isLoading,
      email: emailController.text,
    );
  }

  @override
  void onInit() {
    if (kDebugMode) {
      emailController.text = "abcd@yopmail.com";
    }
    super.onInit();
  }
}
