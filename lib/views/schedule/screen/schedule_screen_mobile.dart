part of 'schedule_screen.dart';

class ScheduleScreenMobile extends GetView<ScheduleController> {
  const ScheduleScreenMobile({super.key});

  void _showDeleteConfirm(String scheduleId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
        ),
        title: const TextWidget('Delete Schedule', fontWeight: FontWeight.w600),
        content: const TextWidget(
          'Are you sure you want to delete this schedule? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: TextWidget(
              'Cancel',
              color: CustomColors.blackColor.withOpacity(0.6),
            ),
          ),
          Obx(
            () => TextButton(
              onPressed: controller.isDeleting.value
                  ? null
                  : () {
                      Get.back();
                      controller.deleteSchedule(scheduleId);
                    },
              child: TextWidget(
                'Delete',
                color: CustomColors.rejected,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title:
            "Manage Schedule", // ${ProfileController.to.doctorProfileModel?.data.userId.email}
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(Dimensions.radius * 0.4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColors.primary,
        ),
        child: IconButton(
          onPressed: () => Get.toNamed(Routes.createScheduleScreen),
          icon: Icon(
            Icons.add,
            size: Dimensions.iconSizeLarge * 1.4,
            color: CustomColors.whiteColor,
          ),
        ),
      ),

      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () async {
            await controller.getAllSchedule();
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return loadingView();
            }

            if (controller.scheduleList.isEmpty) {
              return emptyScrollable(name: "schedule");
            }

            return _listView();
          }),
        ),
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: Dimensions.verticalSize,
      ),
      itemCount: controller.scheduleList.length,
      itemBuilder: (context, index) {
        final schedule = controller.scheduleList[index];

        debugPrint('schedule id in manage screen: ${schedule.id}');
        debugPrint(
          'schedule startTime - ${schedule.startTime}. --   endtime - ${schedule.endTime} ',
        );
        debugPrint(
          'schedule converted startTime - ${formatTimeToAmPm(schedule.startTime)}. --   endtime - ${formatTimeToAmPm(schedule.endTime)} ',
        );

        return Container(
          margin: EdgeInsets.only(bottom: Dimensions.heightSize * 1.25),
          decoration: BoxDecoration(
            color: const Color(0xffF8F8F8),
            border: Border.all(color: CustomColors.borderColor),
            borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.defaultHorizontalSize,
              vertical: Dimensions.verticalSize * 0.2,
            ),
            child: ListTile(
              contentPadding: EdgeInsetsGeometry.zero,
              // 👇 tap tile to edit
              onTap: () {
                debugPrint(' schedule id: ${schedule.id} ');
                // Get.toNamed(Routes.createScheduleScreen, arguments: schedule);
              },
              title: TextWidget(
                schedule.dayOfWeek,
                fontWeight: FontWeight.w500,
              ),
              subtitle: Column(
                crossAxisAlignment: crossStart,
                children: [
                  4.verticalSpace,
                  TextWidget(
                    '${formatTimeToAmPm(schedule.startTime)} - ${formatTimeToAmPm(schedule.endTime)}',
                    fontWeight: FontWeight.w400,
                    fontSize: Dimensions.titleSmall,
                    color: CustomColors.blackColor.withOpacity(0.6),
                  ),
                  4.verticalSpace,
                  TextWidget('₦${schedule.fee}', fontWeight: FontWeight.w500),
                ],
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: mainCenter,
                    crossAxisAlignment: crossEnd,
                    children: [
                      TextWidget(
                        '${schedule.slotSizeMinutes} Min',
                        fontWeight: FontWeight.w400,
                        color: CustomColors.blackColor.withOpacity(0.6),
                      ),
                      4.verticalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.widthSize,
                          vertical: Dimensions.heightSize * 0.2,
                        ),
                        decoration: BoxDecoration(
                          color: schedule.isActive
                              ? CustomColors.primary.withOpacity(0.1)
                              : CustomColors.rejected.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius * 2,
                          ),
                        ),
                        child: TextWidget(
                          schedule.isActive ? 'Active' : 'Inactive',
                          fontSize: Dimensions.labelSmall,
                          color: schedule.isActive
                              ? CustomColors.primary
                              : CustomColors.rejected,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Space.width.v10,

                  // 👇 delete icon
                  Obx(() {
                    final isDeletingThis =
                        controller.deletingId.value == schedule.id;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: isDeletingThis
                          ? null
                          : () => _showDeleteConfirm(schedule.id),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: CustomColors.grayShade.withValues(alpha: 0.2),
                        ),
                        padding: EdgeInsets.all(8.w),
                        child: isDeletingThis
                            ? SizedBox(
                                height: Dimensions.iconSizeLarge,
                                width: Dimensions.iconSizeLarge,
                                child: const LoadingWidget(),
                              )
                            : Icon(
                                Icons.delete_outline_rounded,
                                color: CustomColors.rejected,
                                size: Dimensions.iconSizeLarge,
                              ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
