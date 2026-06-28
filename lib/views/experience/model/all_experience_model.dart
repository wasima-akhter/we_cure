/*

class AllExperienceModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Experiences> experiences;

  AllExperienceModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.experiences,
  });

  factory AllExperienceModel.fromJson(Map<String, dynamic> json) =>
      AllExperienceModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        experiences: List<Experiences>.from(
          json["data"].map((x) => Experiences.fromJson(x)),
        ),
      );
}

class Experiences {
  final String id;
  final String doctorId;
  final String organizationName;
  final String designation;
  final DateTime startDate;
  final DateTime? endDate; // ✅ nullable
  final bool isCurrent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Experiences({
    required this.id,
    required this.doctorId,
    required this.organizationName,
    required this.designation,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Experiences.fromJson(Map<String, dynamic> json) => Experiences(
    id: json["_id"] ?? '',
    doctorId: json["doctorId"] ?? '',
    organizationName: json["organizationName"] ?? '',
    designation: json["designation"] ?? '',
    startDate: DateTime.parse(json["startDate"]),

    // ✅ SAFE FIX
    endDate: json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,

    isCurrent: json["isCurrent"] ?? false,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"] ?? 0,
  );
}

*/

import '../../../core/helpers/safe_parser_helper.dart';

class AllExperienceModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Experiences> experiences;

  AllExperienceModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.experiences,
  });

  factory AllExperienceModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return AllExperienceModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      experiences: SafeParser.list<Experiences>(
        map['data'],
        (e) => Experiences.fromJson(e),
      ),
    );
  }

  static AllExperienceModel fallback() => AllExperienceModel(
    success: false,
    statusCode: 0,
    message: '',
    experiences: const [],
  );
}

class Experiences {
  final String id;
  final String doctorId;
  final String organizationName;
  final String designation;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Experiences({
    required this.id,
    required this.doctorId,
    required this.organizationName,
    required this.designation,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Experiences.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Experiences(
      id: SafeParser.id(map['_id']),
      doctorId: SafeParser.id(map['doctorId']),
      organizationName: SafeParser.str(map['organizationName']),
      designation: SafeParser.str(map['designation']),
      startDate: SafeParser.date(map['startDate']),
      endDate: SafeParser.date(map['endDate']),
      isCurrent: SafeParser.boolVal(map['isCurrent']),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
      v: SafeParser.intVal(map['__v']),
    );
  }

  static Experiences fallback() => Experiences(
    id: '',
    doctorId: '',
    organizationName: '',
    designation: '',
    startDate: null,
    endDate: null,
    isCurrent: false,
    createdAt: null,
    updatedAt: null,
    v: 0,
  );
}
