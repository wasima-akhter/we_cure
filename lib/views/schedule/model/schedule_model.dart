/*
class ScheduleModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Schedules> data;

  ScheduleModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    success: json["success"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: List<Schedules>.from(json["data"].map((x) => Schedules.fromJson(x))),
  );
}

class Schedules {
  final String id;
  final String dayOfWeek;
  final String doctorId;
  final int v;
  final DateTime createdAt;
  final String endTime;
  final int fee;
  final bool isActive;
  final int slotSizeMinutes;
  final String startTime;
  final DateTime updatedAt;

  Schedules({
    required this.id,
    required this.dayOfWeek,
    required this.doctorId,
    required this.v,
    required this.createdAt,
    required this.endTime,
    required this.fee,
    required this.isActive,
    required this.slotSizeMinutes,
    required this.startTime,
    required this.updatedAt,
  });

  factory Schedules.fromJson(Map<String, dynamic> json) => Schedules(
    id: json["_id"],
    dayOfWeek: json["dayOfWeek"],
    doctorId: json["doctorId"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    endTime: json["endTime"],
    fee: json["fee"],
    isActive: json["isActive"],
    slotSizeMinutes: json["slotSizeMinutes"],
    startTime: json["startTime"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );
}


*/

import '../../../core/helpers/safe_parser_helper.dart';

class ScheduleModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Schedules> data;

  ScheduleModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return ScheduleModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data: SafeParser.list<Schedules>(
        map['data'],
        (e) => Schedules.fromJson(e),
      ),
    );
  }

  static ScheduleModel fallback() =>
      ScheduleModel(success: false, statusCode: 0, message: '', data: const []);
}

class Schedules {
  final String id;
  final String dayOfWeek;
  final String doctorId;
  final int v;
  final DateTime? createdAt;
  final String endTime;
  final int fee;
  final bool isActive;
  final int slotSizeMinutes;
  final String startTime;
  final DateTime? updatedAt;

  Schedules({
    required this.id,
    required this.dayOfWeek,
    required this.doctorId,
    required this.v,
    required this.createdAt,
    required this.endTime,
    required this.fee,
    required this.isActive,
    required this.slotSizeMinutes,
    required this.startTime,
    required this.updatedAt,
  });

  factory Schedules.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Schedules(
      id: SafeParser.str(map['_id']),
      dayOfWeek: SafeParser.str(map['dayOfWeek']),
      doctorId: SafeParser.str(map['doctorId']),
      v: SafeParser.intVal(map['__v']),
      createdAt: SafeParser.date(map['createdAt']),
      endTime: SafeParser.str(map['endTime']),
      fee: SafeParser.intVal(map['fee']),
      isActive: SafeParser.boolVal(map['isActive']),
      slotSizeMinutes: SafeParser.intVal(map['slotSizeMinutes']),
      startTime: SafeParser.str(map['startTime']),
      updatedAt: SafeParser.date(map['updatedAt']),
    );
  }

  static Schedules fallback() => Schedules(
    id: '',
    dayOfWeek: '',
    doctorId: '',
    v: 0,
    createdAt: null,
    endTime: '',
    fee: 0,
    isActive: false,
    slotSizeMinutes: 0,
    startTime: '',
    updatedAt: null,
  );
}
