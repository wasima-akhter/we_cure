class AllDateModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<AllDates> data;

  AllDateModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AllDateModel.fromJson(Map<String, dynamic> json) => AllDateModel(
    success: json["success"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: List<AllDates>.from(json["data"].map((x) => AllDates.fromJson(x))),
  );
}

class AllDates {
  final DateTime date;
  final String day;
  final int availableSlots;
  final int totalSlots;

  AllDates({
    required this.date,
    required this.day,
    required this.availableSlots,
    required this.totalSlots,
  });

  factory AllDates.fromJson(Map<String, dynamic> json) => AllDates(
    date: DateTime.parse(json["date"]),
    day: json["day"],
    availableSlots: json["availableSlots"],
    totalSlots: json["totalSlots"],
  );

  @override
  String toString() {
    return 'AllDates('
        'date: $date, '
        'day: $day, '
        'availableSlots: $availableSlots, '
        'totalSlots: $totalSlots'
        ')';
  }
}
