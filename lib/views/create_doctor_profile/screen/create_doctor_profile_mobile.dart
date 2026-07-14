part of 'create_doctor_profile_screen.dart';

class CreateDoctorProfileScreenMobile
    extends GetView<CreateDoctorProfileController> {
  const CreateDoctorProfileScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Create Doctor Profile"),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? LoadingWidget()
              : ListView(
                  padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Space.height.v20,

                    TextWidget(
                      "Create Doctor Profile",
                      fontSize: Dimensions.titleLarge * 1.2,
                      fontWeight: FontWeight.bold,
                    ),

                    Space.height.v20,

                    CustomDropDownWidget(
                      hint: "Select Specialty",
                      items: controller.allSpecialist
                          .map((e) => e.name)
                          .toList(),
                      onChanged: (value) {
                        final specialist = controller.allSpecialist.firstWhere(
                          (e) => e.name == value,
                        );

                        controller.specialityId.value = specialist.id;
                      },
                    ),

                    Space.height.betweenInputBox,

                    PrimaryInputFieldWidget(
                      controller: controller.organizationController,
                      hintText: "Current Organization",
                    ),

                    Space.height.betweenInputBox,

                    DatePickerWidget(
                      hint: "Date of Birth",
                      label: "Date of Birth",
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

                    PrimaryInputFieldWidget(
                      controller: controller.aboutController,
                      hintText: "About",
                      maxLines: 5,
                    ),

                    Space.height.v30,

                    Obx(
                      () => PrimaryButtonWidget(
                        title: "Continue",
                        isLoading: controller.isSubmitting.value,
                        onPressed: controller.createProfile,
                      ),
                    ),

                    Space.height.v20,
                  ],
                ),
        ),
      ),
    );
  }
}
