import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/doctor_details_model.dart';

class TimezoneConverter {
  static tz.Location _location(String timezone) => tz.getLocation(timezone);

  static tz.TZDateTime doctorToUser({
    required DateTime doctorDateTime,
    required String doctorTimezone,
    required String userTimezone,
  }) {
    final doctorLocation = _location(doctorTimezone);
    final userLocation = _location(userTimezone);

    final doctorTime = tz.TZDateTime(
      doctorLocation,
      doctorDateTime.year,
      doctorDateTime.month,
      doctorDateTime.day,
      doctorDateTime.hour,
      doctorDateTime.minute,
      doctorDateTime.second,
      doctorDateTime.millisecond,
      doctorDateTime.microsecond,
    );

    return tz.TZDateTime.from(doctorTime, userLocation);
  }
}

ConvertedTime convertTimeToUserTime({
  required String dateStr,
  required String time,
  required String doctorTimezone,
  required String userTimezone,
}) {
  final doctorLocation = tz.getLocation(doctorTimezone);
  final userLocation = tz.getLocation(userTimezone);

  final dateParts = dateStr.split('-');
  final timeParts = time.split(':');

  /// 1. Build doctor time correctly in doctor timezone
  final doctorDateTime = tz.TZDateTime(
    doctorLocation,
    int.parse(dateParts[0]),
    int.parse(dateParts[1]),
    int.parse(dateParts[2]),
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );

  /// 2. Convert to user timezone
  final userDateTime = tz.TZDateTime.from(doctorDateTime, userLocation);

  /// 3. SAFE day offset (compare date-only in same timezone)
  final doctorDateOnly = tz.TZDateTime(
    doctorLocation,
    doctorDateTime.year,
    doctorDateTime.month,
    doctorDateTime.day,
  );

  final userDateOnly = tz.TZDateTime(
    userLocation,
    userDateTime.year,
    userDateTime.month,
    userDateTime.day,
  );

  final dayOffset = userDateOnly.difference(doctorDateOnly).inDays;

  return ConvertedTime(DateFormat('h:mm a').format(userDateTime), dayOffset);
}

//
class ConvertedSlot {
  final String dayOfWeek;
  final String formattedTime;
  ConvertedSlot(this.dayOfWeek, this.formattedTime);
}

class ConvertedTime {
  final String formattedTime;
  final int dayOffset; // 0 = same day, 1 = next day, -1 = previous day
  ConvertedTime(this.formattedTime, this.dayOffset);
}

ConvertedSlot convertSlotToUserTime({
  required String dayOfWeek,
  required String startTime,
  required String endTime,
  required String doctorTimezone,
  required String userTimezone,
}) {
  // No conversion needed.
  if (doctorTimezone == userTimezone) {
    return ConvertedSlot(
      dayOfWeek,
      '${_format24To12(startTime)} - ${_format24To12(endTime)}',
    );
  }

  final doctorLocation = tz.getLocation(doctorTimezone);
  final userLocation = tz.getLocation(userTimezone);

  // Anchor to the next occurrence of this weekday in the doctor's timezone.
  final weekday = _weekdayFromName(dayOfWeek);
  final now = tz.TZDateTime.now(doctorLocation);

  final daysUntil = (weekday - now.weekday + 7) % 7;
  final anchor = now.add(Duration(days: daysUntil));

  final start = _combineDateAndTime(anchor, startTime, doctorLocation);

  var end = _combineDateAndTime(anchor, endTime, doctorLocation);

  // Handle overnight slots (23:30 -> 00:30)
  if (end.isBefore(start)) {
    end = end.add(const Duration(days: 1));
  }

  final userStart = tz.TZDateTime.from(start, userLocation);

  final userEnd = tz.TZDateTime.from(end, userLocation);

  final displayDay = DateFormat('EEEE').format(userStart);

  final displayTime =
      '${DateFormat('h:mm a').format(userStart)} - '
      '${DateFormat('h:mm a').format(userEnd)}';

  return ConvertedSlot(displayDay, displayTime);
}

String _format24To12(String time) {
  final parts = time.split(':');

  final dt = DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));

  return DateFormat('h:mm a').format(dt);
}

tz.TZDateTime _combineDateAndTime(
  tz.TZDateTime date,
  String hhmm,
  tz.Location location,
) {
  final parts = hhmm.split(':');
  return tz.TZDateTime(
    location,
    date.year,
    date.month,
    date.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

int _weekdayFromName(String name) {
  const days = {
    'monday': 1,
    'tuesday': 2,
    'wednesday': 3,
    'thursday': 4,
    'friday': 5,
    'saturday': 6,
    'sunday': 7,
  };
  return days[name.toLowerCase()] ?? 1;
}

extension AppointmentSlotExtension on Availability {
  String get formattedTime {
    return "${_formatTime(startTime)} - ${_formatTime(endTime)}";
  }

  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (_) {
      return time;
    }
  }

  String get formattedPrice => "₦$fee";

  String get formattedDuration => "$slotSizeMinutes Minutes";

  String get totalSlots {
    if (slotSizeMinutes <= 0) return "0 Slot";

    final startHour = int.tryParse(startTime.split(':').first) ?? 0;
    final endHour = int.tryParse(endTime.split(':').first) ?? 0;

    final totalMinutes = (endHour - startHour) * 60;
    final slots = totalMinutes ~/ slotSizeMinutes;

    return "$slots Slot${slots > 1 ? 's' : ''}";
  }
}

class DoctorUiFallback {
  static const doctorName = 'Doctor Name';
  static const specialty = 'Specialty';
  static const organization = 'Hospital / Clinic';
  static const about = 'Doctor information is currently unavailable.';
  static const service = 'Service information unavailable';
  static const experience = 'Experience information unavailable';
  static const review = 'No reviews yet';
  static const profileImage = 'https://via.placeholder.com/300';
}

extension NullableStringExt on String? {
  String orNA([String fallback = "Not available"]) {
    final value = this?.trim();

    if (value == null || value.isEmpty) {
      return fallback;
    }

    return value;
  }

  bool get hasValue => this != null && this!.trim().isNotEmpty;
}
