part of 'add_experience_screen.dart';

class AddExperienceScreenMobile extends GetView<AddExperienceController> {
  const AddExperienceScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: controller.isEditMode ? "Edit Experience" : "Add Experience",
      ),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
          physics: BouncingScrollPhysics(),
          children: [
            Space.height.v20,
            PrimaryInputFieldWidget(
              label: 'Organization Name',
              controller: controller.organizationController,
              hintText: 'Organization Name',
            ),
            Space.height.betweenInputBox,
            PrimaryInputFieldWidget(
              label: 'Designation',
              controller: controller.designationController,
              hintText: 'Designation',
            ),
            Space.height.betweenInputBox,
            Obx(
              () => DatePickerWidget(
                label: 'Starting Date',
                initialDate: controller.startDate.value,
                onDateSelected: (date) {
                  controller.startDate.value = date;
                },
              ),
            ),
            Space.height.v10,
            GestureDetector(
              onTap: () {
                controller.isChecked.value = !controller.isChecked.value;
              },
              child: Row(
                children: [
                  TextWidget("Current working here"),
                  Space.width.v10,
                  Obx(
                    () => Container(
                      height: 18.w,
                      width: 18.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius * 0.4,
                        ),
                        border: Border.all(
                          color: controller.isChecked.value
                              ? CustomColors.primary
                              : CustomColors.borderColor,
                          width: 1.2.w,
                        ),
                      ),
                      child: Icon(
                        controller.isChecked.value ? Icons.check : Icons.close,
                        color: controller.isChecked.value
                            ? CustomColors.primary
                            : CustomColors.borderColor,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Space.height.betweenInputBox,
            Obx(
              () => Visibility(
                visible: !controller.isChecked.value,
                child: DatePickerWidget(
                  label: 'Ending Date',

                  initialDate: controller.endDate.value,
                  onDateSelected: (date) {
                    controller.endDate.value = date;
                  },
                ),
              ),
            ),
            Space.height.v40,
            Obx(
              () => PrimaryButtonWidget(
                isLoading: controller.isLoading.value,
                title: controller.isEditMode ? "Update" : "Save",
                onPressed: () => controller.isEditMode
                    ? controller.updateExperience()
                    : controller.addExperience(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
