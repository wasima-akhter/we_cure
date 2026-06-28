/*
class ScheduleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Schedules data;

  ScheduleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: Schedules.fromJson(json['data']),
    );
  }
}
*/

import '../../../core/helpers/safe_parser_helper.dart';
import '../../schedule/model/schedule_model.dart';

class ScheduleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Schedules data;

  ScheduleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return ScheduleResponse(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data:
          SafeParser.object<Schedules>(
            map['data'],
            (e) => Schedules.fromJson(e),
          ) ??
          Schedules.fallback(),
    );
  }

  static ScheduleResponse fallback() => ScheduleResponse(
    success: false,
    statusCode: 0,
    message: '',
    data: Schedules.fallback(),
  );
}
