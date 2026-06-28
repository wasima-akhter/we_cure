import 'package:glady/core/widgets/app_refresh_widget.dart';
import 'package:glady/core/widgets/empty_data_widget.dart';
import 'package:glady/core/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

import '../../../core/helpers/helpers.dart';
import '../../../core/utils/basic_import.dart';
import '../controller/experience_controller.dart';

part 'experience_screen_mobile.dart';

class ExperienceScreen extends GetView<ExperienceController> {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: ExperienceScreenMobile());
  }
}
