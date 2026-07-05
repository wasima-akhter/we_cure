class AllTimeModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<AllTimes> data;

  AllTimeModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AllTimeModel.fromJson(Map<String, dynamic> json) => AllTimeModel(
    success: json["success"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: List<AllTimes>.from(json["data"].map((x) => AllTimes.fromJson(x))),
  );
}

class AllTimes {
  final String time;
  final bool isAvailable;
  final int fee;
  final int duration;
  final String? doctorTimezone;

  AllTimes({
    required this.time,
    required this.isAvailable,
    required this.fee,
    required this.duration,
    this.doctorTimezone,
  });

  factory AllTimes.fromJson(Map<String, dynamic> json) => AllTimes(
    time: json["time"],
    isAvailable: json["isAvailable"],
    fee: json["fee"],
    duration: json["duration"],
    doctorTimezone: json["doctorTimezone"],
  );
}
