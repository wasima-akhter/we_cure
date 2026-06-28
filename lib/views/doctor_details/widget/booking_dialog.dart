import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/divider_widget.dart';
import '../controller/doctor_details_controller.dart';

class BookingDialog extends GetView<DoctorDetailsController> {
  const BookingDialog({super.key});

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.defaultHorizontalSize,
                vertical: Dimensions.verticalSize * 0.2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    'Select Date',
                    fontSize: Dimensions.titleLarge * 0.8,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.selectedTime.value = '';
                      controller.selectedDate.value = '';
                      controller.showTimeSlots.value = false;
                      Get.back();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            DividerWidget(),

            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize,
                  vertical: Dimensions.verticalSize * 0.2,
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date loading
                      if (controller.isLoadingDate.value)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              Dimensions.paddingSize * 0.5,
                            ),
                            child: CircularProgressIndicator(
                              color: CustomColors.primary,
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: controller.datesDayList.length,
                          itemBuilder: (context, index) {
                            final dateItem = controller.datesDayList[index];
                            // final label =
                            //     '${dateItem.day.substring(0, 3).toUpperCase()} ${dateItem.date?.day} ${_monthName(dateItem.date?.month ?? 0)}';

                            final label =
                                '${dateItem.day.substring(0, 3).toUpperCase()} '
                                '${dateItem.date?.day} '
                                '${_monthName(dateItem.date?.month ?? 0)}';
                            return InkWell(
                              // onTap: () {
                              //   controller.selectedDateIndex.value = index;
                              //   controller.selectedDate.value = dateItem.date
                              //       .toIso8601String()
                              //       .split('T')[0];
                              //   controller.showTimeSlots.value = true;
                              //   controller.fetchAllTimes(
                              //     controller.selectedDate.value,
                              //   );
                              // },
                              onTap: () {
                                controller.selectedDateIndex.value = index;

                                final date = dateItem.date;
                                controller.selectedDate.value =
                                    date?.toIso8601String().split('T')[0] ?? '';

                                controller.showTimeSlots.value = true;

                                controller.fetchAllTimes(
                                  controller.selectedDate.value,
                                );
                              },
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius,
                              ),
                              child: Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color:
                                        controller.selectedDateIndex.value ==
                                            index
                                        ? CustomColors.primary
                                        : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius,
                                    ),
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: TextWidget(
                                      label,
                                      fontSize: Dimensions.labelSmall,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          controller.selectedDateIndex.value ==
                                              index
                                          ? Colors.white
                                          : CustomColors.blackColor,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: controller.showTimeSlots.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Space.height.v15,
                                  TextWidget(
                                    'Select Time',
                                    fontSize: Dimensions.titleLarge * 0.8,
                                  ),
                                  Space.height.v10,
                                  Obx(
                                    () => controller.isLoadingTime.value
                                        ? Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                Dimensions.paddingSize * 0.5,
                                              ),
                                              child: CircularProgressIndicator(
                                                color: CustomColors.primary,
                                              ),
                                            ),
                                          )
                                        : GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 2.2,
                                                  crossAxisSpacing: 12,
                                                  mainAxisSpacing: 12,
                                                ),
                                            itemCount:
                                                controller.timeList.length,
                                            itemBuilder: (context, index) {
                                              final timeItem =
                                                  controller.timeList[index];
                                              return InkWell(
                                                onTap: () {
                                                  if (!timeItem.isAvailable) {
                                                    return;
                                                  }
                                                  controller
                                                          .selectedTimeIndex
                                                          .value =
                                                      index;
                                                  controller
                                                          .selectedTime
                                                          .value =
                                                      timeItem.time;
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      Dimensions.radius,
                                                    ),
                                                child: Obx(
                                                  () => Opacity(
                                                    opacity:
                                                        timeItem.isAvailable
                                                        ? 1.0
                                                        : 0.4,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            controller
                                                                    .selectedTimeIndex
                                                                    .value ==
                                                                index
                                                            ? CustomColors
                                                                  .primary
                                                            : const Color(
                                                                0xFFF5F5F5,
                                                              ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors
                                                              .transparent,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: TextWidget(
                                                          _formatTime(
                                                            timeItem.time,
                                                          ),
                                                          fontSize: Dimensions
                                                              .labelMedium,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              controller
                                                                      .selectedTimeIndex
                                                                      .value ==
                                                                  index
                                                              ? Colors.white
                                                              : CustomColors
                                                                    .blackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            DividerWidget(),

            Obx(
              () => PrimaryButtonWidget(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize,
                  vertical: Dimensions.verticalSize,
                ),
                title: 'Continue',
                disable: controller.selectedTime.value.isEmpty,
                onPressed: () {
                  Get.toNamed(Routes.bookInfoScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
