import 'package:glady/views/profile/controller/profile_controller.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/profile_avater_widget.dart';
import '../../../widgets/custom_logo_widget.dart';

class ProfileBoxWidget extends GetView<ProfileController> {
  const ProfileBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: Dimensions.verticalSize * 0.5,
      ),
      decoration: BoxDecoration(
        color: CustomColors.offWhite,
        borderRadius: BorderRadius.circular(Dimensions.radius),
        border: Border.all(color: CustomColors.borderColor),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: mainSpaceBet,
            children: [
              CustomLogoWidget(size: 40.h),

              // TextButton(
              //   style: TextButton.styleFrom(
              //     minimumSize: Size.zero,
              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //     padding: EdgeInsets.symmetric(
              //       horizontal: Dimensions.defaultHorizontalSize * 0.5,
              //       vertical: Dimensions.verticalSize * 0.25,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(Dimensions.radius * 2),
              //       side: BorderSide(color: CustomColors.primary),
              //     ),
              //   ),
              //   onPressed: () {},
              //   child: TextWidget(
              //     'ID : 052415',
              //     fontSize: Dimensions.titleSmall,
              //     color: CustomColors.primary,
              //   ),
              // ),
              SizedBox(),
            ],
          ),

          ProfileAvatarWidget(
            imageUrl: controller.userProfileModel?.data.profileImage ?? '',
            size: 100.w,
          ),
          Space.height.v10,
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Dimensions.widthSize * 0.8,
            children: [
              TextWidget(controller.userProfileModel?.data.name ?? ""),
              if ((controller.userProfileModel?.data.bloodGroup ?? '')
                  .isNotEmpty)
                BloodGroupBox(
                  bloodGroup:
                      controller.userProfileModel?.data.bloodGroup ?? '',
                ),
            ],
          ),
          Builder(
            builder: (context) {
              final dob = controller.userProfileModel?.data.dateOfBirth;
              return TextWidget(
                dob != null
                    ? DateFormat(
                        'dd - MMM - yyyy',
                      ).format(controller.userProfileModel!.data.dateOfBirth!)
                    : 'No Date Of Birth is Available',
                fontSize: Dimensions.titleSmall,
                color: Colors.black.withOpacity(0.7),
              );
            },
          ),
          Builder(
            builder: (context) {
              final phone = controller.userProfileModel?.data.phone ?? '';

              if (phone.isEmpty) return const SizedBox.shrink();
              return TextWidget(
                phone,
                fontSize: Dimensions.titleSmall,
                color: Colors.black.withOpacity(0.7),
              );
            },
          ),

          Space.height.v10,
          Column(
            crossAxisAlignment: crossStart,
            children: [
              TextWidget('Allergies'),
              Space.height.v10,
              Wrap(
                spacing: Dimensions.spaceBetweenInputBox * 0.4,
                runSpacing: Dimensions.spaceBetweenInputBox * 0.4,
                children: List.generate(
                  controller.userProfileModel?.data.allergies?.length ?? 0,
                  (index) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.widthSize,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius * 2,
                      ),
                      border: Border.all(
                        color: CustomColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: TextWidget(
                      padding: EdgeInsetsGeometry.only(
                        // right: Dimensions.widthSize * 2,
                        // bottom: Dimensions.heightSize,
                      ),
                      controller.userProfileModel!.data.allergies?[index]
                              .toString() ??
                          '',
                      fontSize: Dimensions.titleSmall,
                      color: CustomColors.grayShade,
                    ),
                  ),
                ),
              ),
              Space.height.v30,
              GestureDetector(
                onTap: () => Get.toNamed(Routes.updateProfileScreen),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CustomColors.primary,

                    borderRadius: BorderRadius.circular(Dimensions.radius),
                  ),
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Dimensions.defaultHorizontalSize * 2,
                    vertical: Dimensions.verticalSize * 0.4,
                  ),
                  child: TextWidget(
                    'Edit Profile',
                    color: CustomColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DoctorProfileBox extends GetView<ProfileController> {
  const DoctorProfileBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: Dimensions.verticalSize * 0.5,
      ),
      decoration: BoxDecoration(
        color: CustomColors.offWhite,
        borderRadius: BorderRadius.circular(Dimensions.radius),
        border: Border.all(color: CustomColors.borderColor),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: mainSpaceBet,
            children: [
              CustomLogoWidget(size: 40.h),
              // TextButton(
              //   style: TextButton.styleFrom(
              //     minimumSize: Size.zero,
              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //     padding: EdgeInsets.symmetric(
              //       horizontal: Dimensions.defaultHorizontalSize * 0.5,
              //       vertical: Dimensions.verticalSize * 0.25,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(Dimensions.radius * 2),
              //       side: BorderSide(color: CustomColors.primary),
              //     ),
              //   ),
              //   onPressed: () {},
              //   child: TextWidget(
              //     'ID : 052415',
              //     fontSize: Dimensions.titleSmall,
              //     color: CustomColors.primary,
              //   ),
              // ),
              SizedBox(),
            ],
          ),
          ProfileAvatarWidget(
            imageUrl:
                controller.doctorProfileModel?.data.userId.profileImage ?? '',

            size: 100,
          ),

          Space.height.v10,

          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Dimensions.widthSize * 0.8,
            children: [
              TextWidget(
                controller.doctorProfileModel?.data.userId.name ??
                    "Luna Kellan",
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.defaultHorizontalSize * 0.5,
                    vertical: Dimensions.verticalSize * 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 1.5,
                    ),
                    side: BorderSide(color: CustomColors.primary),
                  ),
                ),
                onPressed: () {},
                child: TextWidget(
                  '${controller.doctorProfileModel?.data.totalExperienceYears.toString() ?? '0'} years',
                  fontSize: Dimensions.titleSmall * 0.9,
                  color: CustomColors.primary,
                ),
              ),
            ],
          ),
          TextWidget(
            controller.doctorProfileModel?.data.specialtyId.name.toString() ??
                'Specialty',
            fontSize: Dimensions.titleSmall,
            color: Colors.black.withOpacity(0.7),
          ),
          TextWidget(
            controller.doctorProfileModel?.data.currentOrganization
                    .toString() ??
                '',
            fontSize: Dimensions.titleSmall,
            color: Colors.black.withOpacity(0.7),
          ),
          Row(
            mainAxisAlignment: mainCenter,
            children: [
              Wrap(
                children: List.generate(5, (index) {
                  final rating =
                      controller.doctorProfileModel?.data.averageRating ?? 0;
                  if (index < rating.floor()) {
                    return Icon(Icons.star, color: Colors.orange);
                  } else if (index < rating && rating % 1 >= 0.5) {
                    return Icon(Icons.star_half, color: Colors.orange);
                  } else {
                    return Icon(Icons.star_border, color: Colors.orange);
                  }
                }),
              ),
              TextWidget(
                '(${controller.doctorProfileModel?.data.averageRating.toStringAsFixed(1) ?? '0.0'})',
                fontSize: Dimensions.titleSmall,
                color: Colors.black.withOpacity(0.7),
              ),
            ],
          ),

          Space.height.v20,
          Column(
            crossAxisAlignment: crossStart,
            children: [
              TextWidget('Services'),
              Space.height.v10,
              Wrap(
                children: List.generate(
                  controller.doctorProfileModel?.data.services.length ?? 0,
                  (index) => TextWidget(
                    padding: EdgeInsetsGeometry.only(
                      right: Dimensions.widthSize * 2,
                      bottom: Dimensions.heightSize,
                    ),
                    controller.doctorProfileModel?.data.services[index].name
                            .toString() ??
                        '',
                    fontSize: Dimensions.titleSmall,
                    color: CustomColors.grayShade,
                  ),
                ),
              ),
              Space.height.v20,
              Row(
                mainAxisAlignment: mainSpaceBet,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(Routes.updateProfileScreen),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: CustomColors.primary,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius,
                          ),
                        ),
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: Dimensions.defaultHorizontalSize * 2,
                          vertical: Dimensions.verticalSize * 0.4,
                        ),
                        child: TextWidget(
                          'Edit Profile',
                          color: CustomColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  Space.width.v10,
                  if (AppStorage.isUser == 'USER')
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: CustomColors.whiteColor,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.defaultHorizontalSize,
                          vertical: Dimensions.verticalSize * 0.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius,
                          ),
                          side: BorderSide(color: CustomColors.borderColor),
                        ),
                      ),
                      onPressed: () {},
                      child: TextWidget("QR CODE", color: CustomColors.primary),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BloodGroupBox extends StatelessWidget {
  final String bloodGroup;
  const BloodGroupBox({super.key, required this.bloodGroup});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize * 0.8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
          side: BorderSide(color: CustomColors.primary),
        ),
      ),
      onPressed: () {},
      child: TextWidget(
        bloodGroup,
        fontSize: Dimensions.titleSmall * 0.9,
        color: CustomColors.primary,
      ),
    );
  }
}
