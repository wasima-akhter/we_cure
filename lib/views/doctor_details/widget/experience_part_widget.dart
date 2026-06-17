part of '../screen/doctor_details_screen.dart';

class ExperiencePartWidget extends GetView<DoctorDetailsController> {
  const ExperiencePartWidget({super.key});

  String _formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  String _duration(DateTime start, DateTime end, bool isCurrent) {
    final to = isCurrent ? DateTime.now() : end;
    final months = (to.year - start.year) * 12 + to.month - start.month;
    final years = months ~/ 12;
    final rem = months % 12;
    if (years > 0 && rem > 0) {
      return '$years year${years > 1 ? 's' : ''} $rem month${rem > 1 ? 's' : ''}';
    }
    if (years > 0) return '$years year${years > 1 ? 's' : ''}';
    return '$rem month${rem > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final experiences =
        controller.doctorDetailsInfoModel?.data.experiences ?? [];
    if (experiences.isEmpty) {
      return Column(
        crossAxisAlignment: crossStart,
        children: [
          TextWidget("Experience"),
          Space.height.v5,
          TextWidget(
            "Experience details not available",
            color: CustomColors.secondaryDarkText,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: crossStart,
      children: [
        TextWidget("Experience"),
        Space.height.v10,

        /*
        ...experiences.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;

          return Padding(
            padding: EdgeInsets.only(bottom: Dimensions.heightSize * 2),
            child: Column(
              mainAxisSize: mainMin,
              crossAxisAlignment: crossStart,
              children: [
                TextWidget(
                  "${index + 1}. ${exp.organizationName.capitalize ?? ''}",
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.titleSmall,
                ),

                Space.height.v5,

                TextWidget(
                  exp.designation.capitalize ?? '',
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.titleSmall,
                ),

                TextWidget(
                  '${_formatDate(exp.startDate)} - ${exp.isCurrent ? 'Present' : _formatDate(exp.endDate)}',
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                  color: CustomColors.secondaryDarkText,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: Dimensions.titleSmall - 1,
                ),

                TextWidget(
                  _duration(exp.startDate, exp.endDate, exp.isCurrent),
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.titleSmall - 1,
                ),
              ],
            ),
          );
        }),
*/
        ...experiences.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;

          return Padding(
            padding: EdgeInsets.only(bottom: Dimensions.heightSize * 1.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline
                /*
                Column(
                  children: [
                    Container(
                      height: 28,
                      width: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CustomColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: TextWidget(
                        "${index + 1}",
                        color: CustomColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.titleSmall,
                      ),
                    ),

                    if (index != experiences.length - 1)
                      Container(
                        width: 1.5,
                        height: Dimensions.heightSize * 5,
                        color: CustomColors.primary.withOpacity(0.25),
                      ),
                  ],
                ),
*/
                // Space.width.v15,

                // Experience Content
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.defaultHorizontalSize * 0.5,
                      vertical: Dimensions.defaultHorizontalSize * 0.5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius),
                      border: Border.all(
                        width: 0.7,
                        color: CustomColors.grayShade.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: crossStart,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 6,
                              width: 6,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Space.width.v5,

                            Expanded(
                              child: TextWidget(
                                exp.organizationName.capitalize ?? '',
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.titleSmall,
                              ),
                            ),
                          ],
                        ),

                        Space.height.v5,

                        TextWidget(
                          exp.designation.capitalize ?? '',

                          fontWeight: FontWeight.w400,
                          color: CustomColors.secondaryDarkText,
                          fontSize: Dimensions.titleSmall,
                        ),

                        Space.height.v5,

                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: Dimensions.iconSizeDefault * 0.8,
                              color: CustomColors.secondaryDarkText,
                            ),

                            Space.width.v5,

                            Expanded(
                              child: TextWidget(
                                '${_formatDate(exp.startDate)} - ${exp.isCurrent ? 'Present' : _formatDate(exp.endDate)}',
                                fontWeight: FontWeight.w400,
                                color: CustomColors.secondaryDarkText,
                                fontSize: Dimensions.titleSmall - 1,
                              ),
                            ),
                          ],
                        ),

                        Space.height.v3,

                        Row(
                          children: [
                            Icon(
                              Icons.work_history_outlined,
                              size: Dimensions.iconSizeDefault * 0.8,
                              color: CustomColors.secondaryDarkText,
                            ),

                            Space.width.v5,

                            TextWidget(
                              _duration(
                                exp.startDate,
                                exp.endDate,
                                exp.isCurrent,
                              ),
                              fontWeight: FontWeight.w500,
                              color: CustomColors.primary,
                              fontSize: Dimensions.titleSmall - 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
