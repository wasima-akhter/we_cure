/*
class UserProfileModel {
  final bool success;
  final int statusCode;
  final String message;
  final UserData data;

  UserProfileModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
      );
}

class UserData {
  final String id;
  final String email;
  final int v;
  final DateTime createdAt;
  final dynamic emailVerificationOtp;
  final dynamic emailVerificationOtpExpires;
  final bool isEmailVerified;
  final String name;
  final String role;
  final String status;
  final DateTime updatedAt;
  final String refreshToken;
  final DateTime? dateOfBirth;
  final String? phone;
  final String profileImage;
  final dynamic passwordResetOtp;
  final dynamic passwordResetOtpExpires;
  final String bloodGroup;
  final List<String>? allergies;
  final String accountName;
  final String accountNumber;
  final String bankName;

  UserData({
    required this.id,
    required this.email,
    required this.v,
    required this.createdAt,
    required this.emailVerificationOtp,
    required this.emailVerificationOtpExpires,
    required this.isEmailVerified,
    required this.name,
    required this.role,
    required this.status,
    required this.updatedAt,
    required this.refreshToken,
    this.dateOfBirth,
    this.phone,
    required this.profileImage,
    required this.passwordResetOtp,
    required this.passwordResetOtpExpires,
    required this.bloodGroup,
    this.allergies,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["_id"] ?? '',
    email: json["email"] ?? '',
    v: json["__v"] ?? 0,
    createdAt: DateTime.parse(json["createdAt"]),
    emailVerificationOtp: json["emailVerificationOtp"],
    emailVerificationOtpExpires: json["emailVerificationOtpExpires"],
    isEmailVerified: json["isEmailVerified"] ?? false,
    name: json["name"] ?? '',
    role: json["role"] ?? '',
    status: json["status"] ?? '',
    updatedAt: DateTime.parse(json["updatedAt"]),
    refreshToken: json["refreshToken"] ?? '',
    dateOfBirth: json["dateOfBirth"] != null
        ? DateTime.parse(json["dateOfBirth"])
        : null,
    phone: json["phone"] ?? '',
    profileImage: json["profileImage"] ?? '',
    passwordResetOtp: json["passwordResetOtp"],
    passwordResetOtpExpires: json["passwordResetOtpExpires"],
    bloodGroup: json["bloodGroup"] ?? '',
    allergies: json["allergies"] != null
        ? List<String>.from(json["allergies"].map((x) => x))
        : [],
    accountName: json["accountName"] ?? '',
    accountNumber: json["accountNumber"] ?? '',
    bankName: json["bankName"] ?? '',
  );
}
*/

import '../../../core/helpers/safe_parser_helper.dart';

class UserProfileModel {
  final bool success;
  final int statusCode;
  final String message;
  final UserData data;

  UserProfileModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return UserProfileModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data:
          SafeParser.object<UserData>(
            map['data'],
            (e) => UserData.fromJson(e),
          ) ??
          UserData.fallback(),
    );
  }

  static UserProfileModel fallback() => UserProfileModel(
    success: false,
    statusCode: 0,
    message: '',
    data: UserData.fallback(),
  );
}

class UserData {
  final String id;
  final String email;
  final int v;
  final DateTime? createdAt;
  final String? emailVerificationOtp;
  final DateTime? emailVerificationOtpExpires;
  final bool isEmailVerified;
  final String name;
  final String role;
  final String status;
  final DateTime? updatedAt;
  final String refreshToken;
  final DateTime? dateOfBirth;
  final String? phone;
  final String profileImage;
  final String? passwordResetOtp;
  final DateTime? passwordResetOtpExpires;
  final String bloodGroup;
  final List<String> allergies;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String? timezone;

  UserData({
    required this.id,
    required this.email,
    required this.v,
    required this.createdAt,
    required this.emailVerificationOtp,
    required this.emailVerificationOtpExpires,
    required this.isEmailVerified,
    required this.name,
    required this.role,
    required this.status,
    required this.updatedAt,
    required this.refreshToken,
    required this.dateOfBirth,
    required this.phone,
    required this.profileImage,
    required this.passwordResetOtp,
    required this.passwordResetOtpExpires,
    required this.bloodGroup,
    required this.allergies,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    this.timezone,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return UserData(
      id: SafeParser.id(map['_id']),
      email: SafeParser.str(map['email']),
      v: SafeParser.intVal(map['__v']),
      createdAt: SafeParser.date(map['createdAt']),
      emailVerificationOtp: SafeParser.nullableString(
        map['emailVerificationOtp'],
      ),
      emailVerificationOtpExpires: SafeParser.date(
        map['emailVerificationOtpExpires'],
      ),
      isEmailVerified: SafeParser.boolVal(map['isEmailVerified']),
      name: SafeParser.str(map['name']),
      role: SafeParser.str(map['role']),
      status: SafeParser.str(map['status']),
      updatedAt: SafeParser.date(map['updatedAt']),
      refreshToken: SafeParser.str(map['refreshToken']),
      dateOfBirth: SafeParser.date(map['dateOfBirth']),
      phone: SafeParser.nullableString(map['phone']),
      profileImage: SafeParser.str(map['profileImage']),
      passwordResetOtp: SafeParser.nullableString(map['passwordResetOtp']),
      passwordResetOtpExpires: SafeParser.date(map['passwordResetOtpExpires']),
      bloodGroup: SafeParser.str(map['bloodGroup']),
      allergies: SafeParser.stringList(map['allergies']),
      accountName: SafeParser.str(map['accountName']),
      accountNumber: SafeParser.str(map['accountNumber']),
      bankName: SafeParser.str(map['bankName']),
      timezone: SafeParser.str(map['timezone']),
    );
  }

  static UserData fallback() => UserData(
    id: '',
    email: '',
    v: 0,
    createdAt: null,
    emailVerificationOtp: null,
    emailVerificationOtpExpires: null,
    isEmailVerified: false,
    name: '',
    role: '',
    status: '',
    updatedAt: null,
    refreshToken: '',
    dateOfBirth: null,
    phone: null,
    profileImage: '',
    passwordResetOtp: null,
    passwordResetOtpExpires: null,
    bloodGroup: '',
    allergies: const [],
    accountName: '',
    accountNumber: '',
    bankName: '',
    timezone: '',
  );
}
