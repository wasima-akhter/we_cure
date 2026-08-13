import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/views/profile/controller/profile_controller.dart';

import '../../../core/constants/timezones.dart';
import '../../../core/helpers/image_compressor_helper.dart';
import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../update_profile_helper.dart';

class UpdateProfileController extends GetxController {
  static UpdateProfileController get to => Get.find();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  final allergyController = TextEditingController();

  Rx<DateTime?> selectedDob = Rx<DateTime?>(null);
  String initialDateOfBirth = '';
  RxList<String> allergiesList = <String>[].obs;

  Rx<XFile?> profileImage = Rx<XFile?>(null);
  RxBool isLoading = false.obs;

  final List<BloodGroup> bloodGroups = BloodGroup.values;

  final bloodController = TextEditingController();

  final Rxn<BloodGroup> selectedBloodGroup = Rxn<BloodGroup>();

  void setBloodGroup(String? value) {
    selectedBloodGroup.value = BloodGroupExtension.fromString(value);
    bloodController.text = value ?? '';
  }

  //
  final RxString timezone = 'Africa/Lagos'.obs;

  final List<String> timezones = Timezones.all;

  //
  @override
  void onInit() {
    super.onInit();
    prefillData();
  }

  // ============================================================
  // Validation
  // ============================================================

  bool validateProfile() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final dob = dobController.text.trim();

    if (name.isEmpty) {
      _showValidationSnackBar('Please enter your name');
      return false;
    }

    if (name.length < 2) {
      _showValidationSnackBar('Name must be at least 2 characters');
      return false;
    }

    if (phone.isEmpty) {
      _showValidationSnackBar('Please enter your phone number');
      return false;
    }

    if (!_isValidPhone(phone)) {
      _showValidationSnackBar('Please enter a valid phone number');
      return false;
    }

    if (dob.isEmpty) {
      _showValidationSnackBar('Please select your date of birth');
      return false;
    }

    if (!_isValidDate(dob)) {
      _showValidationSnackBar('Please enter a valid date of birth');
      return false;
    }

    if (_isFutureDate(dob)) {
      _showValidationSnackBar('Date of birth cannot be in the future');
      return false;
    }

    if (AppStorage.isUser == 'USER' && selectedBloodGroup.value == null) {
      _showValidationSnackBar('Please select your blood group');
      return false;
    }

    if (timezone.value.trim().isEmpty) {
      _showValidationSnackBar('Please select your timezone');
      return false;
    }

    return true;
  }

  bool _isValidPhone(String phone) {
    // Allows +, digits, spaces, hyphens and parentheses.
    // Adjust this if your backend requires a specific country format.
    final cleaned = phone.replaceAll(RegExp(r'[\s\-()]'), '');

    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleaned);
  }

  bool _isValidDate(String value) {
    try {
      final date = DateTime.parse(value);

      // Make sure DateTime.parse didn't normalize an invalid date.
      return date.toIso8601String().substring(0, 10) == value;
    } catch (_) {
      return false;
    }
  }

  bool _isFutureDate(String value) {
    try {
      final date = DateTime.parse(value);

      final today = DateTime.now();
      final currentDate = DateTime(today.year, today.month, today.day);

      return date.isAfter(currentDate);
    } catch (_) {
      return false;
    }
  }

  void _showValidationSnackBar(String message) {
    CustomSnackBar.error(title: 'Invalid information', message);
  }

  void prefillData() {
    final profileController = Get.find<ProfileController>();

    if (AppStorage.isUser == 'USER') {
      final data = profileController.userProfileModel?.data;
      if (data != null) {
        nameController.text = data.name;
        emailController.text = data.email;
        phoneController.text = data.phone ?? '';
        bloodController.text = data.bloodGroup;

        selectedBloodGroup.value = BloodGroupExtension.fromString(
          data.bloodGroup,
        );
        //
        initialDateOfBirth = data.dateOfBirth != null
            ? data.dateOfBirth!.toIso8601String().substring(0, 10)
            : '';
        dobController.text = initialDateOfBirth;
        if (data.allergies.isNotEmpty) {
          allergiesList.assignAll(data.allergies);
        }

        //
        timezone.value = data.timezone?.isNotEmpty == true
            ? data.timezone!
            : 'Africa/Lagos';
      }
    } else {
      final data = profileController.doctorProfileModel?.data;
      if (data != null) {
        nameController.text = data.userId.name ?? '';
        phoneController.text = data.userId.phone ?? '';
        initialDateOfBirth =
            (data.dateOfBirth != null && data.dateOfBirth!.length >= 10)
            ? data.dateOfBirth!.substring(0, 10)
            : '';
        dobController.text = initialDateOfBirth;

        //
        timezone.value = data.userId.timezone?.isNotEmpty == true
            ? data.userId.timezone!
            : 'Africa/Lagos';
      }
    }
  }

  void addAllergy() {
    final value = allergyController.text.trim();
    if (value.isEmpty) return;
    if (!allergiesList.contains(value)) {
      allergiesList.add(value);
    }
    allergyController.clear();
  }

  void removeAllergy(int index) {
    allergiesList.removeAt(index);
  }

  Future<BasicSuccessModel> doctorUpdateProfileProcess() async {
    File? compressedImage;

    try {
      if (profileImage.value != null) {
        compressedImage = await compressImage(profileImage.value!);
      }

      return await ApiRequest().multiMultipartRequest(
        reqType: 'PATCH',
        fromJson: BasicSuccessModel.fromJson,
        endPoint: ApiEndPoints.doctorUpdateProfile,
        isLoading: isLoading,
        body: {
          "name": nameController.text,
          "phone": phoneController.text,
          "dateOfBirth": dobController.text,
          "timezone": timezone.value,
        },
        showSuccessSnackBar: true,
        onSuccess: (result) {
          Get.find<ProfileController>().getDoctorProfile();
          Get.close(1);
        },
        files: compressedImage != null ? {'image': compressedImage} : {},
      );
    } finally {
      // Delete temporary compressed file
      if (compressedImage != null && profileImage.value != null) {
        try {
          if (compressedImage.path != profileImage.value!.path) {
            await compressedImage.delete();
          }
        } catch (_) {}
      }
    }
  }

  Future<BasicSuccessModel> userUpdateProfileProcess() async {
    if (!validateProfile()) {
      throw Exception('Profile validation failed');
    }

    File? compressedImage;

    try {
      if (profileImage.value != null) {
        compressedImage = await compressImage(profileImage.value!);
      }

      return await ApiRequest().multiMultipartRequest(
        reqType: 'PATCH',
        fromJson: BasicSuccessModel.fromJson,
        endPoint: ApiEndPoints.userUpdateProfile,
        isLoading: isLoading,
        body: {
          "name": nameController.text,
          "phone": phoneController.text,
          "dateOfBirth": dobController.text,
          "bloodGroup": selectedBloodGroup.value?.value,

          for (int i = 0; i < allergiesList.length; i++)
            "allergies[$i]": allergiesList[i],

          "timezone": timezone.value,
        },
        showSuccessSnackBar: true,
        onSuccess: (result) {
          Get.find<ProfileController>().getUserProfile();
          Get.close(1);
        },
        files: compressedImage != null ? {'image': compressedImage} : {},
      );
    } finally {
      // Delete temporary compressed file
      if (compressedImage != null && profileImage.value != null) {
        try {
          if (compressedImage.path != profileImage.value!.path) {
            await compressedImage.delete();
          }
        } catch (_) {}
      }
    }
  }

  //
}
