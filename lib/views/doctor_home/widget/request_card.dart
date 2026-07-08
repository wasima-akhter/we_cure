import '../../../core/utils/basic_import.dart';

class RequestCard extends StatelessWidget {
  final String name;
  final String service;
  final String time;
  final String status;
  final String buttonTitle;
  final VoidCallback? onTap;
  final VoidCallback? cardOnTap;

  const RequestCard({
    super.key,
    required this.name,
    required this.service,
    required this.time,
    required this.status,
    this.onTap,
    this.cardOnTap,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cardOnTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize,
          vertical: Dimensions.verticalSize * 0.8,
        ),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          border: Border.all(color: CustomColors.borderColor),
          borderRadius: BorderRadius.circular(Dimensions.radius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    time,
                    fontSize: Dimensions.titleMedium,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 2.h),
                  TextWidget(
                    service.capitalizeSafe,
                    fontSize: Dimensions.titleSmall,
                    fontWeight: FontWeight.w500,
                  ),
                  Space.height.v10,
                  // TextWidget(
                  //   time,
                  //   fontSize: Dimensions.titleSmall,
                  //   fontWeight: FontWeight.w500,
                  //   color: CustomColors.blackColor.withOpacity(0.7),
                  // ),
                  TextWidget(
                    status,
                    fontSize: Dimensions.titleSmall * 0.9,
                    fontWeight: FontWeight.w500,
                    color: CustomColors.blackColor.withOpacity(0.7),
                  ),
                ],
              ),
            ),

            // Join Button
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize * 1.6,
                  vertical: Dimensions.verticalSize * 0.5,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primary,
                  borderRadius: BorderRadius.circular(Dimensions.radius),
                ),
                child: TextWidget(
                  buttonTitle,
                  color: CustomColors.whiteColor,
                  fontSize: Dimensions.titleMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
