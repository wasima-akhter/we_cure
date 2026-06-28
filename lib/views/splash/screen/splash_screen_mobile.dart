part of 'splash_screen.dart';

class SplashScreenMobile extends GetView<SplashController> {
  const SplashScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.logoColor,
      body: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewPadding.bottom),
        child: Center(
          child: Image.asset(Assets.dummy.logoPng.path, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
