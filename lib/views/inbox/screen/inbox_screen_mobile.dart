part of 'inbox_screen.dart';

class InboxScreenMobile extends GetView<InboxController> {
  const InboxScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            ProfileAvatarWidget(size: 40, imageUrl: controller.args.avatar),
            Space.width.v10,
            Column(
              crossAxisAlignment: crossStart,
              mainAxisSize: mainMin,
              children: [
                TextWidget(
                  controller.args.name,
                  fontSize: Dimensions.titleSmall,
                  fontWeight: FontWeight.w600,
                ),
                Obx(
                  () => controller.isTyping.value
                      ? TextWidget(
                          "typing...",
                          fontSize: Dimensions.labelSmall,
                          color: CustomColors.primary,
                          fontWeight: FontWeight.w400,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            if (Get.isRegistered<NavigationController>()) {
              Get.back(); // or pop until navigation screen if needed
              Get.find<NavigationController>().navigateToTab(3);
              if (Get.isRegistered<ChatController>()) {
                ChatController.to.getAllUserChatPerson();
              }
            } else {
              Get.back();
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: Dimensions.widthSize),
            padding: const EdgeInsets.only(left: 8),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffF8F8F8),
            ),
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: crossStart,
        children: [
          MessageBodyWidget(),
          SelectedImagePreviewWidget(),
          TypeSectionWidget(),
        ],
      ),
    );
  }
}
