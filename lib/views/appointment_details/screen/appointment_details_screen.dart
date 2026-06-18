import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/core/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/bottom_sheet_dialog_widget.dart';
import '../../../widgets/doctor_details_card.dart';
import '../../../widgets/info_pair_row_widget.dart';
import '../../navigation/controller/navigation_controller.dart';
import '../controller/appointment_details_controller.dart';
import '../widget/user_details_profile_card.dart';

part 'appointment_details_screen_mobile.dart';

class AppointmentDetailsScreen extends GetView<AppointmentDetailsController> {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: AppointmentDetailsScreenMobile());
  }
}
