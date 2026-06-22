import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import '../utils/basic_import.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      onRefresh: onRefresh,
      indicatorBuilder: (context, controller) {
        return SizedBox(
          height: 80,
          child: Center(
            child: AnimatedScale(
              duration: const Duration(milliseconds: 150),
              scale: controller.isLoading
                  ? 1
                  : (0.5 + (controller.value * 0.5)),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: CustomColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}
