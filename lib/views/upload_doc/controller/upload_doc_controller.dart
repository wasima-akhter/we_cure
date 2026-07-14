import 'dart:io';

import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/confirmation_widget.dart';

class UploadDocController extends GetxController {
  final RxList<XFile> multipleImages = <XFile>[].obs;
  RxList<dynamic> attachmentList = [].obs;
  RxBool isLoading = false.obs;

  String accessToken = '';

  @override
  void onInit() {
    super.onInit();

    accessToken = Get.arguments?['token'] ?? '';
  }

  Future<BasicSuccessModel> uploadFileDoc() async {
    return ApiRequest().multiMultipartRequest(
      reqType: 'POST',
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.docUpload,
      isLoading: isLoading,
      token: accessToken,
      body: {},
      files: {"document": File(multipleImages.first.path)},

      onSuccess: (result) {
        Get.offAll(
          ConfirmationWidget(
            icon: Icon(
              Icons.access_time_rounded,
              size: Dimensions.iconSizeLarge * 4,
              color: CustomColors.primary,
            ),
            title: 'Awaiting Verification',
            subtitle:
                'The authority will check your documents to verify your authenticity. 24-48 hours is the usual time for verification. You will be notified via email once the verification is complete. Thank you for your patience.',
            onTap: () => Get.offAllNamed(Routes.loginScreen),
          ),
        );
      },
    );
  }
}
