import 'package:intl/intl.dart';

import '../model/doctor_details_model.dart';

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

  String get formattedPrice => "\$$fee";

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
