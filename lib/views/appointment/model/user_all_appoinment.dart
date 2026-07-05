class UserAllAppointment {
  final bool success;
  final int statusCode;
  final String message;
  final List<Appointments> data;
  final Meta meta;

  UserAllAppointment({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory UserAllAppointment.fromJson(Map<String, dynamic> json) =>
      UserAllAppointment(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<Appointments>.from(
          json["data"].map((x) => Appointments.fromJson(x)),
        ),
        meta: Meta.fromJson(json["meta"]),
      );
}

class Appointments {
  final String id;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String appointmentEndTime;
  final String status;
  final int consultationFee;
  final String doctorName;
  final String specialtyName;
  final String? doctorTimezone;

  Appointments({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.status,
    required this.consultationFee,
    required this.doctorName,
    required this.specialtyName,
    this.doctorTimezone,
  });

  factory Appointments.fromJson(Map<String, dynamic> json) => Appointments(
    id: json["_id"],
    appointmentDate: DateTime.parse(json["appointmentDate"]),
    appointmentTime: json["appointmentTime"],
    appointmentEndTime: json["appointmentEndTime"],
    status: json["status"],
    consultationFee: json["consultationFee"],
    doctorName: json["doctorName"],
    specialtyName: json["specialtyName"],
    doctorTimezone: json["doctorTimezone"],
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
