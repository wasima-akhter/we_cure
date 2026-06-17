import '../utils/basic_import.dart';

class CustomSnackBar {
  static void success({
    required String title,
    required String message,
    void Function(GetSnackBar)? onTap,
  }) {
    final ctx = Get.overlayContext ?? Get.context;
    if (ctx == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.rawSnackbar(
        backgroundColor: CustomColors.primary,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize * 0.7,
          vertical: Dimensions.verticalSize * 0.3,
        ),
        padding: EdgeInsets.all(Dimensions.paddingSize * 0.45),
        borderRadius: Dimensions.radius * 1.5,
        messageText: CustomSnackbarContent(
          title: title,
          message: message,
          type: 'success',
        ),
        boxShadows: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 7,
            color: CustomColors.blackColor.withOpacity(0.05),
          ),
        ],
      );
    });
  }

  static void error(String message) {
    final ctx = Get.overlayContext ?? Get.context;
    if (ctx == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.rawSnackbar(
        backgroundColor: CustomColors.secondary,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize * 0.7,
          vertical: Dimensions.verticalSize * 0.3,
        ),
        padding: EdgeInsets.all(Dimensions.paddingSize * 0.45),
        borderRadius: Dimensions.radius * 1.5,
        messageText: CustomSnackbarContent(
          title: Strings.error,
          message: message,
          type: 'error',
        ),
        boxShadows: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 7,
            color: CustomColors.blackColor.withOpacity(0.05),
          ),
        ],
      );
    });
  }
}

// snackbar widget
class CustomSnackbarContent extends StatelessWidget {
  final String title, message, type;

  const CustomSnackbarContent({
    super.key,
    required this.title,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SafeSvgWidget(
          assetPath: type == 'success'
              ? Assets.icons.success
              : Assets.icons.reject,
          height: Dimensions.heightSize * 4.5,
        ),
        Space.width.v10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                title,
                color: CustomColors.whiteColor,
                fontSize: Dimensions.titleSmall * 0.8,
                fontWeight: FontWeight.w400,
              ),
              Space.height.v5,
              TextWidget(
                message
                    .replaceAll(RegExp(r'\['), '')
                    .replaceAll(RegExp(r'\]'), ''),
                color: CustomColors.whiteColor,
                fontSize: Dimensions.labelSmall * 0.9,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
