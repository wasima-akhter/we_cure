import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../doctor_details/helper/helper.dart';

ConvertedTime convertAppointmentTime({
  required DateTime appointmentDate,
  required String time,
  required String doctorTimezone,
  required String userTimezone,
}) {
  final doctorLocation = tz.getLocation(doctorTimezone);
  final userLocation = tz.getLocation(userTimezone);

  final timeParts = time.split(':');

  /// ❗ CRITICAL FIX:
  /// Do NOT trust appointmentDate as-is for timezone math.
  /// Extract ONLY calendar date safely.
  final date = DateTime(
    appointmentDate.year,
    appointmentDate.month,
    appointmentDate.day,
  );

  /// Build doctor time explicitly
  final doctorDateTime = tz.TZDateTime(
    doctorLocation,
    date.year,
    date.month,
    date.day,
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );

  /// Convert properly to user timezone
  final userDateTime = tz.TZDateTime.from(doctorDateTime, userLocation);

  /// Safe day offset
  final dayOffset = userDateTime.day != doctorDateTime.day
      ? userDateTime.isAfter(doctorDateTime)
            ? 1
            : -1
      : 0;

  return ConvertedTime(DateFormat('h:mm a').format(userDateTime), dayOffset);
}
