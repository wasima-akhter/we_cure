part of '../screen/home_screen.dart';

class BottomBannerWidget extends StatelessWidget {
  const BottomBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290.h,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160.h,
            child: Container(color: CustomColors.primary),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize,
                  vertical: Dimensions.verticalSize,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primary,
                  border: Border.all(color: CustomColors.whiteColor),
                  borderRadius: BorderRadius.circular(Dimensions.radius),
                ),
              ),
            ),
          ),
          Positioned(
            left: Dimensions.defaultHorizontalSize * 2.5,
            top: Dimensions.verticalSize * 1.5,
            right: Dimensions.defaultHorizontalSize * 2.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "Be a Healthcare Hero",
                  fontWeight: FontWeight.bold,
                  color: CustomColors.whiteColor,
                  fontSize: Dimensions.titleLarge,
                ),
                SizedBox(height: 10.h),
                TextWidget(
                  "Your small donation can help provide free consultations to those in need. Make a difference today!",
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                  color: CustomColors.whiteColor,
                ),
                SizedBox(height: 20.h),
                const _DonateButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DonateButton extends StatelessWidget {
  const _DonateButton();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          _DonationBottomSheet(controller: controller),
          isScrollControlled: true,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize,
          vertical: Dimensions.verticalSize * 0.4,
        ),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.radius * 2),
        ),
        child: TextWidget(
          "Donate Now",
          fontWeight: FontWeight.bold,
          color: CustomColors.primary,
        ),
      ),
    );
  }
}

class _DonationBottomSheet extends StatefulWidget {
  final HomeController controller;

  const _DonationBottomSheet({required this.controller});

  @override
  State<_DonationBottomSheet> createState() => _DonationBottomSheetState();
}

class _DonationBottomSheetState extends State<_DonationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: Dimensions.horizontalSize,
          right: Dimensions.horizontalSize,
          top: Dimensions.verticalSize * 0.8,
          bottom: bottomInset > 0 ? bottomInset : Dimensions.verticalSize,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius * 1.5),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossStart,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: Dimensions.widthSize * 4.2,
                  height: Dimensions.heightSize * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius),
                    color: Colors.black,
                  ),
                ),
              ),
              Space.height.v10,
              TextWidget(
                "Make a Donation",
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.titleMedium * 1.1,
              ),
              Space.height.v15,
              PrimaryInputFieldWidget(
                controller: widget.controller.donationEmailController,
                hintText: "Enter email",
                label: "Email",
                isEmail: true,
                keyBoardType: TextInputType.emailAddress,
              ),
              Space.height.betweenInputBox,
              PrimaryInputFieldWidget(
                controller: widget.controller.donationAmountController,
                hintText: "Enter amount",
                label: "Donation Amount",
                keyBoardType: TextInputType.number,
              ),
              Space.height.v15,
              PrimaryButtonWidget(
                title: "Donate Now",
                onPressed: () async {
                  if (widget.controller.donationEmailController.text
                      .trim()
                      .isEmpty) {
                    CustomSnackBar.error("Please enter your email");
                    return;
                  }
                  if (widget.controller.donationAmountController.text
                      .trim()
                      .isEmpty) {
                    CustomSnackBar.error("Please enter a donation amount");
                    return;
                  }
                  await widget.controller.donationProcess();
                  Get.back();
                },
              ),
              Space.height.v5,
            ],
          ),
        ),
      ),
    );
  }
}
