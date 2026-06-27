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
