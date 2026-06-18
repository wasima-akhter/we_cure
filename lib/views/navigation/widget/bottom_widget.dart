part of '../screen/navigation_screen.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isUser = AppStorage.isUser == 'USER';
    return BottomAppBar(
      height: 70.h,
      padding: EdgeInsets.zero,
      color: Color(0xFFF8F8F8),
      child: Container(
        padding: Dimensions.defaultHorizontalSize.edgeHorizontal * 0.1,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
          border: Border(
            top: BorderSide(color: CustomColors.disableColor.withOpacity(0.2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 1. Home
            _BottomBarItem(
              path: Assets.icons.hh,
              label: '',
              index: 0,
              svgSize: 25.h,
            ),

            // 2. Find/Schedule
            isUser
                ? _BottomBarItem(path: Assets.icons.find, label: '', index: 1)
                : _BottomBarItem(path: Assets.icons.sr, label: '', index: 1),

            // 3. Appointment - Center
            _BottomBarItem(
              path: Assets.icons.appoinment,
              label: '',
              index: 2,
              isCenter: true,
            ),

            // 4. Message - Both User and Doctor
            _BottomBarItem(path: Assets.icons.buble, label: '', index: 3),

            // 5. Profile
            _BottomBarItem(path: Assets.icons.profile, label: '', index: 4),
          ],
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    this.label,
    required this.index,
    this.path,
    this.svgSize,
    this.isCenter = false,
    this.icon,
  });

  final IconData? icon;
  final String? path;
  final String? label;
  final int index;
  final double? svgSize;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedIndex.value == index;

        return InkWell(
          onTap: () => _onTap(controller),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
            decoration: isSelected
                ? BoxDecoration(
                    color: CustomColors.whiteColor,
                    shape: BoxShape.circle,
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _buildIcon(isSelected),
                ),

                if (label != null && label!.isNotEmpty) ...[
                  SizedBox(height: Dimensions.verticalSize * 0.25),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? CustomColors.primary.withOpacity(1.0)
                          : CustomColors.blackColor.withOpacity(0.7),
                    ),
                    child: Text(label!),
                  ),
                ],

                if (isSelected)
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    height: 3.h,
                    width: 3.h,
                    decoration: BoxDecoration(
                      color: CustomColors.primary.withOpacity(1.0),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildIcon(bool isSelected) {
    final color = isSelected
        ? CustomColors.primary.withOpacity(1.0)
        : CustomColors.blackColor.withOpacity(0.7);

    if (icon != null) {
      return Icon(
        icon,
        color: color,
        size: svgSize ?? Dimensions.iconSizeDefault,
      );
    }

    if (path != null) {
      return SafeSvgWidget(
        assetPath: path!,
        height: svgSize ?? 25.h,
        color: color,
      );
    }

    return const SizedBox.shrink();
  }

  void _onTap(NavigationController controller) {
    controller.selectedIndex.value = index;
  }
}
