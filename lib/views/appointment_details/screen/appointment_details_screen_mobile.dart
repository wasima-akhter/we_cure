part of 'appointment_details_screen.dart';

class AppointmentDetailsScreenMobile
    extends GetView<AppointmentDetailsController> {
  const AppointmentDetailsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) return const SizedBox.shrink();

        final isUser = AppStorage.isUser == 'USER';

        // ✅ Get current status (uppercase for comparison)
        final currentStatus = isUser
            ? controller.userAppointmentDetailsModel.value?.data.status
                  .toUpperCase()
            : controller.doctorAppointmentDetailsModel.value?.data.status
                  .toUpperCase();

        // ✅ Get appointment ID
        final appointmentId = isUser
            ? controller.userAppointmentDetailsModel.value?.data.id
            : controller.doctorAppointmentDetailsModel.value?.data.id;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.defaultHorizontalSize,
              vertical: Dimensions.verticalSize * 0.5,
            ),
            child: Column(
              mainAxisSize: mainMin,
              children: [
                Row(
                  children: [
                    /// ================================
                    /// DOCTOR SIDE - Reject Button
                    /// ================================
                    if (!isUser &&
                        currentStatus != 'CANCELLED' &&
                        currentStatus != 'COMPLETED') ...[
                      Expanded(
                        child: PrimaryButtonWidget(
                          outlineButton: true,
                          buttonTextColor: CustomColors.rejected,
                          borderColor: CustomColors.rejected,
                          borderWidth: 1.5,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => BottomSheetDialogWidget(
                                titleColor: CustomColors.rejected,
                                isInputField: true,
                                title: 'Reject Request',
                                inputController: controller.reasonController,
                                subTitle:
                                    'write a reason for rejecting the appointment request',
                                isLoading: controller.isDeleting,
                                buttonTex: 'Reject',
                                action: () {
                                  controller.rejectAppointment();
                                },
                              ),
                            );
                          },
                          title: 'Reject Appointment',
                        ),
                      ),
                      Space.width.v10,
                    ],

                    /// ================================
                    /// USER SIDE - Review Button (Only for COMPLETED)
                    /// ================================
                    if (isUser && currentStatus == 'COMPLETED') ...[
                      Expanded(
                        child: PrimaryButtonWidget(
                          outlineButton: true,
                          borderColor: CustomColors.primary,
                          borderWidth: 1.5,
                          onPressed: () {
                            controller.showReviewDialog(context);
                          },
                          title: 'Review & Rating',
                        ),
                      ),
                      Space.width.v10,
                    ],

                    /// ================================
                    /// USER SIDE - Action Button
                    /// ================================
                    if (isUser) ...[
                      Expanded(
                        child: _buildActionButton(
                          currentStatus: currentStatus ?? '',
                          appointmentId: appointmentId ?? '',
                        ),
                      ),
                    ] else ...[
                      /// ================================
                      /// DOCTOR SIDE - Chat Button
                      /// ================================
                      Expanded(
                        child: PrimaryButtonWidget(
                          title: 'Chat',
                          onPressed: currentStatus == 'CANCELLED'
                              ? () {}
                              : () {
                                  // Get.offAllNamed(
                                  //   Routes.navigationScreen,
                                  //   arguments: 3,
                                  // );

                                  // Replace both chat button onPressed blocks (user side & doctor side) with this:

                                  // If NavigationScreen is already in the stack, just switch tab
                                  if (Get.isRegistered<
                                    NavigationController
                                  >()) {
                                    Get.back(); // or pop until navigation screen if needed
                                    Get.find<NavigationController>()
                                        .navigateToTab(3);
                                  } else {
                                    Get.offAllNamed(
                                      Routes.navigationScreen,
                                      arguments: 3,
                                    );
                                  }
                                },
                          buttonColor: currentStatus == 'CANCELLED'
                              ? CustomColors.disableColor
                              : CustomColors.primary,
                          disable: currentStatus == 'CANCELLED',
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      appBar: CommonAppBar(title: "Details"),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return LoadingWidget();
          }

          // USER VIEW
          if (AppStorage.isUser == 'USER') {
            final appointmentData =
                controller.userAppointmentDetailsModel.value;
            if (appointmentData == null) {
              return Center(
                child: TextWidget(
                  'No data available',
                  fontSize: Dimensions.titleMedium,
                ),
              );
            }

            final doctor = appointmentData.data.doctorInfo;
            final data = appointmentData.data;

            return ListView(
              padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
              physics: BouncingScrollPhysics(),
              children: [
                Space.height.v15,
                DoctorDetailsCard(
                  imageUrl: doctor.profileImage,
                  name: doctor.name,
                  specialty: doctor.specialty,
                  clinicName: doctor.organization,
                  rating: doctor.rating.toDouble(),
                  yearsOfExperience: doctor.experienceYears,
                  startingPrice: data.consultationFee.toDouble(),
                  onTap: () {},
                ),
                TextWidget(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.verticalSize,
                  ),
                  'Appointment Details',
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.titleMedium,
                ),
                InfoPairRow(
                  leftTitle: 'Reason',
                  leftValue: data.reasonTitle,
                  rightTitle: 'Booking Date',
                  rightValue: DateFormat(
                    "dd MMM yyyy",
                  ).format(data.appointmentDate.toLocal()),
                ),
                Space.height.v15,
                TextWidget(
                  padding: EdgeInsets.only(
                    top: Dimensions.heightSize,
                    bottom: Dimensions.heightSize * 0.5,
                  ),
                  'Details',
                  fontSize: Dimensions.titleSmall,
                  fontWeight: FontWeight.bold,
                ),
                TextWidget(
                  textAlign: TextAlign.justify,
                  fontSize: Dimensions.titleSmall,
                  fontWeight: FontWeight.w400,
                  data.reasonDetails,
                ),
                Space.height.v15,
                InfoPairRow(
                  leftTitle: 'Visiting Date',
                  leftValue:
                      '${DateFormat("dd MMM yyyy").format(data.appointmentDate.toLocal())}\n${data.appointmentTime}',
                  rightTitle: 'Status',
                  rightValue: data.status,
                ),
                Space.height.v15,
                TextWidget("Appointment Fee", fontWeight: FontWeight.w400),
                TextWidget(
                  '₦${data.consultationFee}',
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.titleLarge,
                ),
                Space.height.v15,
                if (data.attachments.isNotEmpty) ...[
                  TextWidget(
                    padding: EdgeInsets.only(bottom: Dimensions.heightSize),
                    "Attachment",
                    fontWeight: FontWeight.bold,
                  ),
                  Wrap(
                    spacing: Dimensions.widthSize,
                    runSpacing: Dimensions.heightSize,
                    children: List.generate(
                      data.attachments.length,
                      (index) => Container(
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomColors.grayShade.withOpacity(0.7),
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: data.attachments[index].url,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported,
                              color: CustomColors.grayShade,
                              size: Dimensions.iconSizeLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }
          // DOCTOR VIEW
          else {
            final appointmentData =
                controller.doctorAppointmentDetailsModel.value;
            if (appointmentData == null) {
              return Center(
                child: TextWidget(
                  'No data available',
                  fontSize: Dimensions.titleMedium,
                ),
              );
            }

            final patient = appointmentData.data.patient;
            final data = appointmentData.data;

            return ListView(
              padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
              physics: BouncingScrollPhysics(),
              children: [
                Space.height.v15,
                PatientInfoWidgetWithAsset(
                  patientImageNetwork: patient.profileImage,
                  patientName: patient.name,
                  dateOfBirth: DateFormat(
                    "dd MMM yyyy",
                  ).format(patient.dateOfBirth.toLocal()),
                  phoneNumber: patient.phone,
                  bloodGroup: patient.bloodGroup,
                  allergies: patient.allergies.isNotEmpty
                      ? patient.allergies
                      : ['None'],
                ),
                TextWidget(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.verticalSize,
                  ),
                  'Appointment Details',
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.titleMedium,
                ),
                InfoPairRow(
                  leftTitle: 'Reason',
                  leftValue: data.reasonTitle,
                  rightTitle: 'Booking Date',
                  rightValue: DateFormat(
                    "dd MMM yyyy",
                  ).format(data.appointmentDate.toLocal()),
                ),
                Space.height.v15,
                TextWidget(
                  padding: EdgeInsets.only(
                    top: Dimensions.heightSize,
                    bottom: Dimensions.heightSize * 0.5,
                  ),
                  'Details',
                  fontSize: Dimensions.titleSmall,
                  fontWeight: FontWeight.bold,
                ),
                TextWidget(
                  textAlign: TextAlign.justify,
                  fontSize: Dimensions.titleSmall,
                  fontWeight: FontWeight.w400,
                  data.reasonDetails,
                ),
                Space.height.v15,
                InfoPairRow(
                  leftTitle: 'Visiting Date',
                  leftValue:
                      '${DateFormat("dd MMM yyyy").format(data.appointmentDate.toLocal())}\n${data.appointmentTime}',
                  rightTitle: 'Status',
                  rightValue: data.status,
                ),
                Space.height.v15,
                TextWidget("Appointment Fee", fontWeight: FontWeight.w400),
                TextWidget(
                  '₦${data.consultationFee}',
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.titleLarge,
                ),
                Space.height.v15,
                if (data.attachments.isNotEmpty) ...[
                  TextWidget(
                    padding: EdgeInsets.only(bottom: Dimensions.heightSize),
                    "Attachment",
                    fontWeight: FontWeight.bold,
                  ),
                  Wrap(
                    spacing: Dimensions.widthSize,
                    runSpacing: Dimensions.heightSize,
                    children: List.generate(
                      data.attachments.length,
                      (index) => Container(
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomColors.grayShade.withOpacity(0.7),
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: data.attachments[index].url,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported,
                              color: CustomColors.grayShade,
                              size: Dimensions.iconSizeLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }
        }),
      ),
    );
  }

  /// ✅ Build Action Button (USER SIDE)
  Widget _buildActionButton({
    required String currentStatus,
    required String appointmentId,
  }) {
    // CANCELLED - Disabled button
    if (currentStatus == 'CANCELLED') {
      return PrimaryButtonWidget(
        title: 'Cancelled',
        onPressed: () {},
        buttonColor: CustomColors.disableColor,
        disable: true,
      );
    }

    // ONGOING - Join button (Video Call)
    if (currentStatus == 'ONGOING') {
      return PrimaryButtonWidget(
        title: 'Join',
        onPressed: () {
          Get.toNamed(
            Routes.videoCallScreen,
            arguments: {
              'appointmentId': appointmentId,
              'userId': AppStorage.userId,
            },
          );
        },
        buttonColor: CustomColors.primary,
      );
    }

    // UPCOMING, COMPLETED - Chat button
    return PrimaryButtonWidget(
      title: 'Chat',
      onPressed: () {
        // Get.offAllNamed(Routes.navigationScreen, arguments: 3);
        // Replace both chat button onPressed blocks (user side & doctor side) with this:

        // Get.toNamed(
        //   Routes.inboxScreen,
        //   arguments: {
        //     'conversationId': item.id,
        //     'receiverId': participant?.id ?? '',
        //     'receiverRole': participant?.role ?? '',
        //     'avatar': participant?.image ?? '',
        //     'name': participant?.name ?? '',
        //   },
        // );
        // If NavigationScreen is already in the stack, just switch tab
        if (Get.isRegistered<NavigationController>()) {
          Get.back(); // or pop until navigation screen if needed
          Get.find<NavigationController>().navigateToTab(3);
        } else {
          Get.offAllNamed(Routes.navigationScreen, arguments: 3);
        }
      },
      buttonColor: CustomColors.primary,
    );
  }
}
