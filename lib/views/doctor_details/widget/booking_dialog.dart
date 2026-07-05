import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/views/profile/controller/profile_controller.dart';

import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/divider_widget.dart';
import '../controller/doctor_details_controller.dart';
import '../helper/helper.dart';
import 'select_date_section.dart';

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
                        SelectDateSection(),
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
                                        : controller.timeList.isEmpty
                                        ? TextWidget(
                                            "No slot is available this day",
                                            fontSize: Dimensions.labelMedium,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColors.blackColor,
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
                                              final doctorTimezone =
                                                  timeItem.doctorTimezone ??
                                                  'Africa/Lagos';

                                              final userTimezone =
                                                  Get.isRegistered<
                                                        ProfileController
                                                      >() &&
                                                      AppStorage.isUser
                                                              ?.toUpperCase() ==
                                                          "USER"
                                                  ? (ProfileController
                                                            .to
                                                            .userProfileModel
                                                            ?.data
                                                            .timezone ??
                                                        'Africa/Lagos')
                                                  : 'Africa/Lagos';

                                              debugPrint(
                                                'doctorTimezone,: $doctorTimezone ',
                                              );
                                              debugPrint(
                                                'userTimezone: $userTimezone ',
                                              );
                                              debugPrint(
                                                'userTimezone from profile: ${ProfileController.to.userProfileModel?.data.timezone} ',
                                              );

                                              final isSameTimezone =
                                                  doctorTimezone ==
                                                  userTimezone;

                                              String displayTime;
                                              int dayOffset = 0;

                                              if (isSameTimezone) {
                                                displayTime = _formatTime(
                                                  timeItem.time,
                                                );
                                              } else {
                                                final converted =
                                                    convertTimeToUserTime(
                                                      dateStr: controller
                                                          .selectedDate
                                                          .value, // doctor date
                                                      time: timeItem
                                                          .time, // doctor time
                                                      doctorTimezone:
                                                          doctorTimezone,
                                                      userTimezone:
                                                          userTimezone,
                                                    );

                                                displayTime =
                                                    converted.formattedTime;
                                                dayOffset = converted.dayOffset;
                                              }

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
                                                      .value = timeItem
                                                      .time; // keep raw doctor-time value for the booking API call
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
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            TextWidget(
                                                              displayTime,
                                                              fontSize: Dimensions
                                                                  .labelMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  controller
                                                                          .selectedTimeIndex
                                                                          .value ==
                                                                      index
                                                                  ? Colors.white
                                                                  : CustomColors
                                                                        .blackColor,
                                                            ),
                                                            if (dayOffset != 0)
                                                              TextWidget(
                                                                dayOffset > 0
                                                                    ? '(+1 day)'
                                                                    : '(-1 day)',
                                                                fontSize: Dimensions
                                                                    .labelSmall,
                                                                color:
                                                                    controller
                                                                            .selectedTimeIndex
                                                                            .value ==
                                                                        index
                                                                    ? Colors
                                                                          .white70
                                                                    : CustomColors
                                                                          .blackColor
                                                                          .withOpacity(
                                                                            0.6,
                                                                          ),
                                                              ),
                                                          ],
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
