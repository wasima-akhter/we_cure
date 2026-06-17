part of 'category_details_screen.dart';

class CategoryDetailsScreenMobile extends GetView<CategoryDetailsController> {
  const CategoryDetailsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: controller.nameSpecialty),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? LoadingWidget()
              : controller.specialistsList.isEmpty
              ? EmptyDataWidget(massage: 'No Doctor Found')
              : ListView.builder(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Dimensions.defaultHorizontalSize,
                    vertical: Dimensions.verticalSize * 0.5,
                  ),
                  itemCount:
                      controller.specialistsList.length +
                      (controller.specialistsHasMore.value ? 1 : 0),
                  addRepaintBoundaries: true,
                  cacheExtent: 500,
                  shrinkWrap: true,
                  primary: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (controller.specialistsList.length == 1) {
                      PaginationLoaderWidget(
                        index: index,
                        list: controller.specialistsList,
                        currentPage: controller.specialistsCurrentPage,
                        fetchFunction: controller.fetchAllSpecialists,
                      );
                    }

                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        Routes.doctorDetailsScreen,
                        arguments: controller.specialistsList[index].id,
                      ),

                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: Dimensions.heightSize * 1.2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius,
                          ),
                          border: Border.all(
                            color: CustomColors.grayShade.withOpacity(0.15),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // DoctorDetailsCard(
                            //   imageUrl: controller
                            //       .specialistsList[index]
                            //       .profileImage,
                            //   name: controller.specialistsList[index].name,
                            //   specialty:
                            //       controller.specialistsList[index].specialty,
                            //   clinicName: controller
                            //       .specialistsList[index]
                            //       .currentOrganization,
                            //   rating: controller
                            //       .specialistsList[index]
                            //       .averageRating,
                            //   yearsOfExperience:
                            //       controller
                            //           .specialistsList[index]
                            //           .totalExperienceYears ??
                            //       0,
                            //   startingPrice: controller
                            //       .specialistsList[index]
                            //       .minFee
                            //       ?.toDouble(),
                            //   isPriceShow: false,
                            //   onTap: null,
                            //   borderHide: true,
                            // ),
                            DoctorDetailsCard(
                              imageUrl:
                                  controller
                                      .specialistsList[index]
                                      .profileImage
                                      .hasValue
                                  ? controller
                                        .specialistsList[index]
                                        .profileImage
                                  : DoctorUiFallback.profileImage,

                              name: controller.specialistsList[index].name.orNA(
                                DoctorUiFallback.doctorName,
                              ),

                              specialty: controller
                                  .specialistsList[index]
                                  .specialty
                                  .orNA(DoctorUiFallback.specialty),

                              clinicName: controller
                                  .specialistsList[index]
                                  .currentOrganization
                                  .orNA(DoctorUiFallback.organization),

                              rating:
                                  controller
                                      .specialistsList[index]
                                      .averageRating ??
                                  0.0,

                              yearsOfExperience:
                                  controller
                                      .specialistsList[index]
                                      .totalExperienceYears ??
                                  0,

                              startingPrice:
                                  (controller.specialistsList[index].minFee ??
                                          0)
                                      .toDouble(),

                              isPriceShow: false,
                              onTap: null,
                              borderHide: true,
                            ),

                            /*
                            Container(
                              height: 140.h,
                              color: Color(0xffF8F8F8),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.defaultHorizontalSize,
                                  vertical: Dimensions.verticalSize * 0.25,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          'Choose Date',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        TextWidget(
                                          'View all',
                                          onTap: () {
                                            Get.dialog(
                                              CategoryDialog(),
                                              barrierDismissible: true,
                                            );
                                          },
                                          color: CustomColors.blackColor.withOpacity(0.7),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    Space.height.v10,
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      child: Row(
                                        children: List.generate(
                                          5,
                                          (index) => Container(
                                            margin: EdgeInsets.only(right: 8),
                                            // spacing between items
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.defaultHorizontalSize * 0.5,
                                              vertical: Dimensions.verticalSize * 0.4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                Dimensions.radius,
                                              ),
                                              color: CustomColors.primary,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: crossStart,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextWidget(
                                                  "Sun \n12 Nov",
                                                  color: CustomColors.whiteColor,
                                                  fontSize: Dimensions.titleSmall,
                                                ),
                                                Space.height.v5,
                                                TextWidget(
                                                  "10 Slots",
                                                  color: CustomColors.whiteColor,
                                                  fontSize: Dimensions.titleSmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                         */
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
