import 'package:glady/core/widgets/empty_data_widget.dart';
import 'package:glady/views/inbox/widget/text_buble.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/helpers/helpers.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/profile_avater_widget.dart';
import '../controller/inbox_controller.dart';
import '../model/chat_message_model.dart';
import 'image_view.dart';

class MessageBodyWidget extends GetView<InboxController> {
  const MessageBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => controller.getOldMessages(),
        color: CustomColors.primary,
        child: Obx(() {
          if (controller.isLoading.value) return const InboxShimmerWidget();
          if (!controller.isLoading.value && controller.messagesList.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 150),
                Center(child: EmptyDataWidget()),
              ],
            );
          }

          return Stack(
            children: [
              ListView.builder(
                controller: controller.scrollController,
                reverse: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.horizontalSize * 0.5,
                  vertical: Dimensions.verticalSize * 0.3,
                ),
                itemCount:
                    controller.messagesList.length + 1, // ✅ +1 for loader
                itemBuilder: (context, index) {
                  // ✅ সবার উপরে pagination loader
                  if (index == controller.messagesList.length) {
                    return Obx(
                      () => controller.isPaginationLoading.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Center(
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.w,
                                    color: CustomColors.primary,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    );
                  }

                  final msg = controller
                      .messagesList[controller.messagesList.length - 1 - index];
                  final MessageType messageType = msg.type;
                  final bool isUploading = msg.isUploading ?? false;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: msg.isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!msg.isMe)
                          Padding(
                            padding: EdgeInsets.only(right: 8.0.w),
                            child: ProfileAvatarWidget(
                              size: 40.r,
                              imageUrl: controller.recipientInfo.value.image,
                            ),
                          ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: msg.isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (messageType == MessageType.image &&
                                  msg.images.isNotEmpty)
                                ImageViewGridWidget.imageViewGrid(
                                  images: msg.images,
                                  width: width,
                                  isUploading: isUploading,
                                  isMe: msg.isMe,
                                ),
                              if (messageType == MessageType.image &&
                                  msg.message.isNotEmpty)
                                Space.height.v5,
                              if (msg.message.isNotEmpty)
                                TextBubbleWidget(msg: msg),
                              Space.height.v5,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextWidget(
                                      Helpers.formatTimestamp(
                                        msg.createdAt.toString(),
                                      ), // ✅ DateFormat → Helpers
                                      color: Colors.grey[500],
                                      fontSize: 11.sp,
                                    ),
                                    if (msg.isMe)
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.w),
                                        child: Icon(
                                          msg.isSeen
                                              ? Icons.abc
                                              : Icons.done_all,
                                          size: 14.w,
                                          color: msg.isSeen
                                              ? Colors.blue[600]
                                              : Colors.grey[400],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

class InboxShimmerWidget extends StatelessWidget {
  const InboxShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1200),
      child: SafeArea(
        child: Column(
          children: [
            Space.height.v20,
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.horizontalSize * 0.5,
                  vertical: Dimensions.verticalSize * 0.3,
                ),
                itemCount: 16,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final isMe = index % 2 == 0;

                  return Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Padding(
                          padding: EdgeInsets.only(right: 8.0.w),
                          child: CircleAvatar(
                            radius: 25.r,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.4,
                              height: 25.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            Space.height.v5,
                            Container(
                              width: width * 0.15,
                              height: 15.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
