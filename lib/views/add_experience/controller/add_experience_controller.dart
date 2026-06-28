import 'package:glady/views/experience/controller/experience_controller.dart';
import 'package:glady/views/experience/model/all_experience_model.dart';

import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../model/add_experience_model.dart';

class AddExperienceController extends GetxController {
  final organizationController = TextEditingController();
  final designationController = TextEditingController();

  RxBool isChecked = false.obs;
  RxBool isLoading = false.obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Experiences? editData;

  bool get isEditMode => editData != null;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Experiences) {
      editData = Get.arguments as Experiences;
      _prefill();
    }
  }

  void _prefill() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      organizationController.text = editData!.organizationName;
      designationController.text = editData!.designation;
      isChecked.value = editData!.isCurrent;
      startDate.value = editData!.startDate;
      if (!editData!.isCurrent) {
        endDate.value = editData!.endDate;
      }
    });
  }

  Future<AddExperienceModel> addExperience() async {
    if (!validateExperience()) {
      throw Exception('Validation failed');
    }
    return ApiRequest().post(
      fromJson: AddExperienceModel.fromJson,
      endPoint: ApiEndPoints.addExperiencesDoctor,
      isLoading: isLoading,
      body: {
        "organizationName": organizationController.text,
        "designation": designationController.text,
        "startDate": startDate.value?.toIso8601String().split('T').first ?? '',
        "endDate": isChecked.value
            ? null
            : endDate.value?.toIso8601String().split('T').first ?? '',
        "isCurrent": isChecked.value,
      },
      onSuccess: (result) {
        Get.close(1);
        Get.find<ExperienceController>().getAllExperience();
      },
    );
  }

  bool validateExperience() {
    if (organizationController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter the organization name.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (designationController.text.trim().isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: Text('Validation Error', style: CustomStyle.titleSmall),
        messageText: Text(
          'Please enter your designation.',
          style: CustomStyle.bodySmall,
        ),

        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (startDate.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a start date.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!isChecked.value && endDate.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select an end date.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!isChecked.value && endDate.value!.isBefore(startDate.value!)) {
      Get.snackbar(
        'Validation Error',
        'End date cannot be earlier than the start date.',
        backgroundColor: Colors.red,

        colorText: Colors.white,

        // '',
        // '',
        // titleText: Text('Validation Error', style: CustomStyle.titleSmall),
        // messageText: Text(
        //   'Please enter your designation.',
        //   style: CustomStyle.bodySmall,
        // ),

        // backgroundColor: Colors.grey.withValues(alpha: 0.5),
        // colorText: Colors.white,
        // snackStyle: SnackStyle.FLOATING,
        // snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  Future<AddExperienceModel> updateExperience() async {
    if (!validateExperience()) {
      throw Exception();
    }
    return ApiRequest().patch(
      fromJson: AddExperienceModel.fromJson,
      endPoint: '${ApiEndPoints.addExperiencesDoctor}/${editData!.id}',
      isLoading: isLoading,
      body: {
        "organizationName": organizationController.text,
        "designation": designationController.text,
        "startDate": startDate.value?.toIso8601String().split('T').first ?? '',
        "endDate": isChecked.value
            ? null
            : endDate.value?.toIso8601String().split('T').first ?? '',
        "isCurrent": isChecked.value,
      },
      onSuccess: (result) {
        Get.close(1);
        Get.find<ExperienceController>().getAllExperience();
      },
    );
  }

  @override
  void onClose() {
    organizationController.dispose();
    designationController.dispose();
    super.onClose();
  }
}
