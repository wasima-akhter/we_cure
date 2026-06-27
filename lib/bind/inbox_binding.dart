import 'package:get/get.dart';

import '../views/inbox/controller/inbox_controller.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InboxController>(() => InboxController());
  }
}
