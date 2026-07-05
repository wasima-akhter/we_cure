import 'dart:developer';

import '../../views/profile/controller/profile_controller.dart';
import '../../views/update_profile/controller/update_profile_controller.dart';
import '../utils/app_storage.dart';
import '../utils/basic_import.dart';
import 'timezone_dialog.dart';
import 'timezone_helper.dart';

class TimezoneService {
  static Future<void> checkAndSyncTimezone() async {
    await _handleTimezoneCheck();
  }

  static Future<void> _handleTimezoneCheck() async {
    log("========== TIMEZONE CHECK START ==========");

    log("➡️ Creating ProfileController");
    final profileController = Get.put(ProfileController());

    log("➡️ Fetching device timezone...");
    final deviceTimezone = await TimezoneHelper.getCurrentTimezone();
    log("✅ Device Timezone: $deviceTimezone");

    String? profileTimezone;

    if (AppStorage.isUser == "USER") {
      log("➡️ Logged in as USER");
      log("➡️ Fetching user profile...");

      final user = await profileController.getUserProfile();

      profileTimezone = user.data.timezone;

      log("✅ User profile fetched");
      log("➡️ Profile Timezone: $profileTimezone");
    } else {
      log("➡️ Logged in as DOCTOR");
      log("➡️ Fetching doctor profile...");

      final doctor = await profileController.getDoctorProfile();

      profileTimezone = doctor.data.userId.timezone;

      log("✅ Doctor profile fetched");
      log("➡️ Profile Timezone: $profileTimezone");
    }

    log("---------- COMPARISON ----------");
    log("Device Timezone : $deviceTimezone");
    log("Profile Timezone: $profileTimezone");
    log("Different? ${profileTimezone != deviceTimezone}");

    if (profileTimezone != null &&
        profileTimezone.isNotEmpty &&
        profileTimezone != deviceTimezone) {
      log("➡️ Creating UpdateProfileController");
      final updateController = Get.put(UpdateProfileController());

      log("➡️ Showing Timezone Dialog");

      await Get.dialog(
        TimezoneDialog(
          currentTimezone: deviceTimezone,
          profileTimezone: profileTimezone ?? '',
          timezones: updateController.timezones,
          isLoading: updateController.isLoading,
          onSave: (timezone) async {
            log("========== UPDATE TIMEZONE ==========");
            log("Selected Timezone: $timezone");

            updateController.timezone.value = timezone;

            if (AppStorage.isUser == 'USER') {
              log("➡️ Calling userUpdateProfileProcess()");
              await updateController.userUpdateProfileProcess();
              log("✅ User profile updated");
            } else {
              log("➡️ Calling doctorUpdateProfileProcess()");
              await updateController.doctorUpdateProfileProcess();
              log("✅ Doctor profile updated");
            }
          },
        ),
      );

      log("➡️ Dialog closed");
    }

    log("➡️ Navigating to NavigationScreen");
    Get.offAllNamed(Routes.navigationScreen);

    log("========== TIMEZONE CHECK END ==========");
  }
}
