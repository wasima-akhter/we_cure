import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/custom_drop_down_widget.dart';
import '../../../core/widgets/date_picker_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/create_doctor_controller.dart';

part 'create_doctor_profile_mobile.dart';

class CreateDoctorProfileScreen extends GetView<CreateDoctorProfileController> {
  const CreateDoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: CreateDoctorProfileScreenMobile());
  }
}
