/*

class DoctorAppointmentsModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<DoctorAppointments> data;
  final Meta meta;

  DoctorAppointmentsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory DoctorAppointmentsModel.fromJson(Map<String, dynamic> json) =>
      DoctorAppointmentsModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<DoctorAppointments>.from(
          json["data"].map((x) => DoctorAppointments.fromJson(x)),
        ),
        meta: Meta.fromJson(json["meta"]),
      );
}

class DoctorAppointments {
  final String id;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String appointmentEndTime;
  final String status;
  final int consultationFee;
  final String patientName;
  final String specialtyName;

  DoctorAppointments({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.status,
    required this.consultationFee,
    required this.patientName,
    required this.specialtyName,
  });

  factory DoctorAppointments.fromJson(Map<String, dynamic> json) =>
      DoctorAppointments(
        id: json["_id"],
        appointmentDate: DateTime.parse(json["appointmentDate"]),
        appointmentTime: json["appointmentTime"],
        appointmentEndTime: json["appointmentEndTime"],
        status: json["status"],
        consultationFee: json["consultationFee"],
        patientName: json["patientName"],
        specialtyName: json["specialtyName"],
      );
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );
}


*/

import '../../../core/helpers/safe_parser_helper.dart';

class DoctorAppointmentsModel {
  final bool success;

  final int statusCode;

  final String message;

  final List<DoctorAppointments> data;

  final Meta meta;

  DoctorAppointmentsModel({
    required this.success,

    required this.statusCode,

    required this.message,

    required this.data,

    required this.meta,
  });

  factory DoctorAppointmentsModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DoctorAppointmentsModel(
      success: SafeParser.boolVal(map['success']),

      statusCode: SafeParser.intVal(map['statusCode']),

      message: SafeParser.str(map['message']),

      data: SafeParser.list<DoctorAppointments>(
        map['data'],

        (e) => DoctorAppointments.fromJson(e),
      ),

      meta:
          SafeParser.object<Meta>(map['meta'], (e) => Meta.fromJson(e)) ??
          Meta.fallback(),
    );
  }
}

class DoctorAppointments {
  final String id;

  final DateTime? appointmentDate;

  final String appointmentTime;

  final String appointmentEndTime;

  final String status;

  final int consultationFee;

  final String patientName;

  final String specialtyName;

  DoctorAppointments({
    required this.id,

    required this.appointmentDate,

    required this.appointmentTime,

    required this.appointmentEndTime,

    required this.status,

    required this.consultationFee,

    required this.patientName,

    required this.specialtyName,
  });

  factory DoctorAppointments.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DoctorAppointments(
      id: SafeParser.str(map['_id']),

      appointmentDate: SafeParser.date(map['appointmentDate']),

      appointmentTime: SafeParser.str(map['appointmentTime']),

      appointmentEndTime: SafeParser.str(map['appointmentEndTime']),

      status: SafeParser.str(map['status']),

      consultationFee: SafeParser.intVal(map['consultationFee']),

      patientName: SafeParser.str(map['patientName']),

      specialtyName: SafeParser.str(map['specialtyName']),
    );
  }

  static DoctorAppointments fallback() => DoctorAppointments(
    id: '',

    appointmentDate: null,

    appointmentTime: '',

    appointmentEndTime: '',

    status: '',

    consultationFee: 0,

    patientName: '',

    specialtyName: '',
  );
}

class Meta {
  final int total;

  final int page;

  final int limit;

  final int totalPages;

  Meta({
    required this.total,

    required this.page,

    required this.limit,

    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Meta(
      total: SafeParser.intVal(map['total']),

      page: SafeParser.intVal(map['page'], 1),

      limit: SafeParser.intVal(map['limit'], 10),

      totalPages: SafeParser.intVal(map['totalPages']),
    );
  }

  static Meta fallback() => Meta(total: 0, page: 1, limit: 10, totalPages: 0);
}
