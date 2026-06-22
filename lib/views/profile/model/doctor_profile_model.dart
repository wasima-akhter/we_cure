class DoctorProfileModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;

  DoctorProfileModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) =>
      DoctorProfileModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final String id;
  final UserId userId;
  final String currentOrganization;
  final SpecialtyId specialtyId;
  final String? about;
  final dynamic consultationFee;
  final List<String> verificationDocuments;
  final String verificationStatus;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String verificationNote;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String paystackRecipientCode;
  final int pendingPayouts;
  final DateTime? recipientCreatedAt;
  final int totalEarnings;
  final int totalPayouts;
  final int totalExperienceYears;
  final String? dateOfBirth;
  final List<Service> services;
  final num averageRating;

  Data({
    required this.id,
    required this.userId,
    required this.currentOrganization,
    required this.specialtyId,
    this.about,
    required this.consultationFee,
    required this.verificationDocuments,
    required this.verificationStatus,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.verificationNote,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.paystackRecipientCode,
    required this.pendingPayouts,
    required this.recipientCreatedAt,
    required this.totalEarnings,
    required this.totalPayouts,
    required this.totalExperienceYears,
    this.dateOfBirth,
    required this.services,
    required this.averageRating,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    userId: UserId.fromJson(json["userId"]),
    currentOrganization: json["currentOrganization"],
    specialtyId: SpecialtyId.fromJson(json["specialtyId"]),
    about: json["about"] ?? '',
    consultationFee: json["consultationFee"] ?? 0,
    verificationDocuments: List<String>.from(
      json["verificationDocuments"].map((x) => x),
    ),
    verificationStatus: json["verificationStatus"],
    isVerified: json["isVerified"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    verificationNote: json["verificationNote"],
    accountName: json["accountName"] ?? 'N/A',
    accountNumber: json["accountNumber"] ?? 'N/A',
    bankName: json["bankName"] ?? 'N/A',
    paystackRecipientCode: json["paystackRecipientCode"] ?? 'N/A',
    pendingPayouts: json["pendingPayouts"],
    recipientCreatedAt: json["recipientCreatedAt"] != null
        ? DateTime.parse(json["recipientCreatedAt"])
        : null,
    totalEarnings: json["totalEarnings"],
    totalPayouts: json["totalPayouts"],
    totalExperienceYears: json["totalExperienceYears"],
    dateOfBirth: json["dateOfBirth"] ?? '',
    services: List<Service>.from(
      json["services"].map((x) => Service.fromJson(x)),
    ),
    averageRating: json["averageRating"],
  );
}

class Service {
  final String id;
  final String doctorId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Service({
    required this.id,
    required this.doctorId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["_id"],
    doctorId: json["doctorId"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );
}

class SpecialtyId {
  final String id;
  final String name;

  SpecialtyId({required this.id, required this.name});

  factory SpecialtyId.fromJson(Map<String, dynamic> json) =>
      SpecialtyId(id: json["_id"], name: json["name"]);
}

class UserId {
  final String id;
  final String name;
  final String? phone;
  final String profileImage;
  final String? email;

  UserId({
    required this.id,
    required this.name,
    this.phone,
    required this.profileImage,
    this.email,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    name: json["name"],
    phone: json["phone"],
    profileImage: json["profileImage"] ?? '',
    email: json["email"] ?? '',
  );
}
