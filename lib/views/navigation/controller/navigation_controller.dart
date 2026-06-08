import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/views/chat/screen/chat_screen.dart';
import 'package:glady/views/doctor_home/screen/doctor_home_screen.dart';
import 'package:glady/views/request_view/screen/request_view_screen.dart';

import '../../../core/utils/basic_import.dart';
import '../../appointment/screen/appointment_screen.dart';
import '../../find/screen/find_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../profile/screen/profile_screen.dart';

/*
class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  late List<Widget> bodyScreen;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is int) {
      selectedIndex.value = Get.arguments;
    }

    if (AppStorage.isUser == 'USER') {
      bodyScreen = [
        HomeScreen(), // index 0
        FindScreen(), // index 1
        AppointmentScreen(), // index 2
        ChatScreen(), // index 3
        ProfileScreen(), // index 4
      ];
    } else {
      bodyScreen = [
        DoctorHomeScreen(), // index 0
        RequestViewScreen(), // index 1
        AppointmentScreen(), // index 2
        ChatScreen(), // index 3
        ProfileScreen(), // index 4
      ];
    }
  }

  void changeNavScreen(int index) {
    selectedIndex.value = index;
  }

  void goToHomeNav() => changeNavScreen(0);
  void goToSearchNav() => changeNavScreen(1);
  void goToAppointment() => changeNavScreen(2);
  void goToChat() => changeNavScreen(3);
  void goToProfile() => changeNavScreen(4);
}
*/
class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  late List<Widget> bodyScreen;

  @override
  void onInit() {
    super.onInit();
    _initScreens();

    // Set initial tab from arguments
    final args = Get.arguments;
    if (args != null && args is int) {
      selectedIndex.value = args;
    }
  }

  void _initScreens() {
    if (AppStorage.isUser == 'USER') {
      bodyScreen = [
        HomeScreen(),
        FindScreen(),
        AppointmentScreen(),
        ChatScreen(),
        ProfileScreen(),
      ];
    } else {
      bodyScreen = [
        DoctorHomeScreen(),
        RequestViewScreen(),
        AppointmentScreen(),
        ChatScreen(),
        ProfileScreen(),
      ];
    }
  }

  /// Call this from outside (e.g. appointment screen) instead of navigating
  void navigateToTab(int index) {
    selectedIndex.value = index;
  }

  void changeNavScreen(int index) => selectedIndex.value = index;
  void goToHomeNav() => changeNavScreen(0);
  void goToSearchNav() => changeNavScreen(1);
  void goToAppointment() => changeNavScreen(2);
  void goToChat() => changeNavScreen(3);
  void goToProfile() => changeNavScreen(4);
}
