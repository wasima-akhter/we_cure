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

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: Schedules.fromJson(json['data']),
    );
  }
}
