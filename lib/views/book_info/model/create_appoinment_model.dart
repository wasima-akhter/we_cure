// To parse this JSON data, do
//
//     final createAppoinmentModel = createAppoinmentModelFromJson(jsonString);

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
