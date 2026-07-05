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
            ? controller.userAppointmentDetailsModel.value?.data?.status
                  .toUpperCase()
            : controller.doctorAppointmentDetailsModel.value?.data.status
                  .toUpperCase();

        // ✅ Get appointment ID
        final appointmentId = isUser
            ? controller.userAppointmentDetailsModel.value?.data?.id
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
                      Obx(
                        () => Expanded(
                          child: PrimaryButtonWidget(
                            isLoading: controller.isLoadingChatDetails.value,
                            title: 'Chat',
                            disable: currentStatus == 'CANCELLED',
                            buttonColor: currentStatus == 'CANCELLED'
                                ? CustomColors.disableColor
                                : CustomColors.primary,
                            onPressed: currentStatus == 'CANCELLED'
                                ? () {}
                                : () =>
                                      controller.openChatAsDoctor(), // ✅ clean
                          ),
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
      appBar: CommonAppBar(
        title: "Appointment Details",
        isBack: true,
        onTap: () => Get.back(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: CustomColors.primary,
          onRefresh: () async => controller.refreshData(),
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [LoadingWidget()],
              );
            }

            // USER VIEW
            if (AppStorage.isUser == 'USER') {
              final appointmentData =
                  controller.userAppointmentDetailsModel.value;
              if (appointmentData == null) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: [
                    Center(
                      child: TextWidget(
                        'No data available',
                        fontSize: Dimensions.titleMedium,
                      ),
                    ),
                  ],
                );
              }

              final doctor = appointmentData.data?.doctorInfo;
              final data = appointmentData.data;

              debugPrint(' data?.appointmentDate: ${data?.appointmentDate} ');
              //I/flutter ( 6343):  data?.appointmentDate: 2026-06-21 00:00:00.000Z

              final userTimezone =
                  Get.isRegistered<ProfileController>() &&
                      AppStorage.isUser == "USER"
                  ? (ProfileController.to.userProfileModel?.data.timezone ??
                        'Africa/Lagos')
                  : 'Africa/Lagos';

              final doctorTimezone = data?.doctorTimezone ?? 'Africa/Lagos';

              final isSameTimezone = doctorTimezone == userTimezone;

              final displayDate = isSameTimezone
                  ? data?.appointmentDate
                  : data?.appointmentDate == null
                  ? null
                  : tz.TZDateTime.from(
                      data!.appointmentDate!,
                      tz.getLocation(userTimezone),
                    );

              final formattedVisitingDate = formatTzConvertedAppointmentDate(
                date: data?.appointmentDate,
                doctorTimezone: doctorTimezone,
                userTimezone: userTimezone,
              );

              final formattedVisitingTime = isSameTimezone
                  ? formatTimeToAmPm(data?.appointmentTime)
                  : convertTimeToUserTime(
                      dateStr:
                          data?.appointmentDate
                              ?.toIso8601String()
                              .split('T')
                              .first ??
                          '',
                      time: data?.appointmentTime ?? '',
                      doctorTimezone: doctorTimezone,
                      userTimezone: userTimezone,
                    ).formattedTime;

              return ListView(
                padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  Space.height.v15,
                  DoctorDetailsCard(
                    imageUrl: doctor?.profileImage ?? '',
                    name: doctor?.name ?? '',
                    specialty: doctor?.specialty ?? '',
                    clinicName: doctor?.organization ?? '',
                    rating: doctor?.rating.toDouble() ?? 0,
                    yearsOfExperience: doctor?.experienceYears.toInt() ?? 0,
                    startingPrice: data?.consultationFee.toDouble(),
                    onTap: () {},
                  ),

                  22.verticalSpace,
                  // TextWidget(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: Dimensions.verticalSize,
                  //   ),
                  //   'Appointment Details',
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: Dimensions.titleMedium,
                  // ),
                  InfoPairRow(
                    leftTitle: 'Reason',
                    leftValue: data?.reasonTitle ?? '',
                    rightTitle: 'Booking Date',
                    rightValue: data?.appointmentDate == null
                        ? '-- --- ----'
                        : (isSameTimezone
                              ? DateFormat(
                                  'dd MMM yyyy',
                                ).format(data!.appointmentDate!)
                              : DateFormat('dd MMM yyyy').format(
                                  tz.TZDateTime.from(
                                    data!.appointmentDate!,
                                    tz.getLocation(userTimezone),
                                  ),
                                )),
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
                    data?.reasonDetails ?? '',
                  ),
                  Space.height.v15,
                  InfoPairRow(
                    leftTitle: 'Visiting Date',
                    leftValue: '$formattedVisitingDate\n$formattedVisitingTime',
                    rightTitle: 'Status',
                    rightValue: data?.status ?? '',
                  ),
                  Space.height.v15,
                  TextWidget("Appointment Fee", fontWeight: FontWeight.w600),
                  TextWidget(
                    '₦${data?.consultationFee}',
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.titleLarge - 1,
                  ),
                  Space.height.v15,
                  if ((data?.attachments ?? []).isNotEmpty) ...[
                    TextWidget(
                      padding: EdgeInsets.only(bottom: Dimensions.heightSize),
                      "Attachment",
                      fontWeight: FontWeight.bold,
                    ),
                    Wrap(
                      spacing: Dimensions.widthSize,
                      runSpacing: Dimensions.heightSize,
                      children: List.generate(
                        (data?.attachments ?? []).length,
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
                              imageUrl: data?.attachments[index].url ?? '',
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
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  Space.height.v15,
                  PatientInfoWidgetWithAsset(
                    patientImageNetwork: patient.profileImage,
                    patientName: patient.name,
                    dateOfBirth: formatDateDMY(patient.dateOfBirth),
                    // DateFormat(
                    //   "dd MMM yyyy",
                    // ).format(patient.dateOfBirth.toLocal()),
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
                    rightValue: formatDateDMY(data.appointmentDate),
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
                        '${formatDateDMY(data.appointmentDate)}\n${formatTimeToAmPm(data.appointmentTime)}',
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
    return Obx(() {
      final isLoadingChat = controller.isLoadingChatDetails.value;
      final isLoadingAppoint = controller.isLoading.value;

      return PrimaryButtonWidget(
        title: 'Chat',
        isLoading: isLoadingAppoint || isLoadingChat,
        disable: isLoadingChat,
        onPressed: isLoadingChat
            ? () {}
            : () async {
                final doctorDetails =
                    controller.userAppointmentDetailsModel.value;

                if (doctorDetails == null) {
                  CustomSnackBar.error('Appointment details not loaded yet.');
                  return;
                }

                // 👇 fetch on button tap, then navigate
                await controller.fetchUserDoctorAppointedChatDetails(
                  targeted_userId: doctorDetails.data?.doctorInfo?.userId ?? '',
                  appointmentId: appointmentId,
                );

                final chatDetails =
                    controller.userDoctorAppointChatDetailsModel.value;

                if (chatDetails == null) {
                  CustomSnackBar.error('Could not load chat details.');
                  return;
                }

                debugPrint(' to inbox screen ');

                Get.toNamed(
                  Routes.inboxScreen,
                  arguments: {
                    'conversationId': chatDetails.conversationId,
                    'receiverId': chatDetails.recipient.id,
                    'receiverRole': chatDetails.recipient.role.toUpperCase(),
                    'avatar': chatDetails.recipient.image,
                    'name': chatDetails.recipient.name,
                    'isOnline': false, // ✅ add this — API doesn't return it
                  },
                );
              },
        buttonColor: CustomColors.primary,
      );
    });
  }
}
