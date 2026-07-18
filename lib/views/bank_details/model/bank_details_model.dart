class BankDetailsModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data? data;

  BankDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) =>
      BankDetailsModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );
}

class Data {
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final String? bankCode;
  final bool? hasRecipient;

  Data({
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.bankCode,
    this.hasRecipient,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bankName: json["bankName"] ?? '',
    accountName: json["accountName"] ?? '',
    accountNumber: json["accountNumber"] ?? '',
    bankCode: json["bankCode"] ?? '',
    hasRecipient: json["hasRecipient"] ?? false,
  );
}
