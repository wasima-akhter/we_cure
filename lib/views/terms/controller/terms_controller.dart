import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../model/terms_model.dart';

class TermsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getTermsCondition();
  }

  RxBool isLoading = false.obs;
  String termsDescription = '';

  Future<TermsModel> getTermsCondition() async {
    return ApiRequest().get(
      fromJson: TermsModel.fromJson,
      endPoint: ApiEndPoints.terms,
      isLoading: isLoading,
      showResponse: true,
      onSuccess: (result) => termsDescription = result.data.content,
    );
  }
}
