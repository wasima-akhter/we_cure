import 'package:glady/core/utils/app_storage.dart';
import 'package:intl/intl.dart';

import '../../../core/helpers/helpers.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/app_refresh_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/appointment_controller.dart';
import '../model/doctor_appoinment_model.dart';
import '../model/user_all_appoinment.dart';
import '../widget/appointment_card.dart';

part 'appointment_screen_mobile.dart';

class AppointmentScreen extends GetView<AppointmentController> {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: AppointmentScreenMobile());
  }
}
