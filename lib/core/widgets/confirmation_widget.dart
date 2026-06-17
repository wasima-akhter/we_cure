import '../utils/basic_import.dart';

class ConfirmationWidget extends StatelessWidget {
  final String? iconPath;
  final Widget? icon;
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final VoidCallback? onTap;

  const ConfirmationWidget({
    super.key,
    this.iconPath,
    this.icon,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: mainCenter,
        crossAxisAlignment: crossCenter,
        children: [
          if (icon != null)
            icon!
          else if (iconPath != null)
            SafeSvgWidget(assetPath: iconPath!),

          TextWidget(
            padding: EdgeInsets.only(
              top: Dimensions.heightSize * 2,
              bottom: Dimensions.heightSize,
            ),
            title,
            fontWeight: titleStyle?.fontWeight ?? FontWeight.bold,
            fontSize: titleStyle?.fontSize ?? Dimensions.titleMedium * 1.2,
            color: titleStyle?.color,
            textAlign: TextAlign.center,
          ),

          TextWidget(
            subtitle,
            textAlign: TextAlign.center,
            color: subtitleStyle?.color ?? CustomColors.grayShade,
            fontSize: subtitleStyle?.fontSize ?? Dimensions.titleSmall,
            maxLines: 2,
          ),

          Space.height.v30,

          PrimaryButtonWidget(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.defaultHorizontalSize,
              vertical: Dimensions.verticalSize,
            ),
            title: "Okay",
            onPressed: onTap ?? () => Get.offAllNamed(Routes.navigationScreen),
          ),
        ],
      ),
    );
  }
}
