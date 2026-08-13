import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/helpers/image_compressor_helper.dart';
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
    if (multipleImages.isEmpty) {
      CustomSnackBar.error("Please upload your document before continuing.");

      throw Exception("Document is required");
    }

    // ============================================================
    // Compress document before upload
    // ============================================================

    final compressedDocument = await compressImage(multipleImages.first);

    if (compressedDocument == null) {
      throw Exception("Unable to process document");
    }

    // ============================================================
    // Upload document
    // ============================================================

    return ApiRequest().multiMultipartRequest(
      reqType: 'POST',
      fromJson: BasicSuccessModel.fromJson,
      endPoint: ApiEndPoints.docUpload,
      isLoading: isLoading,
      token: accessToken,
      body: {},
      files: {"document": compressedDocument},
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
                'Your documents have been submitted successfully.\n\n'
                'Please complete your bank account information before your '
                'verification process continues. '
                'Our team usually verifies documents within 24–48 hours. '
                'You will receive an email once your account has been verified.',
            onTap: () => Get.offAllNamed(Routes.loginScreen),
          ),
        );
      },
    );
  }
}

/*

Doctor Signup
      ↓
Complete Profile
      ↓
Upload Documents
      ↓
Add Bank Account (Mandatory)
      ↓
Awaiting Verification

*/
