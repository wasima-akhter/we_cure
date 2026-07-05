import 'package:intl/intl.dart';

import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/doctor_details_controller.dart';
import '../helper/helper.dart';

class SelectDateSection extends StatelessWidget {
  const SelectDateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DoctorDetailsController.to;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.datesDayList.length,
      itemBuilder: (context, index) {
        final dateItem = controller.datesDayList[index];

        final doctorTimezone = dateItem.doctorTimezone ?? 'Africa/Lagos';
        final originalDate = dateItem.date;

        if (originalDate == null) {
          return const SizedBox.shrink();
        }

        final userTimezone =
            Get.isRegistered<ProfileController>() &&
                AppStorage.isUser?.toUpperCase() == "USER"
            ? (ProfileController.to.userProfileModel?.data.timezone ??
                  'Africa/Lagos')
            : 'Africa/Lagos';

        debugPrint('doctorTimezone,: $doctorTimezone ');
        debugPrint('userTimezone: $userTimezone ');
        debugPrint(
          'userTimezone from profile: ${ProfileController.to.userProfileModel?.data.timezone} ',
        );

        final isSameTimezone = doctorTimezone == userTimezone;

        /// This is ONLY for UI.
        final displayDate = isSameTimezone
            ? originalDate
            : TimezoneConverter.doctorToUser(
                doctorDateTime: originalDate,
                doctorTimezone: doctorTimezone,
                userTimezone: userTimezone,
              );

        /// This is ONLY for the API.
        final apiDate = DateFormat('yyyy-MM-dd').format(originalDate);

        final label =
            '${DateFormat('EEE').format(displayDate).toUpperCase()} '
            '${displayDate.day} '
            '${DateFormat('MMM').format(displayDate).toUpperCase()}';

        return InkWell(
          onTap: () {
            controller.selectedDateIndex.value = index;

            // Use the SAME doctorDate that produced the label, not the raw UTC date

            controller.selectedDate.value = apiDate;

            controller.showTimeSlots.value = true;
            controller.fetchAllTimes(apiDate);
          },
          borderRadius: BorderRadius.circular(Dimensions.radius),
          child: Obx(
            () => Container(
              decoration: BoxDecoration(
                color: controller.selectedDateIndex.value == index
                    ? CustomColors.primary
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(Dimensions.radius),
                border: Border.all(color: Colors.transparent, width: 2),
              ),
              child: Center(
                child: TextWidget(
                  label,
                  fontSize: Dimensions.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: controller.selectedDateIndex.value == index
                      ? Colors.white
                      : CustomColors.blackColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
