import 'package:glady/views/auth/forgot_password/controller/forgot_password_controller.dart';

import '../../../../core/api/model/basic_success_model.dart';
import '../../../../core/api/services/auth_services.dart';
import '../../../../core/utils/basic_import.dart';
import '../model/otp_verify_model.dart';

class OtpController extends GetxController {
  final code = ''.obs;
  final otpController = TextEditingController();
  final isLoading = false.obs;
  final isClipboardDetected = false.obs;

  @override
  void onInit() {
    super.onInit();
    // _listenForSmsAutoFill();
  }

  // ✅ SMS Auto-fill listener
  void _listenForSmsAutoFill() {
    otpController.addListener(() {
      if (otpController.text.length == 6) {
        code.value = otpController.text;
        Future.delayed(Duration(milliseconds: 500), () {
          if (code.value.length == 6) {
            verifyOtp();
          }
        });
      }
    });
  }

  RxBool isResending = false.obs;

  Future<BasicSuccessModel> resendOtpProcess() async {
    return await AuthService.resendOtpService(
      isLoading: isResending,
      email: Get.find<ForgotPasswordController>().emailController.text,
    );
  }

  Future<ResetOtpVerifyModel> verifyOtp() async {
    return await AuthService.forgotOtpVerifyService(
      isLoading: isLoading,
      code: code.value,
      email: Get.find<ForgotPasswordController>().emailController.text,
    );
  }
}
