import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../../core/api/model/basic_success_model.dart';
import '../../../../core/api/services/auth_services.dart';
import '../../../../core/constants/timezones.dart';
import '../../../../core/utils/basic_import.dart';

class DoctorRegisterController extends GetxController {
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final idFocus = FocusNode();

  final passController = TextEditingController();
  final passConfirmController = TextEditingController();
  final confirmPasswordFocus = FocusNode();

  // email
  final emailController = TextEditingController();
  final emailFocus = FocusNode();
  final isEmailValid = false.obs;

  // password
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();
  final isPasswordValid = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  final isCheck = false.obs;

  //Register api
  RxBool isLoading = false.obs;

  // Timezone
  final RxString selectedTimezone = 'Africa/Lagos'.obs;

  final List<String> timezones = Timezones.all;

  @override
  void onInit() {
    super.onInit();
    _loadDeviceTimezone();
  }

  Future<void> _loadDeviceTimezone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();

      if (timezones.contains(timezone)) {
        selectedTimezone.value = timezone.identifier;
      } else {
        selectedTimezone.value = 'Africa/Lagos';
      }
    } catch (_) {
      selectedTimezone.value = 'Africa/Lagos';
    }
  }

  //Register api
  Future<BasicSuccessModel> registerProcess() async {
    return await AuthService.registerService(
      isLoading: isLoading,
      fullName: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: 'DOCTOR',
      doctorId: idController.text.trim(),
      timezone: selectedTimezone.value,
    );
  }
}
