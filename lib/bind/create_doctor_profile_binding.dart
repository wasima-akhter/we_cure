import 'package:get/get.dart';
import 'package:glady/views/create_doctor_profile/controller/create_doctor_controller.dart';

class CreateDoctorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateDoctorProfileController>(
      () => CreateDoctorProfileController(),
    );
  }
}
