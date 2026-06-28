/*

class CategoryDetailsModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Specialists> data;
  final Meta meta;

  CategoryDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) =>
      CategoryDetailsModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<Specialists>.from(
          json["data"].map((x) => Specialists.fromJson(x)),
        ),
        meta: Meta.fromJson(json["meta"]),
      );
}

class Specialists {
  final String id;
  final String currentOrganization;
  final String specialty;
  final int experienceYears;
  final int totalReviews;
  final String name;
  final String profileImage;
  final int? totalExperienceYears;
  final int? minFee;
  final double averageRating;

  Specialists({
    required this.id,
    required this.currentOrganization,
    required this.specialty,
    required this.experienceYears,
    required this.totalReviews,
    this.minFee,
    required this.name,
    required this.profileImage,
    this.totalExperienceYears,
    required this.averageRating,
  });

  factory Specialists.fromJson(Map<String, dynamic> json) => Specialists(
    id: json["_id"] ?? '',
    currentOrganization: json["currentOrganization"] ?? '',
    specialty: json["specialty"] ?? '',
    experienceYears: json["experienceYears"] ?? 0,
    totalReviews: json["totalReviews"] ?? 0,
    minFee: json["minFee"] ?? 0,
    name: json["name"] ?? '',
    profileImage: json["profileImage"] ?? '',
    totalExperienceYears: json["totalExperienceYears"] ?? 0,
    averageRating: (json["averageRating"] ?? 0).toDouble(),
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

class CategoryDetailsModel {
  final bool success;

  final int statusCode;

  final String message;

  final List<Specialists> data;

  final Meta meta;

  CategoryDetailsModel({
    required this.success,

    required this.statusCode,

    required this.message,

    required this.data,

    required this.meta,
  });

  factory CategoryDetailsModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return CategoryDetailsModel(
      success: SafeParser.boolVal(map['success']),

      statusCode: SafeParser.intVal(map['statusCode']),

      message: SafeParser.str(map['message']),

      data: SafeParser.list<Specialists>(
        map['data'],

        (e) => Specialists.fromJson(e),
      ),

      meta:
          SafeParser.object<Meta>(map['meta'], (e) => Meta.fromJson(e)) ??
          Meta.fallback(),
    );
  }
}

class Specialists {
  final String id;

  final String currentOrganization;

  final String specialty;

  final int experienceYears;

  final int totalReviews;

  final String name;

  final String profileImage;

  final int totalExperienceYears;

  final int minFee;

  final double averageRating;

  Specialists({
    required this.id,

    required this.currentOrganization,

    required this.specialty,

    required this.experienceYears,

    required this.totalReviews,

    required this.name,

    required this.profileImage,

    required this.totalExperienceYears,

    required this.minFee,

    required this.averageRating,
  });

  factory Specialists.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Specialists(
      id: SafeParser.str(map['_id']),

      currentOrganization: SafeParser.str(map['currentOrganization']),

      specialty: SafeParser.str(map['specialty']),

      experienceYears: SafeParser.intVal(map['experienceYears']),

      totalReviews: SafeParser.intVal(map['totalReviews']),

      name: SafeParser.str(map['name']),

      profileImage: SafeParser.str(map['profileImage']),

      totalExperienceYears: SafeParser.intVal(map['totalExperienceYears']),

      minFee: SafeParser.intVal(map['minFee']),

      averageRating: SafeParser.dbl(map['averageRating']),
    );
  }

  static Specialists fallback() => Specialists(
    id: '',

    currentOrganization: '',

    specialty: '',

    experienceYears: 0,

    totalReviews: 0,

    name: '',

    profileImage: '',

    totalExperienceYears: 0,

    minFee: 0,

    averageRating: 0.0,
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
