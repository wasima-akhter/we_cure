import '../../../core/utils/basic_import.dart';
import '../model/chat_message_model.dart';

class TextBubbleWidget extends StatelessWidget {
  final ChatMessageModel msg;

  const TextBubbleWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.72),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: msg.isMe ? CustomColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(msg.isMe ? 18.r : 4.r),
            bottomRight: Radius.circular(msg.isMe ? 4.r : 18.r),
          ),
        ),
        child: Text(
          msg.message,
          style: TextStyle(
            color: msg.isMe ? Colors.white : Colors.black87,
            fontSize: 14.sp,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
