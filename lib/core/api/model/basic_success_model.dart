class BasicSuccessModel {
  final bool success;
  final String message;
  final dynamic data;

  BasicSuccessModel({required this.success, required this.message, this.data});

  factory BasicSuccessModel.fromJson(Map<String, dynamic> json) {
    return BasicSuccessModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      // data: _parseData(json['data'], null),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }
}

T? _parseData<T>(dynamic json, T Function(dynamic json)? fromData) {
  if (json == null) return null;

  try {
    if (fromData != null) {
      return fromData(json);
    }
    return json as T;
  } catch (_) {
    return null;
  }
}
