part of '../screen/home_screen.dart';

class TipsCardWidget extends GetView<HomeController> {
  const TipsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.wellnessTipsList;

      return SizedBox(
        height: 140.h,
        child: ListView.builder(
          itemCount: min(list.length, 10),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.defaultHorizontalSize,
          ),

          itemBuilder: (context, index) {
            if (index == list.length) {
              return PaginationLoaderWidget(
                index: index,
                list: list,
                currentPage: controller.tipsCurrentPage,
                fetchFunction: controller.fetchWellnessTips,
                padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
              );
            }

            final tip = list[index];
            return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(right: Dimensions.widthSize),
              decoration: BoxDecoration(
                color: CustomColors.secondary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.radius * 0.6),
                  topRight: Radius.circular(Dimensions.radius * 0.6),
                  topLeft: Radius.circular(Dimensions.radius * 2),
                  bottomRight: Radius.circular(Dimensions.radius * 2),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.defaultHorizontalSize,
                  vertical: Dimensions.verticalSize * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextWidget(
                        tip.content,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.whiteColor,
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.toggleFavorite(tip.id, index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: CustomColors.blackColor,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
                        child: Icon(
                          tip.isFavourite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: Dimensions.iconSizeLarge * 0.8,
                          color: tip.isFavourite
                              ? CustomColors.rejected
                              : CustomColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
