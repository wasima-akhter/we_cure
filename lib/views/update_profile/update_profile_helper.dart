/// Blood Group Enum
enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
}

/// Extension for converting enum <-> string
extension BloodGroupExtension on BloodGroup {
  /// Enum to Blood Group String
  String get value {
    switch (this) {
      case BloodGroup.aPositive:
        return 'A+';
      case BloodGroup.aNegative:
        return 'A-';
      case BloodGroup.bPositive:
        return 'B+';
      case BloodGroup.bNegative:
        return 'B-';
      case BloodGroup.abPositive:
        return 'AB+';
      case BloodGroup.abNegative:
        return 'AB-';
      case BloodGroup.oPositive:
        return 'O+';
      case BloodGroup.oNegative:
        return 'O-';
    }
  }

  /// String to Enum
  static BloodGroup? fromString(String? value) {
    switch (value?.trim().toUpperCase()) {
      case 'A+':
        return BloodGroup.aPositive;
      case 'A-':
        return BloodGroup.aNegative;
      case 'B+':
        return BloodGroup.bPositive;
      case 'B-':
        return BloodGroup.bNegative;
      case 'AB+':
        return BloodGroup.abPositive;
      case 'AB-':
        return BloodGroup.abNegative;
      case 'O+':
        return BloodGroup.oPositive;
      case 'O-':
        return BloodGroup.oNegative;
      default:
        return null;
    }
  }
}
