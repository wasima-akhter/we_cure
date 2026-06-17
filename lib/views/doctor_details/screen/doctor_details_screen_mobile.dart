part of 'doctor_details_screen.dart';

class DoctorDetailsScreenMobile extends GetView<DoctorDetailsController> {
  const DoctorDetailsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => controller.isLoading.value
            ? SizedBox.shrink()
            : PrimaryButtonWidget(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize,
                  vertical: Dimensions.verticalSize,
                ),
                title: "Book Appointment",
                onPressed: () {
                  Get.dialog(const BookingDialog(), barrierDismissible: true);
                },
              ),
      ),
      appBar: CommonAppBar(title: "Doctor Details"),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? LoadingWidget()
              : _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final doctor = controller.doctorDetailsInfoModel?.data.doctor;
    final availability =
        controller.doctorDetailsInfoModel?.data.availability ?? [];

    return SafeArea(
      child: RefreshIndicator(
        color: CustomColors.primary,

        onRefresh: () => controller.refreshDoctorDetails(),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
          children: [
            Space.height.v10,

            // Doctor Card
            DoctorDetailsCard(
              // name: (doctor?.userId.name).orPlaceholder(
              //   DoctorUiFallback.doctorName,
              // ),

              // specialty: (doctor?.specialtyId.name).orPlaceholder(
              //   DoctorUiFallback.specialty,
              // ),

              // clinicName: (doctor?.currentOrganization).orPlaceholder(
              //   DoctorUiFallback.organization,
              // ),

              // imageUrl: doctor?.userId.profileImage.hasValue == true
              //     ? doctor!.userId.profileImage
              //     : DoctorUiFallback.profileImage,

              //
              imageUrl: doctor?.userId.profileImage.hasValue == true
                  ? doctor!.userId.profileImage
                  : DoctorUiFallback.profileImage,

              name: (doctor?.userId.name).orNA(DoctorUiFallback.doctorName),

              specialty: (doctor?.specialtyId.name).orNA(
                DoctorUiFallback.specialty,
              ),

              clinicName: (doctor?.currentOrganization).orNA(
                DoctorUiFallback.organization,
              ),

              rating:
                  controller.doctorDetailsInfoModel?.data.rating.average ?? 0.0,

              yearsOfExperience: doctor?.totalExperienceYears ?? 0,

              startingPrice: (doctor?.consultationFee ?? 0).toDouble(),
              // prev values
              // imageUrl: doctor?.userId.profileImage.isNotEmpty == true
              //     ? doctor!.userId.profileImage
              //     : 'https://raw.githubusercontent.com/ai-py-auto/souce/refs/heads/main/Rectangle%202.png',
              // name: doctor?.userId.name ?? '',
              // specialty: doctor?.specialtyId.name ?? '',
              // clinicName: doctor?.currentOrganization ?? '',
              // rating: controller.doctorDetailsInfoModel?.data.rating.average ?? 0.0,
              // yearsOfExperience: doctor?.totalExperienceYears ?? 0,
              // startingPrice: (doctor?.consultationFee ?? 0).toDouble(),
              onTap: () {},
            ),

            Space.height.v15,

            // Availability
            if (availability.isNotEmpty) ...[
              TextWidget(
                "Appointment Consultation Time",
                fontSize: Dimensions.titleMedium,
                fontWeight: FontWeight.w600,
              ),
              Space.height.v15,
              ...availability.map(
                (slot) => Padding(
                  padding: EdgeInsets.only(
                    bottom: Dimensions.verticalSize * 0.25,
                  ),
                  child: AppointmentSectionWidget(
                    days: slot.dayOfWeek,
                    time: "${slot.startTime} - ${slot.endTime}",
                    price: "\$${slot.fee}",
                    slot:
                        "${(slot.slotSizeMinutes > 0 ? ((int.tryParse(slot.endTime.split(':')[0]) ?? 0) - (int.tryParse(slot.startTime.split(':')[0]) ?? 0)) * 60 ~/ slot.slotSizeMinutes : 0)} Slot",
                    duration: "${slot.slotSizeMinutes} Minutes",
                  ),
                ),
              ),
              Space.height.v20,
            ] else
              TextWidget(
                "Consultation schedule not available",
                color: CustomColors.secondaryDarkText,
              ),

            AboutDesWidget(),
            Space.height.v20,

            ServicePartWidget(),
            Space.height.v20,

            ExperiencePartWidget(),
            Space.height.v15,
            ReviewRatingPartWidget(),
            Space.height.v15,

            // Reviews List
            ...(controller.doctorDetailsInfoModel?.data.reviews
                    .take(2)
                    .map(
                      (review) => Padding(
                        padding: EdgeInsets.only(
                          bottom: Dimensions.verticalSize * 0.5,
                        ),
                        child: _ReviewCard(review: review),
                      ),
                    )
                    .toList() ??
                []),

            // Read All Reviews Button
            if ((controller.doctorDetailsInfoModel?.data.reviews.length ?? 0) >
                0)
              GestureDetector(
                onTap: () => Get.toNamed(
                  Routes.allReviewScreen,
                  arguments: controller.doctorDetailsInfoModel?.data.doctor.id,
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.verticalSize * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F8F8),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 1.5,
                    ),
                  ),
                  child: TextWidget(
                    "Read all reviews",
                    color: CustomColors.primary,
                  ),
                ),
              ),

            Space.height.v15,
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius),
        border: Border.all(color: CustomColors.grayShade.withOpacity(0.15)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: Dimensions.verticalSize * 0.8,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Row(
            children: [
              ProfileAvatarWidget(
                size: 36,
                imageUrl: review.userId.profileImage,
              ),
              Space.width.v10,
              Expanded(
                child: TextWidget(
                  review.userId.name,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.titleSmall,
                ),
              ),
              TextWidget(
                timeAgo(review.createdAt),
                fontSize: Dimensions.labelSmall,
                color: CustomColors.secondaryDarkText,
              ),
            ],
          ),
          Space.height.v10,
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating ? Icons.star : Icons.star_border,
                size: 16.sp,
                color: const Color(0xFFFF9500),
              ),
            ),
          ),
          Space.height.v10,
          TextWidget(
            review.reviewText,
            fontWeight: FontWeight.w400,
            fontSize: Dimensions.titleSmall,
            color: CustomColors.secondaryDarkText,
          ),
        ],
      ),
    );
  }
}
