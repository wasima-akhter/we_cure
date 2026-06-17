import '../utils/basic_import.dart';

class SocialLoginButtonWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final double? radius;
  final VoidCallback onTap;

  const SocialLoginButtonWidget({
    super.key,
    required this.iconPath,
    required this.title,
    this.radius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveRadius = radius ?? Dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: Dimensions.heightSize * 0.2),
        height: Dimensions.buttonHeight * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(effectiveRadius),
          border: Border.all(color: CustomColors.primary, width: 1.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeSvgWidget(assetPath: iconPath),
            TextWidget(title, padding: Dimensions.widthSize.edgeLeft),
          ],
        ),
      ),
    );
  }
}
