class DoctorDashboardModel {
  final bool success;
  final int statusCode;
  final String message;
  final DashboardData data;

  const DoctorDashboardModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DoctorDashboardModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardModel(
      success: json['success'] as bool? ?? false,
      statusCode: _parseInt(json['statusCode']),
      message: json['message']?.toString() ?? '',
      data: DashboardData.fromJson(_asMap(json['data'])),
    );
  }
}

class DashboardData {
  final TodaySchedule today;
  final String nextSchedule;
  final ActiveAppointment? activeAppointment;
  final DashboardStats stats;
  final List<UpcomingAppointment> upcomingAppointments;

  const DashboardData({
    required this.today,
    required this.nextSchedule,
    this.activeAppointment,
    required this.stats,
    required this.upcomingAppointments,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final appointments = json['upcomingAppointments'];

    return DashboardData(
      today: TodaySchedule.fromJson(_asMap(json['today'])),
      nextSchedule: json['nextSchedule']?.toString() ?? '',
      activeAppointment: json['activeAppointment'] != null
          ? ActiveAppointment.fromJson(_asMap(json['activeAppointment']))
          : null,
      stats: DashboardStats.fromJson(_asMap(json['stats'])),
      upcomingAppointments: appointments is List
          ? appointments
                .whereType<Map>()
                .map(
                  (item) => UpcomingAppointment.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : [],
    );
  }
}

class TodaySchedule {
  final String date;
  final String dayName;
  final int slotCount;
  final String startTime;
  final String endTime;

  const TodaySchedule({
    required this.date,
    required this.dayName,
    required this.slotCount,
    required this.startTime,
    required this.endTime,
  });

  factory TodaySchedule.fromJson(Map<String, dynamic> json) {
    return TodaySchedule(
      date: json['date']?.toString() ?? 'N/A',
      dayName: json['dayName']?.toString() ?? 'N/A',
      slotCount: _parseInt(json['slotCount']),
      startTime: json['startTime']?.toString() ?? 'N/A',
      endTime: json['endTime']?.toString() ?? 'N/A',
    );
  }
}

class ActiveAppointment {
  final String id;
  final String timeRange;
  final String status;
  final String reasonTitle;

  const ActiveAppointment({
    required this.id,
    required this.timeRange,
    required this.status,
    required this.reasonTitle,
  });

  factory ActiveAppointment.fromJson(Map<String, dynamic> json) {
    return ActiveAppointment(
      id: json['_id']?.toString() ?? '',
      timeRange: json['timeRange']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      reasonTitle: json['reasonTitle']?.toString() ?? '',
    );
  }
}

class DashboardStats {
  final int bookingRequestCount;
  final int acceptedCount;

  const DashboardStats({
    required this.bookingRequestCount,
    required this.acceptedCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      bookingRequestCount: _parseInt(json['bookingRequestCount']),
      acceptedCount: _parseInt(json['acceptedCount']),
    );
  }
}

class UpcomingAppointment {
  final String id;
  final String patientName;
  final String reasonTitle;
  final String patientProfileImage;
  final String timeRange;
  final String date;
  final String status;

  const UpcomingAppointment({
    required this.id,
    required this.patientName,
    required this.reasonTitle,
    required this.patientProfileImage,
    required this.timeRange,
    required this.date,
    required this.status,
  });

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointment(
      id: json['_id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? '',
      reasonTitle: json['reasonTitle']?.toString() ?? '',
      patientProfileImage: json['patientProfileImage']?.toString() ?? '',
      timeRange: json['timeRange']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return {};
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
