import 'dart:developer';

import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/helpers/timezone_service.dart';
import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../../bank_details/model/bank_details_model.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkInitialRoute();
  }

  Future<void> checkInitialRoute() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!AppStorage.isLoggedIn) {
      Get.offAllNamed(Routes.loginScreen);
      return;
    }

    log("Splash Role: ${AppStorage.isUser}");

    if (AppStorage.isUser == "DOCTOR") {
      await checkDoctorBankDetailsAndNavigate();
    } else {
      Get.offAllNamed(Routes.navigationScreen);

      Future.delayed(const Duration(milliseconds: 500), () async {
        await TimezoneService.checkAndSyncTimezone();
      });
    }
  }

  Future<void> checkDoctorBankDetailsAndNavigate() async {
    try {
      final response = await ApiRequest().get(
        fromJson: BankDetailsModel.fromJson,
        endPoint: ApiEndPoints.addDoctorBankAccount,
        isLoading: false.obs,
        showResponse: false,
      );

      final accountNumber = response.data?.accountNumber;

      if (accountNumber == null || accountNumber.trim().isEmpty) {
        Get.offNamed(
          Routes.bankDetailsScreen,
          arguments: {"token": AppStorage.token, "isFirstTime": true},
        );
      } else {
        Get.offAllNamed(Routes.navigationScreen);

        Future.delayed(const Duration(milliseconds: 500), () async {
          await TimezoneService.checkAndSyncTimezone();
        });
      }
    } catch (e) {
      log("Doctor bank check error: $e");

      // fallback
      Get.offAllNamed(Routes.navigationScreen);
    }
  }
}
