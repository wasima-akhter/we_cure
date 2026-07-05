/*
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
*/

import '../../../core/helpers/safe_parser_helper.dart';

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

  factory DoctorProfileModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DoctorProfileModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data:
          SafeParser.object<Data>(map['data'], (e) => Data.fromJson(e)) ??
          Data.fallback(),
    );
  }

  static DoctorProfileModel fallback() => DoctorProfileModel(
    success: false,
    statusCode: 0,
    message: '',
    data: Data.fallback(),
  );
}

class Data {
  final String id;
  final UserId userId;
  final String currentOrganization;
  final SpecialtyId specialtyId;
  final String? about;
  final int consultationFee;
  final List<String> verificationDocuments;
  final String verificationStatus;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
  final double averageRating;

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

  factory Data.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Data(
      id: SafeParser.id(map['_id']),
      userId:
          SafeParser.object<UserId>(map['userId'], (e) => UserId.fromJson(e)) ??
          UserId.fallback(),
      currentOrganization: SafeParser.str(map['currentOrganization']),
      specialtyId:
          SafeParser.object<SpecialtyId>(
            map['specialtyId'],
            (e) => SpecialtyId.fromJson(e),
          ) ??
          SpecialtyId.fallback(),
      about: SafeParser.nullableString(map['about']),
      consultationFee: SafeParser.intVal(map['consultationFee']),
      verificationDocuments: SafeParser.stringList(
        map['verificationDocuments'],
      ),
      verificationStatus: SafeParser.str(map['verificationStatus']),
      isVerified: SafeParser.boolVal(map['isVerified']),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
      v: SafeParser.intVal(map['__v']),
      verificationNote: SafeParser.str(map['verificationNote']),
      accountName: SafeParser.str(map['accountName'], 'N/A'),
      accountNumber: SafeParser.str(map['accountNumber'], 'N/A'),
      bankName: SafeParser.str(map['bankName'], 'N/A'),
      paystackRecipientCode: SafeParser.str(
        map['paystackRecipientCode'],
        'N/A',
      ),
      pendingPayouts: SafeParser.intVal(map['pendingPayouts']),
      recipientCreatedAt: SafeParser.date(map['recipientCreatedAt']),
      totalEarnings: SafeParser.intVal(map['totalEarnings']),
      totalPayouts: SafeParser.intVal(map['totalPayouts']),
      totalExperienceYears: SafeParser.intVal(map['totalExperienceYears']),
      dateOfBirth: SafeParser.nullableString(map['dateOfBirth']),
      services: SafeParser.list<Service>(
        map['services'],
        (e) => Service.fromJson(e),
      ),
      averageRating: SafeParser.dbl(map['averageRating']),
    );
  }

  static Data fallback() => Data(
    id: '',
    userId: UserId.fallback(),
    currentOrganization: '',
    specialtyId: SpecialtyId.fallback(),
    about: null,
    consultationFee: 0,
    verificationDocuments: const [],
    verificationStatus: '',
    isVerified: false,
    createdAt: null,
    updatedAt: null,
    v: 0,
    verificationNote: '',
    accountName: 'N/A',
    accountNumber: 'N/A',
    bankName: 'N/A',
    paystackRecipientCode: 'N/A',
    pendingPayouts: 0,
    recipientCreatedAt: null,
    totalEarnings: 0,
    totalPayouts: 0,
    totalExperienceYears: 0,
    dateOfBirth: null,
    services: const [],
    averageRating: 0.0,
  );
}

class Service {
  final String id;
  final String doctorId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Service({
    required this.id,
    required this.doctorId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Service.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Service(
      id: SafeParser.id(map['_id']),
      doctorId: SafeParser.id(map['doctorId']),
      name: SafeParser.str(map['name']),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
      v: SafeParser.intVal(map['__v']),
    );
  }

  static Service fallback() => Service(
    id: '',
    doctorId: '',
    name: '',
    createdAt: null,
    updatedAt: null,
    v: 0,
  );
}

class SpecialtyId {
  final String id;
  final String name;

  SpecialtyId({required this.id, required this.name});

  factory SpecialtyId.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return SpecialtyId(
      id: SafeParser.id(map['_id']),
      name: SafeParser.str(map['name']),
    );
  }

  static SpecialtyId fallback() => SpecialtyId(id: '', name: '');
}

class UserId {
  final String id;
  final String name;
  final String? phone;
  final String profileImage;
  final String? email;
  final String? timezone;

  UserId({
    required this.id,
    required this.name,
    this.phone,
    required this.profileImage,
    this.email,
    this.timezone,
  });

  factory UserId.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return UserId(
      id: SafeParser.id(map['_id']),
      name: SafeParser.str(map['name']),
      phone: SafeParser.nullableString(map['phone']),
      profileImage: SafeParser.str(map['profileImage']),
      email: SafeParser.nullableString(map['email']),
      timezone: SafeParser.nullableString(map['timezone']),
    );
  }

  static UserId fallback() =>
      UserId(id: '', name: '', phone: null, profileImage: '', email: null);
}
