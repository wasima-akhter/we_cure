// To parse this JSON data, do
//
//     final createAppoinmentModel = createAppoinmentModelFromJson(jsonString);

/*
import 'dart:convert';

CreateAppoinmentModel createAppoinmentModelFromJson(String str) =>
    CreateAppoinmentModel.fromJson(json.decode(str));

String createAppoinmentModelToJson(CreateAppoinmentModel data) =>
    json.encode(data.toJson());

class CreateAppoinmentModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;
  final PaymentInfo? payment;

  CreateAppoinmentModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    this.payment,
  });

  factory CreateAppoinmentModel.fromJson(Map<String, dynamic> json) =>
      CreateAppoinmentModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        payment:
            json['payment'] !=
                null // 👈 parse payment
            ? PaymentInfo.fromJson(json['payment'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class PaymentInfo {
  final String authorizationUrl;
  final String reference;

  PaymentInfo({required this.authorizationUrl, required this.reference});

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      authorizationUrl: json['authorization_url'] ?? '',
      reference: json['reference'] ?? '',
    );
  }
}

class Data {
  final String userId;
  final String doctorId;
  final String specialistId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String appointmentEndTime;
  final String reasonTitle;
  final String reasonDetails;
  final String status;
  final int consultationFee;
  final bool reminder6HSent;
  final bool reminder1HSent;
  final bool isPaidOut;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String dataId;

  Data({
    required this.userId,
    required this.doctorId,
    required this.specialistId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.reasonTitle,
    required this.reasonDetails,
    required this.status,
    required this.consultationFee,
    required this.reminder6HSent,
    required this.reminder1HSent,
    required this.isPaidOut,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.dataId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["userId"],
    doctorId: json["doctorId"],
    specialistId: json["specialistId"],
    appointmentDate: DateTime.parse(json["appointmentDate"]),
    appointmentTime: json["appointmentTime"],
    appointmentEndTime: json["appointmentEndTime"],
    reasonTitle: json["reasonTitle"],
    reasonDetails: json["reasonDetails"],
    status: json["status"],
    consultationFee: json["consultationFee"],
    reminder6HSent: json["reminder6hSent"],
    reminder1HSent: json["reminder1hSent"],
    isPaidOut: json["isPaidOut"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    dataId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "doctorId": doctorId,
    "specialistId": specialistId,
    "appointmentDate": appointmentDate.toIso8601String(),
    "appointmentTime": appointmentTime,
    "appointmentEndTime": appointmentEndTime,
    "reasonTitle": reasonTitle,
    "reasonDetails": reasonDetails,
    "status": status,
    "consultationFee": consultationFee,
    "reminder6hSent": reminder6HSent,
    "reminder1hSent": reminder1HSent,
    "isPaidOut": isPaidOut,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "id": dataId,
  };
}


*/

import 'dart:convert';

import '../../../core/helpers/safe_parser_helper.dart';

CreateAppoinmentModel createAppoinmentModelFromJson(String str) =>
    CreateAppoinmentModel.fromJson(json.decode(str));

String createAppoinmentModelToJson(CreateAppoinmentModel data) =>
    json.encode(data.toJson());

class CreateAppoinmentModel {
  final bool success;
  final int statusCode;
  final String message;
  final AppointmentData data;
  final PaymentInfo? payment;

  CreateAppoinmentModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    this.payment,
  });

  factory CreateAppoinmentModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return CreateAppoinmentModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data:
          SafeParser.object<AppointmentData>(
            map['data'],
            (e) => AppointmentData.fromJson(e),
          ) ??
          AppointmentData.fallback(),
      payment: SafeParser.object<PaymentInfo>(
        map['payment'],
        (e) => PaymentInfo.fromJson(e),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data.toJson(),
    if (payment != null) "payment": payment!.toJson(),
  };
}

class PaymentInfo {
  final String authorizationUrl;
  final String reference;

  PaymentInfo({required this.authorizationUrl, required this.reference});

  factory PaymentInfo.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return PaymentInfo(
      authorizationUrl: SafeParser.str(map['authorization_url']),
      reference: SafeParser.str(map['reference']),
    );
  }

  Map<String, dynamic> toJson() => {
    "authorization_url": authorizationUrl,
    "reference": reference,
  };

  static PaymentInfo fallback() =>
      PaymentInfo(authorizationUrl: '', reference: '');
}

class AppointmentData {
  final String userId;
  final String doctorId;
  final String specialistId;
  final DateTime? appointmentDate;
  final String appointmentTime;
  final String appointmentEndTime;
  final String reasonTitle;
  final String reasonDetails;
  final String status;
  final int consultationFee;
  final bool reminder6HSent;
  final bool reminder1HSent;
  final bool isPaidOut;
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final String dataId;

  AppointmentData({
    required this.userId,
    required this.doctorId,
    required this.specialistId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.reasonTitle,
    required this.reasonDetails,
    required this.status,
    required this.consultationFee,
    required this.reminder6HSent,
    required this.reminder1HSent,
    required this.isPaidOut,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.dataId,
  });

  factory AppointmentData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return AppointmentData(
      userId: SafeParser.str(map['userId']),
      doctorId: SafeParser.str(map['doctorId']),
      specialistId: SafeParser.str(map['specialistId']),
      appointmentDate: SafeParser.date(map['appointmentDate']),
      appointmentTime: SafeParser.str(map['appointmentTime']),
      appointmentEndTime: SafeParser.str(map['appointmentEndTime']),
      reasonTitle: SafeParser.str(map['reasonTitle']),
      reasonDetails: SafeParser.str(map['reasonDetails']),
      status: SafeParser.str(map['status']),
      consultationFee: SafeParser.intVal(map['consultationFee']),
      reminder6HSent: SafeParser.boolVal(map['reminder6hSent']),
      reminder1HSent: SafeParser.boolVal(map['reminder1hSent']),
      isPaidOut: SafeParser.boolVal(map['isPaidOut']),
      id: SafeParser.str(map['_id']),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
      v: SafeParser.intVal(map['__v']),
      dataId: SafeParser.str(map['id']),
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "doctorId": doctorId,
    "specialistId": specialistId,
    "appointmentDate": appointmentDate?.toIso8601String(),
    "appointmentTime": appointmentTime,
    "appointmentEndTime": appointmentEndTime,
    "reasonTitle": reasonTitle,
    "reasonDetails": reasonDetails,
    "status": status,
    "consultationFee": consultationFee,
    "reminder6hSent": reminder6HSent,
    "reminder1hSent": reminder1HSent,
    "isPaidOut": isPaidOut,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "id": dataId,
  };

  static AppointmentData fallback() => AppointmentData(
    userId: '',
    doctorId: '',
    specialistId: '',
    appointmentDate: null,
    appointmentTime: '',
    appointmentEndTime: '',
    reasonTitle: '',
    reasonDetails: '',
    status: '',
    consultationFee: 0,
    reminder6HSent: false,
    reminder1HSent: false,
    isPaidOut: false,
    id: '',
    createdAt: null,
    updatedAt: null,
    v: 0,
    dataId: '',
  );
}
