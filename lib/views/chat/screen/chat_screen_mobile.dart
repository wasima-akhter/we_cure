import 'package:glady/core/widgets/loading_widget.dart';
import 'package:glady/core/widgets/profile_avater_widget.dart';

import '../../../core/helpers/helpers.dart';
import '../../../core/utils/basic_import.dart';
import '../controller/chat_controller.dart';

class ChatScreenMobile extends GetView<ChatController> {
  const ChatScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Chat',
        isBack: false,
        onTap: () {
          //

          print("to chat");
        },
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingWidget());
          }
          return Column(
            mainAxisSize: mainMin,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize,
                  vertical: Dimensions.heightSize,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.borderColor),
                  borderRadius: BorderRadius.circular(Dimensions.radius),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize,
                  vertical: Dimensions.verticalSize * 0.5,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: CustomColors.primary),
                    Space.width.v10,
                    Expanded(
                      // height: 80.h,
                      // width: 1.sw * 0.3,
                      child: TextField(
                        controller: controller.searchController,
                        focusNode: controller.searchFocusNode,
                        onChanged: controller.onSearchChanged,
                        onSubmitted: (_) {
                          controller.searchFocusNode.unfocus();
                        },
                        cursorColor: CustomColors.primary,
                        style: TextStyle(fontSize: Dimensions.titleSmall),
                        decoration: InputDecoration(
                          hintText: "Search by name...",
                          hintStyle: TextStyle(
                            color: CustomColors.secondaryDarkText,
                            fontSize: Dimensions.titleSmall,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (controller.searchQuery.value.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          controller.searchController.clear();
                          controller.onSearchChanged('');
                        },
                        child: Icon(
                          Icons.close,
                          color: CustomColors.secondaryDarkText,
                          size: Dimensions.iconSizeLarge,
                        ),
                      ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: RefreshIndicator(
                  color: CustomColors.primary,
                  onRefresh: () async {
                    await controller.getAllUserChatPerson();
                  },
                  child: controller.filteredList.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            Center(
                              child: TextWidget(
                                controller.searchQuery.value.isNotEmpty
                                    ? 'No results found for "${controller.searchQuery.value}"'
                                    : 'No conversations yet',
                                color: CustomColors.secondaryDarkText,
                                fontSize: Dimensions.titleSmall,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.defaultHorizontalSize,
                          ),
                          itemCount: controller.filteredList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = controller.filteredList[index];
                            final participant = item.participants.isNotEmpty
                                ? item.participants.first
                                : null;
                            final lastMsg = item.lastMessage.text;
                            final lastMsgImages = item.lastMessage.images;
                            debugPrint(
                              ' item.lastMessage: ${item.lastMessage} ',
                            );

                            final time = formatToHourMinPeriod(
                              item.lastMessage.createdAt,
                            );
                            // print(
                            //   "result.data. user id from User patient POV: ${item.id.toString()}",
                            // );

                            return Container(
                              margin: EdgeInsets.only(
                                bottom: Dimensions.heightSize,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: CustomColors.borderColor.withOpacity(
                                    0.8,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 1.5,
                                ),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.inboxScreen,
                                    arguments: {
                                      'conversationId': item.id,
                                      'receiverId': participant?.id ?? '',
                                      'receiverRole': participant?.role ?? '',
                                      'avatar': participant?.image ?? '',
                                      'name': participant?.name ?? '',
                                    },
                                  );
                                },
                                leading: ProfileAvatarWidget(
                                  imageUrl: participant?.image,
                                  size: 46,
                                ),
                                title: TextWidget(
                                  participant?.name ?? '',
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimensions.titleSmall,
                                ),
                                subtitle: Builder(
                                  builder: (_) {
                                    if (lastMsg.trim().isNotEmpty) {
                                      return TextWidget(
                                        lastMsg,
                                        fontWeight: FontWeight.w400,
                                        fontSize: Dimensions.labelMedium,
                                        color: CustomColors.secondaryDarkText,
                                        textOverflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      );
                                    }

                                    if (lastMsgImages.isNotEmpty &&
                                        lastMsgImages.first
                                            .toString()
                                            .isNotEmpty) {
                                      return Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 20.h,
                                            color: CustomColors.grayShade,
                                          ),
                                          const SizedBox(width: 4),
                                          TextWidget(
                                            lastMsgImages.length > 1
                                                ? "${lastMsgImages.length}"
                                                      ' images'
                                                : 'image',
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dimensions.labelMedium,
                                            color:
                                                CustomColors.secondaryDarkText,
                                          ),
                                        ],
                                      );
                                    }

                                    return TextWidget(
                                      'No messages yet',
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dimensions.labelMedium,
                                      color: CustomColors.secondaryDarkText,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    );
                                  },
                                ),
                                trailing: Column(
                                  mainAxisAlignment: mainCenter,
                                  crossAxisAlignment: crossEnd,
                                  children: [
                                    TextWidget(
                                      time,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dimensions.labelSmall,
                                      color: CustomColors.secondaryDarkText,
                                    ),
                                    if (!item.lastMessage.seen) ...[
                                      Space.height.v5,
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: BoxDecoration(
                                          color: CustomColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }
}
