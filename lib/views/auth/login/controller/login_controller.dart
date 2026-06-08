import 'package:flutter/foundation.dart';

import '../../../../core/api/services/auth_services.dart';
import '../../../../core/utils/basic_import.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // email
  final emailController = TextEditingController();
  final emailFocus = FocusNode();
  final isEmailValid = false.obs;

  // password
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();
  final isPasswordValid = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  RxBool isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    if (kDebugMode) {
      emailController.text = 'drxrakib2@yopmail.com';
      passwordController.text = 'securepass';
    }
    // emailController.text = 'drxrakib2@yopmail.com';
    // emailController.text = 'userxrakib1@yopmail.com';
    // passwordController.text = 'securepass';

    // emailController.text = 'dr.uno@yopmail.com';
    // emailController.text = 'user.uno@yopmail.com';
    // passwordController.text = 'securepass';
  }

  Future<LoginModel> loginProcess() async {
    return await AuthService.loginService(
      isLoading: isLoading,
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
