import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/utils/app_storage.dart';

import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../../profile/controller/profile_controller.dart';

class AboutController extends GetxController {
  final aboutController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _prefillData();
  }

  void _prefillData() {
    final profileController = Get.find<ProfileController>();
    final data = profileController.doctorProfileModel?.data;
    if (data != null) {
      aboutController.text = data.about ?? '';
    }
  }

  RxBool isLoading = false.obs;

  Future<BasicSuccessModel> updateAbout() async {
    return ApiRequest().patch(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.doctorUpdateProfile,
      isLoading: isLoading,
      body: {"about": aboutController.text},
      showSuccessSnackBar: true,
      onSuccess: (result) {
        Get.close(1);

        if (Get.isRegistered<ProfileController>()) {
          if (AppStorage.isUser != "USER")
            ProfileController.to.getDoctorProfile();
        }

        _prefillData();
      },
    );
  }
}
