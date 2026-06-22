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
