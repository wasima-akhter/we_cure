part of 'bank_details_screen.dart';

class BankDetailsScreenMobile extends GetView<BankDetailsController> {
  const BankDetailsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Bank Details"),
      body: SafeArea(
        child: Obx(
          () => controller.isGetDetails.value
              ? LoadingWidget()
              : Form(
                  key: controller.formKey,

                  child: ListView(
                    padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Space.height.betweenInputBox,
                      PrimaryInputFieldWidget(
                        label: "Bank Code",
                        hintText: "Bank Code",
                        controller: controller.bankCodeController,
                        validatorLogic: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Bank Code is required";
                          }
                          return null;
                        },
                      ),
                      Space.height.betweenInputBox,
                      PrimaryInputFieldWidget(
                        label: "Bank Name",
                        hintText: "Bank Name",
                        controller: controller.bankNameController,
                        validatorLogic: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Bank Name is required";
                          }
                          return null;
                        },
                      ),
                      Space.height.betweenInputBox,
                      PrimaryInputFieldWidget(
                        label: "Account Number",
                        keyBoardType: TextInputType.number,
                        hintText: "Account Number",
                        controller: controller.numberController,
                        validatorLogic: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Account number is required";
                          }

                          if (value.trim().length < 6) {
                            return "Enter a valid account number";
                          }

                          return null;
                        },
                      ),
                      Space.height.betweenInputBox,
                      Space.height.betweenInputBox,
                      Obx(
                        () => PrimaryButtonWidget(
                          title: 'Save',
                          isLoading: controller.isLoading.value,
                          onPressed: () async {
                            if (!(controller.formKey.currentState?.validate() ??
                                false)) {
                              return;
                            }

                            FocusManager.instance.primaryFocus?.unfocus();

                            if (AppStorage.isUser == 'USER') {
                              await controller.addUserBankAccount();
                            } else {
                              await controller.addDoctorBankAccount();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
