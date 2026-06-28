/*
class AllDateModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<AllDates> data;

  AllDateModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AllDateModel.fromJson(Map<String, dynamic> json) => AllDateModel(
    success: json["success"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: List<AllDates>.from(json["data"].map((x) => AllDates.fromJson(x))),
  );
}

class AllDates {
  final DateTime date;
  final String day;
  final int availableSlots;
  final int totalSlots;

  AllDates({
    required this.date,
    required this.day,
    required this.availableSlots,
    required this.totalSlots,
  });

  factory AllDates.fromJson(Map<String, dynamic> json) => AllDates(
    date: DateTime.parse(json["date"]),
    day: json["day"],
    availableSlots: json["availableSlots"],
    totalSlots: json["totalSlots"],
  );

  @override
  String toString() {
    return 'AllDates('
        'date: $date, '
        'day: $day, '
        'availableSlots: $availableSlots, '
        'totalSlots: $totalSlots'
        ')';
  }
}


*/

import 'package:intl/intl.dart';

import '../../../core/helpers/safe_parser_helper.dart';

class AllDateModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<AllDates> data;

  AllDateModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AllDateModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return AllDateModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data: SafeParser.list<AllDates>(map['data'], (e) => AllDates.fromJson(e)),
    );
  }

  static AllDateModel fallback() =>
      AllDateModel(success: false, statusCode: 0, message: '', data: const []);
}

class AllDates {
  final DateTime? date;
  final String day;
  final int availableSlots;
  final int totalSlots;

  AllDates({
    required this.date,
    required this.day,
    required this.availableSlots,
    required this.totalSlots,
  });

  factory AllDates.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return AllDates(
      date: SafeParser.date(map['date']),
      day: SafeParser.str(map['day']),
      availableSlots: SafeParser.intVal(map['availableSlots']),
      totalSlots: SafeParser.intVal(map['totalSlots']),
    );
  }

  static AllDates fallback() =>
      AllDates(date: null, day: '', availableSlots: 0, totalSlots: 0);

  /// 🔥 UI-safe label
  String get label {
    if (date == null) return day;

    final weekday = day.isNotEmpty ? day.substring(0, 3).toUpperCase() : '';

    final month = DateFormat('MMM').format(date!);

    return '$weekday ${date!.day} $month';
  }

  /// Optional: formatted full date
  String get fullDate {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date!);
  }
}
