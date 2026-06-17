import 'package:intl/intl.dart';

class Helpers {
  static DateTime _toBDTime(String timestamp) {
    final utcTime = DateTime.parse(timestamp).toUtc();
    return utcTime.add(const Duration(hours: 6));
  }

  // Format timestamp for chat display
  static String formatTimestamp(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return DateFormat('hh:mm a').format(DateTime.now().toLocal());
    }

    try {
      final bdTime = _toBDTime(timestamp);
      final now = DateTime.now().toUtc().add(
        const Duration(hours: 6),
      ); // current BD time
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(bdTime.year, bdTime.month, bdTime.day);

      // Today → only time
      if (messageDate == today) {
        return DateFormat('hh:mm a').format(bdTime);
      }

      // Yesterday → "Yesterday hh:mm a"
      final yesterday = today.subtract(const Duration(days: 1));
      if (messageDate == yesterday) {
        return "Yesterday ${DateFormat('hh:mm a').format(bdTime)}";
      }

      // This week → Weekday + time
      final diff = today.difference(messageDate).inDays;
      if (diff < 7) {
        return DateFormat('EEEE hh:mm a').format(bdTime);
      }

      // Older → full date
      return DateFormat('dd MMM, hh:mm a').format(bdTime);
    } catch (e) {
      return DateFormat('hh:mm a').format(DateTime.now());
    }
  }

  static String formatDate(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return DateFormat('dd MMM yyyy').format(DateTime.now());
    }

    try {
      final bdTime = _toBDTime(timestamp);
      return DateFormat('dd MMM yyyy').format(bdTime);
    } catch (e) {
      return DateFormat('dd MMM yyyy').format(DateTime.now());
    }
  }

  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

//
class JsonHelper {
  static String getString(dynamic value, [String fallback = '']) {
    return value?.toString() ?? fallback;
  }

  static int getInt(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double getDouble(dynamic value, [double fallback = 0.0]) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool getBool(dynamic value, [bool fallback = false]) {
    if (value is bool) return value;
    return fallback;
  }

  static DateTime getDateTime(dynamic value) {
    if (value == null) return DateTime(1970);
    return DateTime.tryParse(value.toString()) ?? DateTime(1970);
  }

  static Map<String, dynamic> getMap(dynamic value) {
    return value is Map<String, dynamic> ? value : {};
  }

  static List<dynamic> getList(dynamic value) {
    return value is List ? value : [];
  }
}

String timeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.isNegative) {
    return 'Just now';
  }

  if (difference.inSeconds < 60) {
    return 'Just now';
  }

  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '$minutes minute${minutes > 1 ? 's' : ''} ago';
  }

  if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '$hours hour${hours > 1 ? 's' : ''} ago';
  }

  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  if (difference.inDays < 30) {
    final days = difference.inDays;
    return '$days day${days > 1 ? 's' : ''} ago';
  }

  if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  }

  final years = (difference.inDays / 365).floor();
  return '$years year${years > 1 ? 's' : ''} ago';
}
