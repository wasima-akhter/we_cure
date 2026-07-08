import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/views/chat/screen/chat_screen.dart';
import 'package:glady/views/doctor_home/screen/doctor_home_screen.dart';
import 'package:glady/views/request_view/screen/request_view_screen.dart';

import '../../../core/utils/basic_import.dart';
import '../../appointment/screen/appointment_screen.dart';
import '../../find/screen/find_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../profile/screen/profile_screen.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find<NavigationController>();
  RxInt selectedIndex = 0.obs;
  final RxList<Widget> bodyScreen = <Widget>[].obs;

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

  void reloadScreens() {
    _initScreens();
    selectedIndex.value = 0;
    update();
  }

  void _initScreens() {
    final role = AppStorage.isUser;

    debugPrint('🔥 BUILDING SCREENS FOR ROLE: $role');

    if (role == 'USER') {
      bodyScreen.value = [
        HomeScreen(),
        FindScreen(),
        AppointmentScreen(),
        ChatScreen(),
        ProfileScreen(),
      ];
    } else {
      bodyScreen.value = [
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
