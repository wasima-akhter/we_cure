import 'package:glady/core/widgets/loading_widget.dart';

import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/custom_drop_down_widget.dart';
import '../controller/bank_details_controller.dart';

part 'bank_details_screen_mobile.dart';

class BankDetailsScreen extends GetView<BankDetailsController> {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: BankDetailsScreenMobile());
  }
}
