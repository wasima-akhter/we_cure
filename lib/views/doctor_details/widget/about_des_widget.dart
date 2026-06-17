part of '../screen/doctor_details_screen.dart';

class AboutDesWidget extends GetView<DoctorDetailsController> {
  const AboutDesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final about = controller.doctorDetailsInfoModel?.data.doctor.about ?? '';
    if (about.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: crossStart,
      mainAxisSize: mainMin,
      children: [
        TextWidget("About"),
        Space.height.v10,
        TextWidget(
          about.capitalizeFirst.orNA("Doctor description not available"),

          fontSize: Dimensions.titleSmall,
          color: CustomColors.blackColor.withOpacity(0.7),
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
