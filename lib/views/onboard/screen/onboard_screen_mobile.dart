part of 'onboard_screen.dart';

class OnboardScreenMobile extends GetView<OnboardController> {
  const OnboardScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(child: _buildCarousel()),

            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: 20.h,
      ),
      child: Image.asset(
        Assets.dummy.logoPng.path,
        color: Colors.white,
        height: 60.h,
      ),
    );
  }

  Widget _buildCarousel() {
    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      itemCount: controller.onboardingItems.length,
      itemBuilder: (context, index) {
        final item = controller.onboardingItems[index];
        return _buildOnboardingPage(item);
      },
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Expanded(
            flex: 3,
            child: Center(
              child: SafeSvgWidget(
                assetPath: item.imagePath,
                height: 350.h,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Space.height.v40,

          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),

          Space.height.v15,

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              item.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.85),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Space.height.v40,
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: 30.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicators
          _buildPageIndicators(),

          // Next/Get Started Button
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Obx(() {
      return Row(
        children: List.generate(
          controller.onboardingItems.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: 8.w),
            width: controller.currentPage.value == index ? 24.w : 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: controller.currentPage.value == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildActionButton() {
    return Obx(() {
      final isLastPage =
          controller.currentPage.value == controller.onboardingItems.length - 1;

      return GestureDetector(
        onTap: controller.nextPage,
        child: Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isLastPage ? Icons.check : Icons.arrow_forward,
                key: ValueKey(isLastPage),
                color: CustomColors.primary,
                size: 24.sp,
              ),
            ),
          ),
        ),
      );
    });
  }
}
