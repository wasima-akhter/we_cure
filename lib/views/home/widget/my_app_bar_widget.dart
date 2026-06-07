part of '../screen/home_screen.dart';

class MyAppBarWidget extends GetView<HomeController> {
  const MyAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const double actionButtonSize = 45;
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimensions.defaultHorizontalSize,
          vertical: Dimensions.verticalSize * 0.1,
        ),
        child: Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            CustomLogoWidget(),
            // Wrap(
            //   alignment: WrapAlignment.center,
            //   crossAxisAlignment: WrapCrossAlignment.center,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.notificationScreen),
                  child: Container(
                    width: actionButtonSize,
                    height: actionButtonSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CustomColors.whiteColor,
                      border: Border.all(
                        color: CustomColors.disableColor.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      color: CustomColors.primary,
                      size: actionButtonSize / 2,
                    ),
                  ),
                ),
                Space.width.v10,
                Obx(() {
                  final profileController = Get.find<ProfileController>();
                  final isUser = AppStorage.isUser == 'USER';

                  final isLoading = isUser
                      ? profileController.getUserProfileLoading.value
                      : profileController.getDoctorProfileLoading.value;

                  final imageUrl = isUser
                      ? profileController.userProfileModel?.data.profileImage ??
                            ''
                      : profileController
                                .doctorProfileModel
                                ?.data
                                .userId
                                .profileImage ??
                            '';

                  return GestureDetector(
                    onTap: () => Get.find<NavigationController>().goToProfile(),
                    child: isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: actionButtonSize,
                              height: actionButtonSize,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ProfileAvatarWidget(
                            size: actionButtonSize,
                            imageUrl: imageUrl,
                          ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
