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

String formatTimeRange(String timeRange) {
  if (!timeRange.contains(' - ')) return timeRange;

  final parts = timeRange.split(' - ');
  return '${_formatTime(parts[0])} - ${_formatTime(parts[1])}';
}

String _formatTime(String time) {
  if (time.isEmpty) return '';

  final parts = time.split(':');
  if (parts.length < 2) return time;

  final hour = int.parse(parts[0]);
  final minute = parts[1];

  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;

  return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
}
