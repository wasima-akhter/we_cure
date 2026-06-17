import '../core/utils/basic_import.dart';

class CustomLogoWidget extends StatelessWidget {
  final double? size;

  const CustomLogoWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Assets.dummy.logoPng.path, height: size ?? 44.h);
  }
}
