import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SupperEdgeInsets on num {
  /// EdgeInsets
  EdgeInsets get edgeHorizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get edgeVertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get edgeTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get edgeBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get edgeLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get edgeRight => EdgeInsets.only(right: toDouble());

  /// BorderRadius
  BorderRadius get radiusEx => BorderRadius.circular(toDouble());
  BorderRadius get radiusTopEx => BorderRadius.only(
    topLeft: Radius.circular(toDouble()),
    topRight: Radius.circular(toDouble()),
  );
}

extension StringsExtension on String {
  String get capitalizeSafe {
    if (trim().isEmpty) return '';

    return GetUtils.capitalize(trim()) ?? '';
  }

  String get shortDuration {
    final value = trim();

    if (value.isEmpty) return '';

    return value
        .replaceAll(RegExp(r'\bMinutes?\b', caseSensitive: false), 'min')
        .replaceAll(RegExp(r'\bHours?\b', caseSensitive: false), 'hr')
        .replaceAll(RegExp(r'\bSeconds?\b', caseSensitive: false), 'sec');
  }
}
