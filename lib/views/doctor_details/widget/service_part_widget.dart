part of '../screen/doctor_details_screen.dart';

class ServicePartWidget extends GetView<DoctorDetailsController> {
  const ServicePartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final services = controller.doctorDetailsInfoModel?.data.services ?? [];
    if (services.isEmpty) {
      return Column(
        crossAxisAlignment: crossStart,
        children: [
          TextWidget("Services"),
          Space.height.v5,
          TextWidget("Services not available", color: CustomColors.grayShade),
        ],
      );
    }

    return Column(
      crossAxisAlignment: crossStart,
      children: [
        TextWidget("Services"),
        Space.height.v5,
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: crossStart,
            children: services
                .map(
                  (service) => Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    spacing: Dimensions.widthSize * 0.5,
                    children: [
                      Icon(
                        Icons.circle,
                        color: const Color(0xff006C93),
                        size: Dimensions.iconSizeDefault * 0.8,
                      ),
                      TextWidget(
                        service.name.capitalizeSafe,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
