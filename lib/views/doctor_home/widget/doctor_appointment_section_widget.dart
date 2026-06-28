part of '../screen/doctor_home_screen.dart';

class DoctorAppointmentSectionWidget extends StatelessWidget {
  const DoctorAppointmentSectionWidget({super.key});

  String _formatTime(String time) {
    if (time.isEmpty) return '';
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorHomeController>();

    return Obx(() {
      final today = controller.dashboardModel.value?.data.today;
      final nextSchedule =
          controller.dashboardModel.value?.data.nextSchedule ?? '';
      final activeAppointment =
          controller.dashboardModel.value?.data.activeAppointment;

      String formattedNextSchedule = '';
      if (nextSchedule.contains(' - ')) {
        final parts = nextSchedule.split(' - ');
        formattedNextSchedule =
            '${_formatTime(parts[0])} - ${_formatTime(parts[1])}';
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize,
          vertical: Dimensions.verticalSize * 0.8,
        ),
        decoration: BoxDecoration(
          color: CustomColors.offWhite,
          border: Border.all(color: CustomColors.borderColor),
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget("Appointment", fontWeight: FontWeight.w500),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.scheduleScreen),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_calls_sharp,
                        color: CustomColors.grayShade.withValues(alpha: 0.5),
                      ),
                      TextWidget(
                        " Manage",
                        fontWeight: FontWeight.w500,
                        color: CustomColors.primary,
                        fontSize: Dimensions.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Space.height.v15,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.defaultHorizontalSize * 1.2,
                    vertical: Dimensions.verticalSize * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.primary,
                    borderRadius: BorderRadius.circular(Dimensions.radius),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        today?.dayName ?? '',
                        color: CustomColors.whiteColor,
                        fontSize: Dimensions.titleLarge * 0.9,
                        fontWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        today != null
                            ? DateFormat(
                                "dd MMM",
                              ).format(DateTime.parse(today.date))
                            : '',
                        color: CustomColors.whiteColor,
                        fontSize: Dimensions.titleSmall,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 12.h),
                      TextWidget(
                        '${today?.slotCount ?? 0}',
                        color: CustomColors.whiteColor,
                        fontSize: Dimensions.titleLarge * 1.2,
                      ),
                      TextWidget(
                        "Slot",
                        color: CustomColors.whiteColor,
                        fontSize: Dimensions.titleSmall,
                      ),
                    ],
                  ),
                ),
                Space.width.v10,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.defaultHorizontalSize * 0.8,
                                vertical: Dimensions.verticalSize * 0.6,
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.whiteColor,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.6,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    "Starting",
                                    color: CustomColors.blackColor.withOpacity(
                                      0.5,
                                    ),
                                    fontSize: Dimensions.titleSmall * 0.9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 2.h),
                                  TextWidget(
                                    _formatTime(today?.startTime ?? ''),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Space.width.v10,
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.defaultHorizontalSize * 0.8,
                                vertical: Dimensions.verticalSize * 0.6,
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.whiteColor,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.6,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    "Ending",
                                    color: CustomColors.blackColor.withOpacity(
                                      0.5,
                                    ),
                                    fontSize: Dimensions.titleSmall * 0.9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 2.h),
                                  TextWidget(
                                    _formatTime(today?.endTime ?? ''),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Space.height.v10,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.defaultHorizontalSize * 0.8,
                          vertical: Dimensions.verticalSize * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.whiteColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius * 0.6,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Next Schedule",
                              color: CustomColors.blackColor.withOpacity(0.5),
                              fontSize: Dimensions.titleSmall * 0.95,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 2.h),
                            TextWidget(
                              formattedNextSchedule.isEmpty
                                  ? 'N/A'
                                  : formattedNextSchedule,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (activeAppointment != null) ...[
              Space.height.v15,
              RequestCard(
                name: activeAppointment.timeRange,
                service: activeAppointment.reasonTitle,
                time: activeAppointment.timeRange,
                status: activeAppointment.status,
                buttonTitle: 'Join',
                onTap: () {},
              ),
            ],
          ],
        ),
      );
    });
  }
}
