part of 'register_screen.dart';

class RegisterScreenMobile extends GetView<RegisterController> {
  const RegisterScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: ""),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
          children: [
            Align(alignment: Alignment.topRight, child: CustomLogoWidget()),

            TextWidget(
              "Register",
              fontSize: Dimensions.titleLarge * 1.48,
              fontWeight: FontWeight.w500,
            ),
            TextWidget(
              "Hello! Register to Get Started",
              fontSize: Dimensions.titleSmall * 1.2,
              fontWeight: FontWeight.w500,
            ),
            Space.height.btnInputTitleAndBox,
            Form(
              key: controller.fromKey,
              child: Column(
                crossAxisAlignment: crossStart,
                children: [
                  Space.height.v20,
                  PrimaryInputFieldWidget(
                    controller: controller.nameController,
                    hintText: 'Enter Your Name',
                    // label: 'Full Name',
                    nextFocusNode: controller.emailFocus,
                    // requiredField: false,
                  ),
                  Space.height.betweenInputBox,

                  PrimaryInputFieldWidget(
                    // label: "Email",
                    isEmail: true,
                    controller: controller.emailController,
                    focusNode: controller.emailFocus,
                    nextFocusNode: controller.passwordFocus,
                    hintText: "Enter your email",
                  ),
                  Space.height.betweenInputBox,
                  PrimaryInputFieldWidget(
                    hintText: "Enter Your Password",
                    // label: "Password",
                    isPassword: true,
                    controller: controller.passwordController,
                    focusNode: controller.passwordFocus,
                    nextFocusNode: controller.confirmPasswordFocus,
                  ),
                  Space.height.betweenInputBox,
                  PrimaryInputFieldWidget(
                    hintText: "Confirm password",
                    // label: "Confirm Password",
                    isPassword: true,
                    controller: controller.passConfirmController,
                    focusNode: controller.confirmPasswordFocus,
                    nextFocusNode: null,
                    confirmWith:
                        controller.passwordController, // only checks matching
                  ),

                  ///---------------------------
                  Space.height.betweenInputBox,

                  Obx(
                    () => CustomDropDownWidget(
                      hint: "Select Timezone",
                      initialValue: controller.selectedTimezone.value,
                      items: controller.timezones,
                      onChanged: (value) {
                        controller.selectedTimezone.value = value;
                      },
                    ),
                  ),

                  ///---------------------------
                  Space.height.betweenInputBox,
                  Space.height.betweenInputBox,
                  Obx(
                    () => PrimaryButtonWidget(
                      isLoading: controller.isLoading.value,
                      title: "Register",
                      onPressed: () {
                        if (controller.fromKey.currentState!.validate()) {
                          controller.registerProcess();
                        }
                      },
                    ),
                  ),
                  Space.height.v10,

                  Row(
                    children: [
                      TextWidget(
                        onTap: () => Get.toNamed(Routes.registerScreen),
                        textAlign: TextAlign.end,
                        "Already have an account?",
                        color: CustomColors.blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.titleSmall * 1.1,
                      ),
                      TextWidget(
                        onTap: () => Get.offAllNamed(Routes.loginScreen),
                        textAlign: TextAlign.end,
                        "  Log In",
                        color: CustomColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.titleSmall * 1.1,
                      ),
                    ],
                  ),
                  Space.height.v40,

                  TextWidget(
                    textAlign: TextAlign.left,
                    'Create account as a Doctor',
                    color: CustomColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.titleSmall * 1.1,
                  ),
                  Space.height.btnInputTitleAndBox,
                  PrimaryButtonWidget(
                    outlineButton: true,
                    borderWidth: 1.5,
                    fontWeight: FontWeight.w600,
                    title: 'Doctor Account',
                    onPressed: () {
                      AppStorage.save(isUser: 'DOCTOR');
                      Get.toNamed(Routes.doctorRegisterScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
