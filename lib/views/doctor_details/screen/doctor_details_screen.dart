import 'package:glady/core/utils/extensions.dart';
import 'package:glady/core/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

import '../../../core/helpers/helpers.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/empty_data_widget.dart';
import '../../../core/widgets/profile_avater_widget.dart';
import '../../../widgets/doctor_details_card.dart';
import '../controller/doctor_details_controller.dart';
import '../helper/helper.dart';
import '../model/doctor_details_model.dart';
import '../widget/booking_dialog.dart';
import '../widget/ratings_card.dart';

part '../widget/about_des_widget.dart';
part '../widget/appointment_section_widget.dart';
part '../widget/experience_part_widget.dart';
part '../widget/review_rating_part_widget.dart';
part '../widget/service_part_widget.dart';
part 'doctor_details_screen_mobile.dart';

class DoctorDetailsScreen extends GetView<DoctorDetailsController> {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: DoctorDetailsScreenMobile());
  }
}
