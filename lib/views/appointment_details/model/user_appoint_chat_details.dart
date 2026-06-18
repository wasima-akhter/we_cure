class UserAppointChatDetailsModel {
  final bool success;
  final int statusCode;
  final String message;
  final String conversationId;
  final Recipient recipient;
  final List<dynamic> data;
  final Meta meta;

  UserAppointChatDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.conversationId,
    required this.recipient,
    required this.data,
    required this.meta,
  });

  factory UserAppointChatDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserAppointChatDetailsModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      conversationId: json['conversationId'] ?? '',
      recipient: Recipient.fromJson(json['recipient'] ?? {}),
      data: json['data'] ?? [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class Recipient {
  final String id;
  final String role;
  final String name;
  final String image;

  Recipient({
    required this.id,
    required this.role,
    required this.name,
    required this.image,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 50,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
