part of '../screen/doctor_details_screen.dart';

class ReviewRatingPartWidget extends GetView<DoctorDetailsController> {
  const ReviewRatingPartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final rating = controller.doctorDetailsInfoModel?.data.rating;
    final reviews = controller.doctorDetailsInfoModel?.data.reviews ?? [];
    if (rating == null) return const SizedBox.shrink();

    final hasRating = rating.total > 0 && rating.average > 0;
    final hasReviews = reviews.isNotEmpty;
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        TextWidget('Review and Rating', fontSize: Dimensions.titleMedium * 1.2),
        Space.height.v10,

        if (!hasRating && !hasReviews)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.verticalSize,
              horizontal: Dimensions.defaultHorizontalSize,
            ),
            decoration: BoxDecoration(
              color: CustomColors.offWhite,
              borderRadius: BorderRadius.circular(Dimensions.radius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_outline_rounded,
                  size: Dimensions.iconSizeDefault,
                  color: CustomColors.grayShade,
                ),
                Space.width.v10,
                Expanded(
                  child: TextWidget(
                    "No ratings or reviews available yet",
                    fontSize: Dimensions.titleSmall,
                    color: CustomColors.secondaryDarkText,
                  ),
                ),
              ],
            ),
          )
        else ...[
          TextWidget(
            'What others think about This Doctor',
            fontWeight: FontWeight.w400,
            maxLines: 1,
            // fontSize: Dimensions.titleLarge,
          ),
          Space.height.v10,
          Row(
            mainAxisAlignment: mainSpaceBet,
            children: [
              if (hasRating)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextWidget(
                      rating.average.toStringAsFixed(1),
                      fontSize: Dimensions.bodyMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    Space.width.v10,

                    ...List.generate(
                      5,
                      (i) => Icon(
                        i < rating.average.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: const Color(0xffF29500),
                        size: Dimensions.iconSizeDefault * 1.125,
                      ),
                    ),

                    Space.width.add(4.w),

                    TextWidget(
                      '(${rating.total} Rating)',
                      fontSize: Dimensions.titleSmall * 0.8,
                    ),
                  ],
                ),

              if (hasReviews)
                TextWidget(
                  "${reviews.length} Review${reviews.length > 1 ? 's' : ''}",
                  fontSize: Dimensions.titleSmall,
                ),
            ],
          ),

          Space.height.v15,

          if (hasRating) RatingsCard(),
        ],
      ],
    );
  }
}
