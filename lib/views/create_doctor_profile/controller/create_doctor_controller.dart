import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/api/services/api_request.dart';

import '../../../routes/routes.dart';
import '../../aditional/model/sceciality_model.dart';

class CreateDoctorProfileController extends GetxController {
  final organizationController = TextEditingController();
  final aboutController = TextEditingController();
  final dobController = TextEditingController();

  Rx<DateTime?> selectedDob = Rx<DateTime?>(null);

  String initialDateOfBirth = '';

  RxString specialityId = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;

  RxList<Specialis> allSpecialist = <Specialis>[].obs;
  String accessToken = '';
  String email = '';

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      accessToken = Get.arguments['token'] ?? '';
      email = Get.arguments['email'] ?? '';
    }

    fetchSpecialist();
  }

  Future<SpecialistsModel> fetchSpecialist() async {
    return ApiRequest().get(
      fromJson: SpecialistsModel.fromJson,
      endPoint: ApiEndPoints.getSpecialties,
      isLoading: isLoading,
      onSuccess: (result) {
        final seen = <String>{};
        final unique = result.data.where((e) => seen.add(e.name)).toList();
        allSpecialist.assignAll(unique);
      },
    );
  }

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(1995),
    );

    if (date != null) {
      dobController.text =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  Future<BasicSuccessModel> createProfile() async {
    return ApiRequest().post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.createDoctorInfo,
      isLoading: isSubmitting,
      token: accessToken,
      body: {
        "currentOrganization": organizationController.text.trim(),
        "specialtyId": specialityId.value,
        "dateOfBirth": dobController.text.trim(),
        "about": aboutController.text.trim(),
      },
      onSuccess: (_) {
        Get.toNamed(Routes.uploadDocScreen, arguments: {"token": accessToken});
      },
    );
  }

  @override
  void onClose() {
    organizationController.dispose();
    aboutController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
