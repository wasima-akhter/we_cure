import 'package:get/get.dart';

import '../views/video_call/controller/video_call_controller.dart';

class VideoCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoCallController>(() => VideoCallController(), fenix: true);
  }
}
