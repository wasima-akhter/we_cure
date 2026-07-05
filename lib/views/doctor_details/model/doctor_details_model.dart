/*
class DoctorDetailsInfoModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;

  DoctorDetailsInfoModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DoctorDetailsInfoModel.fromJson(Map<String, dynamic> json) =>
      DoctorDetailsInfoModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final Doctor doctor;
  final List<Service> services;
  final List<Experience> experiences;
  final Rating rating;
  final List<Review> reviews;
  final List<Availability> availability;

  Data({
    required this.doctor,
    required this.services,
    required this.experiences,
    required this.rating,
    required this.reviews,
    required this.availability,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    doctor: Doctor.fromJson(json["doctor"]),
    services: List<Service>.from(
      json["services"].map((x) => Service.fromJson(x)),
    ),
    experiences: List<Experience>.from(
      json["experiences"].map((x) => Experience.fromJson(x)),
    ),
    rating: Rating.fromJson(json["rating"]),
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    availability: List<Availability>.from(
      json["availability"].map((x) => Availability.fromJson(x)),
    ),
  );
}

class Availability {
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

  Availability({
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

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
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

class Doctor {
  final String id;
  final UserId userId;
  final String currentOrganization;
  final SpecialtyId specialtyId;
  final String about;
  final dynamic consultationFee;
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
  final String dateOfBirth;
  final int experienceYears;
  final int totalExperienceYears;

  Doctor({
    required this.id,
    required this.userId,
    required this.currentOrganization,
    required this.specialtyId,
    required this.about,
    required this.consultationFee,
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
    required this.dateOfBirth,
    required this.experienceYears,
    required this.totalExperienceYears,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json["_id"],
    userId: UserId.fromJson(json["userId"]),
    currentOrganization: json["currentOrganization"],
    specialtyId: SpecialtyId.fromJson(json["specialtyId"]),
    about: json["about"],
    consultationFee: json["consultationFee"],
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
    dateOfBirth: json["dateOfBirth"],
    experienceYears: json["experienceYears"],
    totalExperienceYears: json["totalExperienceYears"],
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
  final String? email;
  final String name;
  final String profileImage;

  UserId({
    required this.id,
    this.email,
    required this.name,
    required this.profileImage,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    profileImage: json["profileImage"],
  );
}

class Experience {
  final String id;
  final String doctorId;
  final String organizationName;
  final String designation;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Experience({
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

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json["_id"],
    doctorId: json["doctorId"],
    organizationName: json["organizationName"],
    designation: json["designation"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    isCurrent: json["isCurrent"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );
}

class Rating {
  final double average;
  final int total;
  final Map<String, int> breakdown;

  Rating({required this.average, required this.total, required this.breakdown});

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    average: json["average"]?.toDouble(),
    total: json["total"],
    breakdown: Map.from(
      json["breakdown"],
    ).map((k, v) => MapEntry<String, int>(k, v)),
  );
}

class Review {
  final String id;
  final String appointmentId;
  final UserId userId;
  final String doctorId;
  final int rating;
  final String reviewText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Review({
    required this.id,
    required this.appointmentId,
    required this.userId,
    required this.doctorId,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["_id"],
    appointmentId: json["appointmentId"],
    userId: UserId.fromJson(json["userId"]),
    doctorId: json["doctorId"],
    rating: json["rating"],
    reviewText: json["reviewText"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
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


*/
import '../../../core/helpers/helpers.dart';
import '../../../core/helpers/safe_parser_helper.dart';

class DoctorDetailsInfoModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;

  DoctorDetailsInfoModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });
  factory DoctorDetailsInfoModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DoctorDetailsInfoModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data:
          SafeParser.object<Data>(map['data'], (e) => Data.fromJson(e)) ??
          Data.fallback(),
    );
  }
}

class Data {
  final Doctor doctor;
  final List<Service> services;
  final List<Experience> experiences;
  final Rating rating;
  final List<Review> reviews;
  final List<Availability> availability;

  Data({
    required this.doctor,
    required this.services,
    required this.experiences,
    required this.rating,
    required this.reviews,
    required this.availability,
  });

  factory Data.fromJson(Map<String, dynamic>? json) => Data(
    doctor: Doctor.fromJson(JsonHelper.getMap(json?['doctor'])),

    rating: Rating.fromJson(JsonHelper.getMap(json?['rating'])),

    services: SafeParser.list<Service>(
      json?['services'],
      (e) => Service.fromJson(e),
    ),

    experiences: SafeParser.list<Experience>(
      json?['experiences'],
      (e) => Experience.fromJson(e),
    ),

    reviews: SafeParser.list<Review>(
      json?['reviews'],
      (e) => Review.fromJson(e),
    ),

    availability: SafeParser.list<Availability>(
      json?['availability'],
      (e) => Availability.fromJson(e),
    ),
  );

  static Data fallback() => Data(
    doctor: Doctor.fallback(),
    services: const [],
    experiences: const [],
    rating: Rating.fallback(),
    reviews: const [],
    availability: const [],
  );
}

class Availability {
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

  Availability({
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

  factory Availability.fromJson(Map<String, dynamic>? json) => Availability(
    id: JsonHelper.getString(json?['_id']),
    dayOfWeek: JsonHelper.getString(json?['dayOfWeek']),
    doctorId: JsonHelper.getString(json?['doctorId']),
    v: JsonHelper.getInt(json?['__v']),
    createdAt: JsonHelper.getDateTime(json?['createdAt']),
    endTime: JsonHelper.getString(json?['endTime']),
    fee: JsonHelper.getInt(json?['fee']),
    isActive: JsonHelper.getBool(json?['isActive']),
    slotSizeMinutes: JsonHelper.getInt(json?['slotSizeMinutes']),
    startTime: JsonHelper.getString(json?['startTime']),
    updatedAt: JsonHelper.getDateTime(json?['updatedAt']),
  );
  static Availability fallback() => Availability(
    id: '',
    dayOfWeek: '',
    doctorId: '',
    v: 0,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    endTime: '',
    fee: 0,
    isActive: false,
    slotSizeMinutes: 0,
    startTime: '',
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );
}

class Doctor {
  final String id;
  final UserId userId;
  final String currentOrganization;
  final SpecialtyId specialtyId;
  final String about;
  final dynamic consultationFee;
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
  final String dateOfBirth;
  final int experienceYears;
  final int totalExperienceYears;

  Doctor({
    required this.id,
    required this.userId,
    required this.currentOrganization,
    required this.specialtyId,
    required this.about,
    required this.consultationFee,
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
    required this.dateOfBirth,
    required this.experienceYears,
    required this.totalExperienceYears,
  });

  factory Doctor.fromJson(Map<String, dynamic>? json) => Doctor(
    id: JsonHelper.getString(json?['_id']),
    userId: UserId.fromJson(JsonHelper.getMap(json?['userId'])),
    currentOrganization: JsonHelper.getString(json?['currentOrganization']),
    specialtyId: SpecialtyId.fromJson(JsonHelper.getMap(json?['specialtyId'])),
    about: JsonHelper.getString(json?['about']),
    // consultationFee: SafeParser.intVal(map['consultationFee']),
    consultationFee: SafeParser.nullableDouble(json?['consultationFee']),
    verificationStatus: JsonHelper.getString(json?['verificationStatus']),
    isVerified: JsonHelper.getBool(json?['isVerified']),
    createdAt: JsonHelper.getDateTime(json?['createdAt']),
    updatedAt: JsonHelper.getDateTime(json?['updatedAt']),
    v: JsonHelper.getInt(json?['__v']),
    verificationNote: JsonHelper.getString(json?['verificationNote']),
    accountName: JsonHelper.getString(json?['accountName'], 'N/A'),
    accountNumber: JsonHelper.getString(json?['accountNumber'], 'N/A'),
    bankName: JsonHelper.getString(json?['bankName'], 'N/A'),
    paystackRecipientCode: JsonHelper.getString(
      json?['paystackRecipientCode'],
      'N/A',
    ),
    pendingPayouts: JsonHelper.getInt(json?['pendingPayouts']),
    recipientCreatedAt: json?['recipientCreatedAt'] != null
        ? JsonHelper.getDateTime(json?['recipientCreatedAt'])
        : null,
    totalEarnings: JsonHelper.getInt(json?['totalEarnings']),
    totalPayouts: JsonHelper.getInt(json?['totalPayouts']),
    dateOfBirth: JsonHelper.getString(json?['dateOfBirth']),
    experienceYears: JsonHelper.getInt(json?['experienceYears']),
    totalExperienceYears: JsonHelper.getInt(json?['totalExperienceYears']),
  );

  static Doctor fallback() => Doctor(
    id: '',
    userId: UserId.fallback(),
    currentOrganization: '',
    specialtyId: SpecialtyId.fallback(),
    about: '',
    consultationFee: 0,
    verificationStatus: '',
    isVerified: false,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
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
    dateOfBirth: '',
    experienceYears: 0,
    totalExperienceYears: 0,
  );
}

class SpecialtyId {
  final String id;
  final String name;

  SpecialtyId({required this.id, required this.name});
  factory SpecialtyId.fromJson(Map<String, dynamic>? json) => SpecialtyId(
    id: JsonHelper.getString(json?['_id']),
    name: JsonHelper.getString(json?['name']),
  );

  static SpecialtyId fallback() => SpecialtyId(id: '', name: '');
}

class UserId {
  final String id;
  final String? email;
  final String name;
  final String profileImage;
  final String timezone;

  UserId({
    required this.id,
    this.email,
    required this.name,
    required this.profileImage,
    required this.timezone,
  });

  factory UserId.fromJson(Map<String, dynamic>? json) => UserId(
    id: JsonHelper.getString(json?['_id']),
    email: SafeParser.nullableString(json?['email']),
    name: JsonHelper.getString(json?['name']),
    profileImage: JsonHelper.getString(json?['profileImage']),
    timezone: JsonHelper.getString(json?['timezone']),
  );

  static UserId fallback() =>
      UserId(id: '', email: null, name: '', profileImage: '', timezone: '');
}

class Experience {
  final String id;
  final String doctorId;
  final String organizationName;
  final String designation;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Experience({
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

  factory Experience.fromJson(Map<String, dynamic>? json) => Experience(
    id: JsonHelper.getString(json?['_id']),
    doctorId: JsonHelper.getString(json?['doctorId']),
    organizationName: JsonHelper.getString(json?['organizationName']),
    designation: JsonHelper.getString(json?['designation']),
    startDate: JsonHelper.getDateTime(json?['startDate']),
    endDate: JsonHelper.getDateTime(json?['endDate']),
    isCurrent: JsonHelper.getBool(json?['isCurrent']),
    createdAt: JsonHelper.getDateTime(json?['createdAt']),
    updatedAt: JsonHelper.getDateTime(json?['updatedAt']),
    v: JsonHelper.getInt(json?['__v']),
  );

  static Experience fallback() => Experience(
    id: '',
    doctorId: '',
    organizationName: '',
    designation: '',
    startDate: DateTime.fromMillisecondsSinceEpoch(0),
    endDate: DateTime.fromMillisecondsSinceEpoch(0),
    isCurrent: false,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    v: 0,
  );
}

class Rating {
  final double average;
  final int total;
  final Map<String, int> breakdown;

  Rating({required this.average, required this.total, required this.breakdown});

  factory Rating.fromJson(Map<String, dynamic>? json) => Rating(
    average: JsonHelper.getDouble(json?['average']),
    total: JsonHelper.getInt(json?['total']),
    breakdown: (json?['breakdown'] is Map)
        ? Map<String, int>.fromEntries(
            (json!['breakdown'] as Map).entries.map(
              (e) => MapEntry(e.key.toString(), JsonHelper.getInt(e.value)),
            ),
          )
        : {},
  );

  static Rating fallback() =>
      Rating(average: 0.0, total: 0, breakdown: const {});
}

class Review {
  final String id;
  final String appointmentId;
  final UserId userId;
  final String doctorId;
  final int rating;
  final String reviewText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Review({
    required this.id,
    required this.appointmentId,
    required this.userId,
    required this.doctorId,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Review.fromJson(Map<String, dynamic>? json) => Review(
    id: JsonHelper.getString(json?['_id']),
    appointmentId: JsonHelper.getString(json?['appointmentId']),
    userId: UserId.fromJson(JsonHelper.getMap(json?['userId'])),
    doctorId: JsonHelper.getString(json?['doctorId']),
    rating: JsonHelper.getInt(json?['rating']),
    reviewText: JsonHelper.getString(json?['reviewText']),
    createdAt: JsonHelper.getDateTime(json?['createdAt']),
    updatedAt: JsonHelper.getDateTime(json?['updatedAt']),
    v: JsonHelper.getInt(json?['__v']),
  );

  static Review fallback() => Review(
    id: '',
    appointmentId: '',
    userId: UserId.fallback(),
    doctorId: '',
    rating: 0,
    reviewText: '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    v: 0,
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

  factory Service.fromJson(Map<String, dynamic>? json) => Service(
    id: JsonHelper.getString(json?['_id']),
    doctorId: JsonHelper.getString(json?['doctorId']),
    name: JsonHelper.getString(json?['name']),
    createdAt: JsonHelper.getDateTime(json?['createdAt']),
    updatedAt: JsonHelper.getDateTime(json?['updatedAt']),
    v: JsonHelper.getInt(json?['__v']),
  );

  static Service fallback() => Service(
    id: '',
    doctorId: '',
    name: '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    v: 0,
  );
}
