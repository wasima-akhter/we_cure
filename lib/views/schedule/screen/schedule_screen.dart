import '../../../core/helpers/helpers.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/app_refresh_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/schedule_controller.dart';

part 'schedule_screen_mobile.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: ScheduleScreenMobile());
  }
}
