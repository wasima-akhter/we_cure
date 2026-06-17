part of '../screen/doctor_details_screen.dart';

class AppointmentSectionWidget extends StatelessWidget {
  final String days;
  final String time;
  final String price;
  final String slot;
  final String duration;

  const AppointmentSectionWidget({
    super.key,
    required this.days,
    required this.time,
    required this.price,
    required this.slot,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainSpaceBet,
      crossAxisAlignment: crossStart,
      children: [
        Row(
          crossAxisAlignment: crossStart,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: const Icon(
                Icons.circle_outlined,
                size: 22,
                color: Color(0xff006C93),
              ),
            ),
            Space.width.v10,
            Column(
              crossAxisAlignment: crossStart,
              children: [
                TextWidget(days, fontSize: Dimensions.titleSmall),

                Row(
                  children: [
                    // Icon(
                    //   Icons.hourglass_bottom_rounded,
                    //   size: 16.h,
                    //   color: CustomColors.secondaryDarkText,
                    // ),
                    CircleAvatar(
                      radius: 3.r,
                      backgroundColor: CustomColors.grayShade,
                    ),
                    Space.width.v10,
                    //
                    TextWidget(
                      time,
                      fontSize: Dimensions.titleSmall,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.grayShade,
                    ),
                  ],
                ),
                Space.height.v5,
                Row(
                  children: [
                    // Icon(
                    //   Icons.payment_outlined,
                    //   size: 16.h,
                    //   color: CustomColors.grayShade,
                    // ),
                    SafeSvgWidget(
                      assetPath: Assets.dummy.fee,
                      height: 14,
                      color: CustomColors.grayShade.withValues(alpha: 0.6),
                    ),

                    Space.width.v5,
                    TextWidget(
                      price,
                      fontSize: Dimensions.titleSmall,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.grayShade,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Space.width.v5,

        Column(
          crossAxisAlignment: crossEnd,
          children: [
            TextWidget(slot, fontSize: Dimensions.titleSmall),
            Space.width.v5,
            Row(
              children: [
                // Icon(
                //   Icons.timelapse_rounded,
                //   size: 16.h,
                //   color: CustomColors.secondaryDarkText,
                // ),
                Space.width.v5,
                TextWidget(
                  duration.shortDuration,
                  fontSize: Dimensions.titleSmall,
                  fontWeight: FontWeight.w400,
                  color: CustomColors.grayShade,
                ),
                Space.width.v5,
                Icon(
                  Icons.hourglass_bottom_rounded,
                  size: 14.h,
                  color: CustomColors.secondaryDarkText,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
