part of 'payment_screen.dart';

class PaymentScreenMobile extends GetView<PaymentController> {
  const PaymentScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorController = Get.find<DoctorDetailsController>();
    final bookController = Get.find<BookInfoController>();

    final selectedTimeData = doctorController.allTimeModel?.data
        .firstWhereOrNull((e) => e.time == doctorController.selectedTime.value);

    return Scaffold(
      bottomNavigationBar: PrimaryButtonWidget(
        title: 'Make payment',

        onPressed: () {
          controller.makePayment();
        },
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize,
          vertical: Dimensions.verticalSize,
        ),
      ),
      appBar: CommonAppBar(title: "Payment"),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            Space.height.v20,
            TextWidget(
              doctorController
                      .doctorDetailsInfoModel
                      ?.data
                      .doctor
                      .userId
                      .name ??
                  '',
              fontSize: Dimensions.titleMedium,
              fontWeight: FontWeight.w600,
            ),
            TextWidget(
              doctorController
                      .doctorDetailsInfoModel
                      ?.data
                      .doctor
                      .currentOrganization ??
                  '',
              fontSize: Dimensions.titleSmall,
              color: CustomColors.blackColor.withOpacity(0.5),
            ),

            Space.height.v20,
            TextWidget(
              "Visit Reason",
              fontSize: Dimensions.titleSmall,
              color: CustomColors.blackColor.withOpacity(0.5),
            ),
            Space.height.v5,
            TextWidget(
              bookController.reasonTitleController.text,
              fontWeight: FontWeight.w600,
            ),

            if (bookController.reasonDetailsController.text.isNotEmpty) ...[
              Space.height.v10,
              TextWidget(
                bookController.reasonDetailsController.text,
                fontSize: Dimensions.titleSmall,
                color: CustomColors.blackColor.withOpacity(0.8),
              ),
            ],

            Space.height.v20,
            AppointmentSectionWidget(
              days: doctorController.selectedDate.value,
              time: doctorController.selectedTime.value,
              price: selectedTimeData?.fee != null
                  ? '₦${selectedTimeData!.fee}'
                  : '',
              slot: '',
              duration: selectedTimeData?.duration != null
                  ? '${selectedTimeData!.duration} Minutes'
                  : '',
            ),

            Space.height.v20,
            if (bookController.selectedAttachments.isNotEmpty) ...[
              TextWidget("Attachment"),
              Space.height.v10,
              Wrap(
                spacing: Dimensions.widthSize,
                runSpacing: Dimensions.heightSize,
                children: List.generate(
                  bookController.selectedAttachments.length,
                  (index) {
                    final file = File(
                      bookController.selectedAttachments[index].path,
                    );
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CustomColors.disableColor.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.radius),
                      ),
                      height: 100.h,
                      width: 100.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radius),
                        child: Image.file(file, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
              Space.height.v20,
            ],
          ],
        ),
      ),
    );
  }
}
