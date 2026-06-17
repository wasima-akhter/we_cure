import 'dart:io';

import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/core/widgets/bottom_image_picker.dart';
import 'package:glady/core/widgets/date_picker_widget.dart';
import 'package:glady/core/widgets/profile_avater_widget.dart';

import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/custom_drop_down_widget.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/update_profile_controller.dart';
import '../update_profile_helper.dart';

part 'update_profile_screen_mobile.dart';

class UpdateProfileScreen extends GetView<UpdateProfileController> {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: UpdateProfileScreenMobile());
  }
}
