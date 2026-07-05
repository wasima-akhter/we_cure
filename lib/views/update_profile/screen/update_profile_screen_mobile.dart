part of 'update_profile_screen.dart';

class UpdateProfileScreenMobile extends GetView<UpdateProfileController> {
  const UpdateProfileScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final isUser = AppStorage.isUser == 'USER';

    final existingImageUrl = isUser
        ? profileController.userProfileModel?.data.profileImage ?? ''
        : profileController.doctorProfileModel?.data.userId.profileImage ?? '';

    return Scaffold(
      appBar: CommonAppBar(title: "Update Profile"),
      body: SafeArea(
        child: Padding(
          padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                // Profile Image
                Center(
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => BottomImagePicker(
                        singleImageVariable: (image) {
                          controller.profileImage.value = image;
                          return null;
                        },
                      ),
                    ),
                    child: Obx(
                      () => Stack(
                        alignment: Alignment.center,
                        children: [
                          ProfileAvatarWidget(
                            size: 100,
                            imageFile: controller.profileImage.value != null
                                ? File(controller.profileImage.value!.path)
                                : null,
                            imageUrl: existingImageUrl,
                          ),
                          Container(
                            height: 100.h,
                            width: 100.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              size: Dimensions.iconSizeLarge * 1.2,
                              color: CustomColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Space.height.betweenInputBox,

                PrimaryInputFieldWidget(
                  controller: controller.nameController,
                  hintText: 'Name',
                  label: 'Name',
                ),

                Space.height.betweenInputBox,

                if (isUser) ...[
                  PrimaryInputFieldWidget(
                    controller: controller.emailController,
                    hintText: 'Email',
                    label: 'Email',
                    readOnly: true,
                  ),
                  Space.height.betweenInputBox,
                ],

                PrimaryInputFieldWidget(
                  controller: controller.phoneController,
                  hintText: 'Phone',
                  keyBoardType: TextInputType.number,
                  label: 'Emergency Contact Number',
                ),

                Space.height.betweenInputBox,

                TextWidget(
                  "Timezone",
                  color: CustomColors.grayShade,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                Space.height.btnInputTitleAndBox,
                TextWidget(
                  controller.timezone.value,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                Space.height.betweenInputBox,

                DatePickerWidget(
                  hint: 'Date of Birth',
                  label: 'Date of Birth',
                  initialDate: controller.initialDateOfBirth.isNotEmpty
                      ? DateTime.tryParse(controller.initialDateOfBirth)
                      : null,
                  onDateSelected: (DateTime date) {
                    controller.selectedDob.value = date;
                    controller.dobController.text = date
                        .toIso8601String()
                        .split('T')
                        .first;
                  },
                ),

                Space.height.betweenInputBox,

                if (isUser) ...[
                  // PrimaryInputFieldWidget(
                  //   controller: controller.bloodController,
                  //   hintText: 'Blood Group (e.g. A+)',
                  //   label: 'Blood Group',
                  // ),
                  TextWidget(
                    "Blood Group",
                    color: CustomColors.grayShade,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  Space.height.btnInputTitleAndBox,

                  Obx(
                    () => CustomDropDownWidget(
                      label: 'Blood Group',
                      hint: 'Select Blood Group',
                      items: BloodGroup.values.map((e) => e.value).toList(),
                      initialValue: controller.selectedBloodGroup.value?.value,
                      onChanged: controller.setBloodGroup,
                    ),
                  ),
                  Space.height.betweenInputBox,

                  // Allergies Field
                  TextWidget(
                    'Allergies',
                    fontSize: Dimensions.titleSmall,
                    fontWeight: FontWeight.w500,
                    color: CustomColors.blackColor,
                    padding: EdgeInsets.only(
                      bottom: Dimensions.spaceBetweenInputTitleAndBox * 0.6,
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: PrimaryInputFieldWidget(
                          controller: controller.allergyController,
                          hintText: 'Type allergy and add',
                          requiredField: false,
                        ),
                      ),
                      Space.width.v10,
                      GestureDetector(
                        onTap: controller.addAllergy,
                        child: Container(
                          height: Dimensions.inputBoxHeight,
                          width: Dimensions.inputBoxHeight,
                          decoration: BoxDecoration(
                            color: CustomColors.primary,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius * 1.2,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: CustomColors.whiteColor,
                            size: Dimensions.iconSizeLarge,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Space.height.v10,

                  Obx(
                    () => controller.allergiesList.isEmpty
                        ? const SizedBox.shrink()
                        : Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: List.generate(
                              controller.allergiesList.length,
                              (i) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.widthSize * 1.2,
                                  vertical: Dimensions.heightSize * 0.5,
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius * 2,
                                  ),
                                  border: Border.all(
                                    color: CustomColors.primary.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: mainMin,
                                  children: [
                                    TextWidget(
                                      controller.allergiesList[i],
                                      fontSize: Dimensions.labelMedium,
                                      color: CustomColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Space.width.v5,
                                    GestureDetector(
                                      onTap: () => controller.removeAllergy(i),
                                      child: Icon(
                                        Icons.close,
                                        size: Dimensions.iconSizeDefault,
                                        color: CustomColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),

                  Space.height.betweenInputBox,
                ],

                if (!isUser) ...[
                  _filedDoctorCard(
                    () => Get.toNamed(Routes.aboutScreen),
                    'About',
                  ),
                  Space.height.betweenInputBox,
                  _filedDoctorCard(
                    () => Get.toNamed(Routes.serviceScreen),
                    'Services',
                  ),
                  Space.height.betweenInputBox,
                  _filedDoctorCard(
                    () => Get.toNamed(Routes.experienceScreen),
                    'Work Experience',
                  ),
                  Space.height.betweenInputBox,
                ],

                Space.height.betweenInputBox,

                Obx(
                  () => PrimaryButtonWidget(
                    isLoading: controller.isLoading.value,
                    title: 'Update',
                    onPressed: () {
                      if (isUser) {
                        controller.userUpdateProfileProcess();
                      } else {
                        controller.doctorUpdateProfileProcess();
                      }
                    },
                  ),
                ),

                Space.height.v20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filedDoctorCard(void Function()? onTap, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.verticalSize * 0.6,
          horizontal: Dimensions.defaultHorizontalSize,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
          border: Border.all(color: CustomColors.primary.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            TextWidget(
              title,
              color: CustomColors.blackColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            Icon(Icons.keyboard_arrow_right, color: CustomColors.primary),
          ],
        ),
      ),
    );
  }
}
