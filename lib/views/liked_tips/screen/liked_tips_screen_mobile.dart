part of 'liked_tips_screen.dart';

class LikedTipsScreenMobile extends StatelessWidget {
  const LikedTipsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final tipsController = Get.find<TipsController>();
    final likedController = Get.find<LikedTipsController>(); // 👈 add this

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tipsController.refreshLikedTips();
    });

    return Scaffold(
      appBar: CommonAppBar(title: "Liked Tips"),
      body: SafeArea(
        child: Obx(
          () => tipsController.isLoadingWellnessTips.value
              ? LoadingWidget()
              : tipsController.wellnessLickedTipsList.isEmpty
              ? EmptyDataWidget(massage: 'No liked tips found.')
              : ListView.builder(
                  itemCount: tipsController.wellnessLickedTipsList.length,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Dimensions.defaultHorizontalSize,
                    vertical: Dimensions.verticalSize,
                  ),
                  itemBuilder: (context, index) {
                    final tip = tipsController.wellnessLickedTipsList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: Dimensions.heightSize),
                      decoration: BoxDecoration(
                        color: Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius * 1.5,
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
                            TextWidget(
                              tip.content,
                              fontWeight: FontWeight.w500,
                            ),
                            GestureDetector(
                              // 👈 wrap here
                              onTap: () =>
                                  likedController.toggleFavorite(tip.id, index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.disableColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(
                                  Dimensions.paddingSize * 0.4,
                                ),
                                child: tip.isFavourite == false
                                    ? Icon(
                                        Icons.favorite_border,
                                        color: CustomColors.whiteColor,
                                      )
                                    : Icon(
                                        Icons.favorite,
                                        color: Colors.redAccent,
                                      ),
                              ),
                            ),
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
