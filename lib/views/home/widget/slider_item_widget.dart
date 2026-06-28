part of '../screen/home_screen.dart';

class SliderItemWidget extends GetView<HomeController> {
  const SliderItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
      child: Column(
        mainAxisSize: mainMin,
        crossAxisAlignment: crossStart,
        children: [
          SizedBox(
            height: 155.h,
            child: PageView.builder(
              onPageChanged: (value) => controller.currentIndex.value = value,
              physics: BouncingScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: mainSpaceBet,
                children: [
                  TextWidget(
                    padding: EdgeInsetsGeometry.only(
                      left: Dimensions.widthSize * 2,
                    ),
                    "WeCure \nHealth – Skip the \nWaiting Room. ",
                    fontSize: Dimensions.titleLarge,
                    fontWeight: FontWeight.w600,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  Image.asset(
                    Assets.dummy.sh.path,
                    height: 125.h,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        height: 125.h,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40.sp,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: mainCenter,
            children: List.generate(
              3,
              (index) => Obx(
                () => Container(
                  margin: Dimensions.widthSize.edgeHorizontal * 0.5,
                  height: 8.h,
                  width: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentIndex.value == index
                        ? CustomColors.primary
                        : CustomColors.disableColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
