import 'package:glady/core/widgets/profile_avater_widget.dart';
import 'package:glady/views/chat/controller/chat_controller.dart';

import '../../../core/utils/basic_import.dart';
import '../../navigation/controller/navigation_controller.dart';
import '../controller/inbox_controller.dart';
import '../widget/img_preview.dart';
import '../widget/message_body.dart';
import '../widget/type_section.dart';

part 'inbox_screen_mobile.dart';

class InboxScreen extends GetView<InboxController> {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(mobile: InboxScreenMobile());
  }
}
