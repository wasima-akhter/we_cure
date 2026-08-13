import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../../terms/model/terms_model.dart';

class PolicyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getTermsCondition();
  }

  RxBool isLoading = false.obs;
  String privacyDescription = '';

  Future<TermsModel> getTermsCondition() async {
    return ApiRequest().get(
      fromJson: TermsModel.fromJson,
      endPoint: ApiEndPoints.policy,
      isLoading: isLoading,
      showResponse: true,
      onSuccess: (result) => privacyDescription = result.data.content,
    );
  }
}
