/*

class DeleteResponse {
  final bool success;
  final String message;
  final DeleteData data;

  DeleteResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeleteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteResponse(
      success: json['success'],
      message: json['message'],
      data: DeleteData.fromJson(json['data']),
    );
  }
}

class DeleteData {
  final bool acknowledged;
  final int deletedCount;

  DeleteData({required this.acknowledged, required this.deletedCount});

  factory DeleteData.fromJson(Map<String, dynamic> json) {
    return DeleteData(
      acknowledged: json['acknowledged'],
      deletedCount: json['deletedCount'],
    );
  }
}


*/

import '../../../core/helpers/safe_parser_helper.dart';

class DeleteResponse {
  final bool success;
  final String message;
  final DeleteData data;

  DeleteResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeleteResponse.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DeleteResponse(
      success: SafeParser.boolVal(map['success']),
      message: SafeParser.str(map['message']),
      data:
          SafeParser.object<DeleteData>(
            map['data'],
            (e) => DeleteData.fromJson(e),
          ) ??
          DeleteData.fallback(),
    );
  }
}

class DeleteData {
  final bool acknowledged;
  final int deletedCount;

  DeleteData({required this.acknowledged, required this.deletedCount});

  factory DeleteData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DeleteData(
      acknowledged: SafeParser.boolVal(map['acknowledged']),
      deletedCount: SafeParser.intVal(map['deletedCount']),
    );
  }

  static DeleteData fallback() =>
      DeleteData(acknowledged: false, deletedCount: 0);
}
