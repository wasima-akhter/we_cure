import 'dart:io';

import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/views/profile/controller/profile_controller.dart';
import 'package:image_picker/image_picker.dart';

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
  @override
  void onInit() {
    super.onInit();
    prefillData();
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
    return ApiRequest().multiMultipartRequest(
      reqType: 'PATCH',
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.doctorUpdateProfile,
      isLoading: isLoading,
      body: {
        "name": nameController.text,
        "phone": phoneController.text,
        "dateOfBirth": dobController.text,
      },
      showSuccessSnackBar: true,
      onSuccess: (result) {
        Get.find<ProfileController>().getDoctorProfile();
        Get.close(1);
      },
      files: profileImage.value != null
          ? {'image': File(profileImage.value!.path)}
          : {},
    );
  }

  Future<BasicSuccessModel> userUpdateProfileProcess() async {
    return ApiRequest().multiMultipartRequest(
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
      },
      showSuccessSnackBar: true,
      onSuccess: (result) {
        Get.find<ProfileController>().getUserProfile();
        Get.close(1);
      },
      files: profileImage.value != null
          ? {'image': File(profileImage.value!.path)}
          : {},
    );
  }
}
