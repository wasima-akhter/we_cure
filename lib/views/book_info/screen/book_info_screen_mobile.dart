part of 'book_info_screen.dart';

class BookInfoScreenMobile extends GetView<BookInfoController> {
  const BookInfoScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Information"),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewPadding.bottom),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.defaultHorizontalSize,
            vertical: Dimensions.verticalSize,
          ),
          child: PrimaryButtonWidget(
            title: 'Book Appointment & Pay',
            onPressed: () => controller.bookAppointment(),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              Space.height.v15,
              TextWidget("What kind of issue do you need treatment for?"),
              Space.height.v10,
              PrimaryInputFieldWidget(
                controller: controller.reasonTitleController,
                hintText: 'Professional Cleaning',
                label: 'Visit Reason',
              ),
              Space.height.betweenInputBox,
              PrimaryInputFieldWidget(
                maxLines: 4,
                controller: controller.reasonDetailsController,
                hintText: 'Write here details.....',
                label: 'Detail Info (Optional)',
                requiredField: false,
              ),
              TextWidget(
                '** Maximum 180 Character',
                fontSize: Dimensions.titleSmall * 0.8,
                fontWeight: FontWeight.w400,
              ),
              Space.height.v40,
              TextWidget("Attachment"),
              Space.height.v10,
              const AttachmentAddWidget(),
              Space.height.v20,
            ],
          ),
        ),
      ),
    );
  }
}
