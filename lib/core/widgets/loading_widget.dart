import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/basic_import.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.size});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: color ?? CustomColors.primary,
        size: size ?? Dimensions.verticalSize * 1.5,
      ),
    );
  }
}

Widget loadingView() {
  return SizedBox(
    height: Get.height,
    child: const Center(child: LoadingWidget()),
  );
}

Widget emptyScrollable({required String name}) {
  return SizedBox(
    height: Get.height,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: Get.height * 0.3),
        _emptyWidget(name: name),
      ],
    ),
  );
}

Widget _emptyWidget({required String name}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 80.h,
          color: CustomColors.grayShade,
        ),
        Space.height.v20,
        TextWidget(
          'No $name found',
          fontSize: Dimensions.titleMedium,
          color: CustomColors.grayShade,
        ),
      ],
    ),
  );
}
