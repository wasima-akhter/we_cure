import '../utils/basic_import.dart';

class EmptyDataWidget extends StatelessWidget {
  final String? massage;

  const EmptyDataWidget({super.key, this.massage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize * 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeSvgWidget(assetPath: Assets.icons.empty),
            Space.height.v5,
            TextWidget(
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              massage ?? Strings.noDataFound,
              color: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
