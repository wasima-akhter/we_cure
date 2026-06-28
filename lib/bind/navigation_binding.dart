import 'package:get/get.dart';
import 'package:glady/views/appointment/controller/appointment_controller.dart';
import 'package:glady/views/find/controller/find_controller.dart';
import 'package:glady/views/home/controller/home_controller.dart';
import 'package:glady/views/profile/controller/profile_controller.dart';

import '../views/chat/controller/chat_controller.dart';
import '../views/doctor_home/controller/doctor_home_controller.dart';
import '../views/navigation/controller/navigation_controller.dart';
import '../views/request_view/controller/request_view_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController(), permanent: true);
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FindController>(() => FindController());
    Get.lazyPut<AppointmentController>(() => AppointmentController());
    Get.put(ProfileController());

    Get.lazyPut<DoctorHomeController>(() => DoctorHomeController());
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<RequestViewController>(() => RequestViewController());
  }
}
