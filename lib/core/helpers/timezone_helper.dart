import 'dart:developer';

import 'package:flutter_timezone/flutter_timezone.dart';

class TimezoneHelper {
  static Future<String> getCurrentTimezone() async {
    log("🔥 TIMEZONE HELPER CALLED");

    try {
      final timezone = await FlutterTimezone.getLocalTimezone();

      log("RAW IDENTIFIER: ${timezone.identifier}");
      log("RAW LOCALIZED: ${timezone.localizedName}");

      return timezone.identifier;
    } catch (e) {
      log("❌ TIMEZONE ERROR: $e");
      return 'Africa/Lagos';
    }
  }
}
