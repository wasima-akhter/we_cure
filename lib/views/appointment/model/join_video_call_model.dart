import 'dart:developer';

class JoinVideoCallModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;

  JoinVideoCallModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory JoinVideoCallModel.fromJson(Map<String, dynamic> json) =>
      JoinVideoCallModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final String appId;
  final String channel;
  final String token;

  Data({required this.appId, required this.channel, required this.token});
  factory Data.fromJson(Map<String, dynamic> json) {
    log("Data raw json: $json");
    log("appId type: ${json["appId"].runtimeType}");
    log("channel type: ${json["channel"].runtimeType}");
    log("token type: ${json["token"].runtimeType}");

    return Data(
      appId: json["appId"].toString(),
      channel: json["channel"].toString(),
      token: json["token"].toString(),
    );
  }
}
