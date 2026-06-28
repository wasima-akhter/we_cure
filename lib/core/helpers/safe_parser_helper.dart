/*
class SafeParser {
  const SafeParser._();

  // ---------- String ----------

  static String str(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;

    final result = value.toString().trim();

    if (result.isEmpty || result.toLowerCase() == 'null') {
      return fallback;
    }

    return result;
  }

  static String id(dynamic value) {
    return str(value);
  }

  static String? nullableString(dynamic value) {
    final result = str(value);

    return result.isEmpty ? null : result;
  }

  // ---------- Numbers ----------

  static int intVal(dynamic value, [int fallback = 0]) {
    if (value == null) return fallback;

    if (value is int) return value;

    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ?? fallback;
  }

  static int? nullableInt(dynamic value) {
    if (value == null) return null;

    final strValue = value.toString().trim();

    if (strValue.isEmpty || strValue.toLowerCase() == 'null') {
      return null;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(strValue);
  }

  static double dbl(dynamic value, [double fallback = 0.0]) {
    if (value == null) return fallback;

    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? fallback;
  }

  static double? nullableDouble(dynamic value) {
    if (value == null) return null;

    final strValue = value.toString().trim();

    if (strValue.isEmpty || strValue.toLowerCase() == 'null') {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(strValue);
  }

  // ---------- Bool ----------

  static bool boolVal(dynamic value, [bool fallback = false]) {
    if (value == null) return fallback;

    if (value is bool) return value;

    if (value is num) {
      return value == 1;
    }

    switch (value.toString().toLowerCase().trim()) {
      case 'true':
      case '1':
      case 'yes':
      case 'y':
        return true;

      case 'false':
      case '0':
      case 'no':
      case 'n':
        return false;

      default:
        return fallback;
    }
  }

  // ---------- Date ----------

  static DateTime? date(dynamic value) {
    if (value == null) return null;

    final strValue = value.toString().trim();

    if (strValue.isEmpty || strValue.toLowerCase() == 'null') {
      return null;
    }

    return DateTime.tryParse(strValue);
  }

  // ---------- Map ----------

  static Map<String, dynamic>? map(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  // ---------- Objects ----------

  static T? object<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final mapValue = map(value);

    if (mapValue == null) return null;

    try {
      return fromJson(mapValue);
    } catch (_) {
      return null;
    }
  }

  // ---------- Lists ----------

  static List<T> list<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static List<String> stringList(dynamic value) {
    if (value is! List) return const [];

    return value.where((e) => e != null).map((e) => e.toString()).toList();
  }

  static List<int> intList(dynamic value) {
    if (value is! List) return const [];

    return value.map((e) => nullableInt(e)).whereType<int>().toList();
  }

  static List<double> doubleList(dynamic value) {
    if (value is! List) return const [];

    return value.map((e) => nullableDouble(e)).whereType<double>().toList();
  }

  static List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // ---------- Enum ----------

  static T enumValue<T>(dynamic value, List<T> values, {required T fallback}) {
    final strValue = value?.toString().toLowerCase();

    for (final item in values) {
      if (item.toString().split('.').last.toLowerCase() == strValue) {
        return item;
      }
    }

    return fallback;
  }
}
*/

import 'package:intl/intl.dart';

class SafeParser {
  const SafeParser._();

  // ---------- String ----------

  static String str(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;

    final result = value.toString().trim();

    if (result.isEmpty || result.toLowerCase() == 'null') {
      return fallback;
    }

    return result;
  }

  static String id(dynamic value) => str(value);

  static String? nullableString(dynamic value) {
    final result = str(value);
    return result.isEmpty ? null : result;
  }

  // ---------- Numbers ----------

  static int intVal(dynamic value, [int fallback = 0]) {
    if (value == null) return fallback;

    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ?? fallback;
  }

  static int? nullableInt(dynamic value) {
    if (value == null) return null;

    final strValue = value.toString().trim();

    if (strValue.isEmpty || strValue.toLowerCase() == 'null') {
      return null;
    }

    if (value is num) return value.toInt();

    return int.tryParse(strValue);
  }

  static double dbl(dynamic value, [double fallback = 0.0]) {
    if (value == null) return fallback;

    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? fallback;
  }

  static double? nullableDouble(dynamic value) {
    if (value == null) return null;

    final strValue = value.toString().trim();

    if (strValue.isEmpty || strValue.toLowerCase() == 'null') {
      return null;
    }

    if (value is num) return value.toDouble();

    return double.tryParse(strValue);
  }

  // ---------- Bool ----------

  static bool boolVal(dynamic value, [bool fallback = false]) {
    if (value == null) return fallback;

    if (value is bool) return value;

    if (value is num) return value == 1;

    switch (value.toString().trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
      case 'y':
        return true;
      case 'false':
      case '0':
      case 'no':
      case 'n':
        return false;
      default:
        return fallback;
    }
  }

  // ---------- Date ----------

  static DateTime? date(dynamic value) {
    if (value == null) return null;

    final strValue = value.toString().trim();

    if (strValue.isEmpty || strValue.toLowerCase() == 'null') {
      return null;
    }

    return DateTime.tryParse(strValue);
  }

  /// Same as [date] but never returns null.
  static DateTime dateOrDefault(dynamic value, [DateTime? fallback]) {
    return date(value) ?? fallback ?? DateTime(1970);
  }

  /// Parses and formats a date directly.
  static String formatDate(
    dynamic value, {
    String pattern = 'dd MMM yyyy',
    String fallback = '',
  }) {
    final parsed = date(value);

    if (parsed == null) return fallback;

    return DateFormat(pattern).format(parsed.toLocal());
  }

  // ---------- Map ----------

  static Map<String, dynamic>? map(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (_) {}
    }

    return null;
  }

  static Map<String, dynamic> mapOrEmpty(dynamic value) {
    return map(value) ?? <String, dynamic>{};
  }

  // ---------- Objects ----------

  static T? object<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final mapValue = map(value);

    if (mapValue == null) return null;

    try {
      return fromJson(mapValue);
    } catch (_) {
      return null;
    }
  }

  // ---------- Lists ----------

  static List<dynamic> anyList(dynamic value) {
    return value is List ? value : const [];
  }

  static List<T> list<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static List<String> stringList(dynamic value) {
    if (value is! List) return const [];

    return value.where((e) => e != null).map((e) => e.toString()).toList();
  }

  static List<int> intList(dynamic value) {
    if (value is! List) return const [];

    return value.map(nullableInt).whereType<int>().toList();
  }

  static List<double> doubleList(dynamic value) {
    if (value is! List) return const [];

    return value.map(nullableDouble).whereType<double>().toList();
  }

  static List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // ---------- Enum ----------

  static T enumValue<T>(dynamic value, List<T> values, {required T fallback}) {
    final strValue = value?.toString().toLowerCase();

    for (final item in values) {
      if (item.toString().split('.').last.toLowerCase() == strValue) {
        return item;
      }
    }

    return fallback;
  }
}
