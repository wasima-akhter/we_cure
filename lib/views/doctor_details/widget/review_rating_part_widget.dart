part of '../screen/doctor_details_screen.dart';

class ReviewRatingPartWidget extends GetView<DoctorDetailsController> {
  const ReviewRatingPartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final rating = controller.doctorDetailsInfoModel?.data.rating;
    final reviews = controller.doctorDetailsInfoModel?.data.reviews ?? [];
    if (rating == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: crossStart,
      children: [
        TextWidget('Review and Rating', fontSize: Dimensions.titleMedium * 1.2),
        Space.height.v10,

        TextWidget(
          'What others think about This Doctor',
          fontWeight: FontWeight.w400,
          maxLines: 1,
          // fontSize: Dimensions.titleLarge,
        ),
        Space.height.v10,

        // TextWidget('Review & Rating', fontSize: Dimensions.titleMedium * 1.2),
        // Space.height.v10,
        Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
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
                    i < rating.average.round() ? Icons.star : Icons.star_border,
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
            TextWidget(
              "${reviews.length} Review",
              fontSize: Dimensions.titleSmall,
            ),
          ],
        ),

        Space.height.v15,
        RatingsCard(),
      ],
    );
  }
}
