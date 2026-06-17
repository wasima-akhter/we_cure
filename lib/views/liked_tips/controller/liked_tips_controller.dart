import '../../../core/utils/basic_import.dart';
import '../../tips/controller/tips_controller.dart';

class LikedTipsController extends GetxController {
  final TipsController _tipsController = Get.find<TipsController>();

  Future<void> toggleFavorite(String tipId, int likedIndex) async {
    // Find the matching item in the master list
    final masterIndex = _tipsController.wellnessTipsList.indexWhere(
      (tip) => tip.id == tipId,
    );

    if (masterIndex != -1) {
      await _tipsController.toggleFavorite(tipId, masterIndex);
    }

    // Refresh the liked list from the updated master list
    _tipsController.refreshLikedTips();
  }
}
