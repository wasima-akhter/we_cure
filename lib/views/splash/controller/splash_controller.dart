import '../../../core/helpers/timezone_service.dart';
import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    debugPrint("onboardSave: ${AppStorage.onboardSave}");
    debugPrint("isLoggedIn: ${AppStorage.isLoggedIn}");

    await Future.delayed(const Duration(seconds: 5));

    if (!AppStorage.onboardSave) {
      Get.offAllNamed(Routes.onboardScreen);
    } else if (AppStorage.isLoggedIn) {
      Get.offAllNamed(Routes.navigationScreen);
      await TimezoneService.checkAndSyncTimezone();
    } else {
      Get.offAllNamed(Routes.loginScreen);
    }
  }
}
