/*
class PopularSpecialitesModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Specialities> data;
  final Meta meta;

  PopularSpecialitesModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory PopularSpecialitesModel.fromJson(Map<String, dynamic> json) =>
      PopularSpecialitesModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<Specialities>.from(
          json["data"].map((x) => Specialities.fromJson(x)),
        ),
        meta: Meta.fromJson(json["meta"]),
      );
}

class Specialities {
  final String id;
  final String name;
  final String description;
  final dynamic thumbnail;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Specialities({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Specialities.fromJson(Map<String, dynamic> json) => Specialities(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    thumbnail: json["thumbnail"] ?? '',
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
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

class PopularSpecialitesModel {
  final bool success;

  final int statusCode;

  final String message;

  final List<Specialities> data;

  final Meta meta;

  PopularSpecialitesModel({
    required this.success,

    required this.statusCode,

    required this.message,

    required this.data,

    required this.meta,
  });

  factory PopularSpecialitesModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return PopularSpecialitesModel(
      success: SafeParser.boolVal(map['success'], false),

      statusCode: SafeParser.intVal(map['statusCode']),

      message: SafeParser.str(map['message']),

      data: SafeParser.list<Specialities>(
        map['data'],

        (e) => Specialities.fromJson(e),
      ),

      meta:
          SafeParser.object<Meta>(map['meta'], (e) => Meta.fromJson(e)) ??
          Meta.fallback(),
    );
  }
}

class Specialities {
  final String id;

  final String name;

  final String description;

  final String thumbnail;

  final bool isActive;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final int v;

  Specialities({
    required this.id,

    required this.name,

    required this.description,

    required this.thumbnail,

    required this.isActive,

    required this.createdAt,

    required this.updatedAt,

    required this.v,
  });

  factory Specialities.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Specialities(
      id: SafeParser.str(map['_id']),

      name: SafeParser.str(map['name']),

      description: SafeParser.str(map['description']),

      thumbnail: SafeParser.str(map['thumbnail']),

      isActive: SafeParser.boolVal(map['isActive']),

      createdAt: SafeParser.date(map['createdAt']),

      updatedAt: SafeParser.date(map['updatedAt']),

      v: SafeParser.intVal(map['__v']),
    );
  }

  static Specialities fallback() => Specialities(
    id: '',

    name: '',

    description: '',

    thumbnail: '',

    isActive: false,

    createdAt: null,

    updatedAt: null,

    v: 0,
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
