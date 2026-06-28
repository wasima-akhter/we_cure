/*
class DoctorAppointmentDetailsModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;

  DoctorAppointmentDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DoctorAppointmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      DoctorAppointmentDetailsModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final String id;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String appointmentEndTime;
  final String status;
  final int consultationFee;
  final String reasonTitle;
  final String reasonDetails;
  final Patient patient;
  final List<Attachment> attachments;
  final DateTime createdAt;

  Data({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.status,
    required this.consultationFee,
    required this.reasonTitle,
    required this.reasonDetails,
    required this.patient,
    required this.attachments,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    appointmentDate: DateTime.parse(json["appointmentDate"]),
    appointmentTime: json["appointmentTime"],
    appointmentEndTime: json["appointmentEndTime"],
    status: json["status"],
    consultationFee: json["consultationFee"],
    reasonTitle: json["reasonTitle"],
    reasonDetails: json["reasonDetails"],
    patient: Patient.fromJson(json["patient"]),
    attachments: List<Attachment>.from(
      json["attachments"].map((x) => Attachment.fromJson(x)),
    ),
    createdAt: DateTime.parse(json["createdAt"]),
  );
}

class Attachment {
  final String id;
  final String fileKey;
  final String fileType;
  final String url;
  final DateTime createdAt;

  Attachment({
    required this.id,
    required this.fileKey,
    required this.fileType,
    required this.url,
    required this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json["_id"],
    fileKey: json["fileKey"],
    fileType: json["fileType"],
    url: json["url"],
    createdAt: DateTime.parse(json["createdAt"]),
  );
}

class Patient {
  final String id;
  final String userId;
  final String name;
  final DateTime dateOfBirth;
  final String phone;
  final String profileImage;
  final String bloodGroup;
  final List<String> allergies;

  Patient({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.phone,
    required this.profileImage,
    required this.bloodGroup,
    required this.allergies,
    required this.userId,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json["_id"],
    name: json["name"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    phone: json["phone"],
    profileImage: json["profileImage"],
    bloodGroup: json["bloodGroup"],
    allergies: List<String>.from(json["allergies"].map((x) => x)),
    userId: json['userId'],
  );
}
*/

import '../../../core/helpers/safe_parser_helper.dart';

class DoctorAppointmentDetailsModel {
  final bool success;

  final int statusCode;

  final String message;

  final AppointmentData data;

  DoctorAppointmentDetailsModel({
    required this.success,

    required this.statusCode,

    required this.message,

    required this.data,
  });

  factory DoctorAppointmentDetailsModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DoctorAppointmentDetailsModel(
      success: SafeParser.boolVal(map['success']),

      statusCode: SafeParser.intVal(map['statusCode']),

      message: SafeParser.str(map['message']),

      data:
          SafeParser.object<AppointmentData>(
            map['data'],

            (e) => AppointmentData.fromJson(e),
          ) ??
          AppointmentData.fallback(),
    );
  }
}

class AppointmentData {
  final String id;

  final DateTime? appointmentDate;

  final String appointmentTime;

  final String appointmentEndTime;

  final String status;

  final int consultationFee;

  final String reasonTitle;

  final String reasonDetails;

  final Patient patient;

  final List<Attachment> attachments;

  final DateTime? createdAt;

  AppointmentData({
    required this.id,

    required this.appointmentDate,

    required this.appointmentTime,

    required this.appointmentEndTime,

    required this.status,

    required this.consultationFee,

    required this.reasonTitle,

    required this.reasonDetails,

    required this.patient,

    required this.attachments,

    required this.createdAt,
  });

  factory AppointmentData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return AppointmentData(
      id: SafeParser.str(map['_id']),

      appointmentDate: SafeParser.date(map['appointmentDate']),

      appointmentTime: SafeParser.str(map['appointmentTime']),

      appointmentEndTime: SafeParser.str(map['appointmentEndTime']),

      status: SafeParser.str(map['status']),

      consultationFee: SafeParser.intVal(map['consultationFee']),

      reasonTitle: SafeParser.str(map['reasonTitle']),

      reasonDetails: SafeParser.str(map['reasonDetails']),

      patient:
          SafeParser.object<Patient>(
            map['patient'],

            (e) => Patient.fromJson(e),
          ) ??
          Patient.fallback(),

      attachments: SafeParser.list<Attachment>(
        map['attachments'],

        (e) => Attachment.fromJson(e),
      ),

      createdAt: SafeParser.date(map['createdAt']),
    );
  }

  static AppointmentData fallback() => AppointmentData(
    id: '',

    appointmentDate: null,

    appointmentTime: '',

    appointmentEndTime: '',

    status: '',

    consultationFee: 0,

    reasonTitle: '',

    reasonDetails: '',

    patient: Patient.fallback(),

    attachments: const [],

    createdAt: null,
  );
}

class Attachment {
  final String id;

  final String fileKey;

  final String fileType;

  final String url;

  final DateTime? createdAt;

  Attachment({
    required this.id,

    required this.fileKey,

    required this.fileType,

    required this.url,

    required this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Attachment(
      id: SafeParser.str(map['_id']),

      fileKey: SafeParser.str(map['fileKey']),

      fileType: SafeParser.str(map['fileType']),

      url: SafeParser.str(map['url']),

      createdAt: SafeParser.date(map['createdAt']),
    );
  }

  static Attachment fallback() =>
      Attachment(id: '', fileKey: '', fileType: '', url: '', createdAt: null);
}

class Patient {
  final String id;

  final String userId;

  final String name;

  final DateTime? dateOfBirth;

  final String phone;

  final String profileImage;

  final String bloodGroup;

  final List<String> allergies;

  Patient({
    required this.id,

    required this.userId,

    required this.name,

    required this.dateOfBirth,

    required this.phone,

    required this.profileImage,

    required this.bloodGroup,

    required this.allergies,
  });

  factory Patient.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Patient(
      id: SafeParser.str(map['_id']),

      userId: SafeParser.str(map['userId']),

      name: SafeParser.str(map['name']),

      dateOfBirth: SafeParser.date(map['dateOfBirth']),

      phone: SafeParser.str(map['phone']),

      profileImage: SafeParser.str(map['profileImage']),

      bloodGroup: SafeParser.str(map['bloodGroup']),

      allergies: SafeParser.stringList(map['allergies']),
    );
  }

  static Patient fallback() => Patient(
    id: '',

    userId: '',

    name: '',

    dateOfBirth: null,

    phone: '',

    profileImage: '',

    bloodGroup: '',

    allergies: const [],
  );
}
