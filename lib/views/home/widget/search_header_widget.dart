part of '../screen/home_screen.dart';

class SearchHeaderWidget extends StatelessWidget {
  const SearchHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.find<NavigationController>().goToSearchNav(),
      child: Container(
        margin: Dimensions.defaultHorizontalSize.edgeHorizontal,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: CustomColors.borderColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Text(
                  'Find Specialties Doctor',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // Find Care Button (Static Design)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Text(
                'Find Care',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
