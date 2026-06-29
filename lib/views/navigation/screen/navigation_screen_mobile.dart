part of 'navigation_screen.dart';

class NavigationScreenMobile extends GetView<NavigationController> {
  const NavigationScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (controller.selectedIndex.value != 0) {
          controller.selectedIndex.value = 0;
        } else {
          // final shouldExit = await Get.dialog<bool>(
          //   _ExitConfirmationDialog(),
          //   barrierDismissible: false,
          // );
          Get.back(result: true);
          // if (shouldExit == true) {
          //   SystemNavigator.pop();
          // }
        }
      },
      child:
          // GetBuilder<NavigationController>(
          //   builder: (controller) {
          //     return Scaffold(
          //       body: controller.bodyScreen[controller.selectedIndex.value],
          // bottomNavigationBar: SizedBox(child: BottomNavWidget()),
          //     );
          //   },
          // );
          Scaffold(
            body: Obx(
              () => controller.bodyScreen.value[controller.selectedIndex.value],
            ),
            bottomNavigationBar: SizedBox(child: BottomNavWidget()),
          ),
    );
  }
}

class _ExitConfirmationDialog extends StatelessWidget {
  const _ExitConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(Dimensions.paddingSize),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.radius * 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.paddingSize * 0.6),
              decoration: BoxDecoration(
                color: CustomColors.rejected.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                size: Dimensions.iconSizeLarge * 2.5,
                color: CustomColors.rejected,
              ),
            ),
            Space.height.v20,
            TextWidget(
              'Exit App?',
              fontSize: Dimensions.headlineSmall * 0.9,
              fontWeight: FontWeight.w500,
              color: CustomColors.blackColor,
              textAlign: TextAlign.center,
            ),
            Space.height.v10,
            TextWidget(
              'Are you sure you want to exit the application?',
              fontSize: Dimensions.bodyMedium,
              fontWeight: FontWeight.w400,
              color: CustomColors.secondaryDarkText,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            Space.height.v30,
            Row(
              children: [
                Expanded(
                  child: PrimaryButtonWidget(
                    title: 'Cancel',
                    onPressed: () => Get.back(result: false),
                    buttonColor: Colors.grey.withOpacity(0.3),
                    buttonTextColor: Colors.black,
                    borderColor: Colors.transparent,
                    fontWeight: FontWeight.w500,
                    height: Dimensions.buttonHeight * 0.85,
                  ),
                ),
                Space.width.v10,
                Expanded(
                  child: PrimaryButtonWidget(
                    title: 'Exit',
                    onPressed: () => Get.back(result: true),
                    buttonColor: CustomColors.rejected,
                    buttonTextColor: CustomColors.whiteColor,

                    fontWeight: FontWeight.w500,
                    borderColor: CustomColors.rejected,
                    height: Dimensions.buttonHeight * 0.85,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
