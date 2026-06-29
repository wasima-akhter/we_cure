part of 'create_schedule_screen.dart';

class CreateScheduleScreenMobile extends GetView<CreateScheduleController> {
  const CreateScheduleScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: controller.isEditMode ? "Edit Schedule" : "New Schedule",
      ),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            Space.height.v20,

            // Create → multi-select days | Edit → single day (pre-filled, locked)
            if (controller.isEditMode)
              PrimaryInputFieldWidget(
                controller:
                    controller.dayDisplayController, // 👈 pre-filled controller
                hintText: 'Day of week',
                label: 'Day',
                readOnly: true, // 👈 locks it visually
              )
            else
              MultiSelectDropDownWidget(
                hint: 'Day of week',
                items: const [
                  'Saturday',
                  'Sunday',
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                ],
                onChanged: (value) {
                  controller.dayList = value;
                },
              ),

            Space.height.v20,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Starting Time",
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        fontSize: Dimensions.titleMedium * 0.9,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.blackColor,
                      ),
                      6.verticalSpace,

                      TimePickerWidget(
                        hint: "Starting Time",
                        initialTime: parseTimeOfDay(
                          controller.isEditMode
                              ? controller.editingSchedule!.startTime
                              : null,
                        ),
                        onTimeSelected: (time) {
                          controller.startTime.value = time;
                          // convertLocalToNigerian(time);
                        },
                      ),
                    ],
                  ),
                ),
                Space.width.v15,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Ending Time",
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        fontSize: Dimensions.titleMedium * 0.9,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.blackColor,
                      ),
                      6.verticalSpace,
                      TimePickerWidget(
                        hint: "Ending Time",
                        initialTime: parseTimeOfDay(
                          controller.isEditMode
                              ? controller.editingSchedule!.endTime
                              : null,
                        ),
                        // end time
                        onTimeSelected: (time) {
                          controller.endTime.value = time;
                          // convertLocalToNigerian( time )
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Space.height.v20,
            Row(
              children: [
                Expanded(
                  child: PrimaryInputFieldWidget(
                    controller: controller.durationController,
                    hintText: 'Duration (min)',
                    label: 'Duration (min)',
                    keyBoardType: TextInputType.number,
                  ),
                ),
                Space.width.v15,
                Expanded(
                  child: PrimaryInputFieldWidget(
                    controller: controller.feeController,
                    hintText: 'Fee (₦)',
                    label: 'Fee   (Min. ₦50)',
                    keyBoardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Space.height.v25,
            Obx(
              () => PrimaryButtonWidget(
                isLoading: controller.isLoading.value,
                title: controller.isEditMode ? 'Save Changes' : 'Continue',
                onPressed: () => controller.createSchedule(),
              ),
            ),
            Space.height.v25,
          ],
        ),
      ),
    );
  }

  TimeOfDay? parseTimeOfDay(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;

    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }
}
