import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../core/api/services/push_notification_service.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../appointment/helper/appointment_helper.dart';
import '../../home/screen/home_screen.dart';
import '../controller/doctor_home_controller.dart';
import '../widget/request_card.dart';

part 'doctor_home_screen_mobile.dart';
part '../widget/doctor_appointment_section_widget.dart';

class DoctorHomeScreen extends GetView<DoctorHomeController> {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: DoctorHomeScreenMobile());
  }
}
