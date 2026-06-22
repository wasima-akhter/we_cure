import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/webview_screen.dart';
import '../../doctor_details/controller/doctor_details_controller.dart';
import '../model/create_appoinment_model.dart';

class BookInfoController extends GetxController {
  final reasonTitleController = TextEditingController();
  final reasonDetailsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxList<XFile> selectedAttachments = <XFile>[].obs;

  String? appointmentId;

  RxBool isLoading = false.obs;

  void addAttachments(List<XFile> images) {
    selectedAttachments.addAll(images);
  }

  void removeAttachment(int index) {
    selectedAttachments.removeAt(index);
  }
  /*
  Future<void> bookAppointment() async {
    if (!formKey.currentState!.validate()) return;

    final detailsController = Get.find<DoctorDetailsController>();
    final doctorId = detailsController.doctorId ?? '';
    final appointmentDate = detailsController.selectedDate.value;
    final appointmentTime = detailsController.selectedTime.value;

    if (doctorId.isEmpty ||
        appointmentDate.isEmpty ||
        appointmentTime.isEmpty) {
      CustomSnackBar.error('Please select date and time first');
      return;
    }

    Get.dialog(
      const CupertinoAlertDialog(
        content: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingWidget(),
              SizedBox(height: 12),
              Text('Please wait...'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    final Map<String, File?> filesMap = {};
    final Map<String, dynamic> body = {
      'doctorId': doctorId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'reasonTitle': reasonTitleController.text.trim(),
      'reasonDetails': reasonDetailsController.text.trim(),
    };

    final filesList = <String, List<File>>{};
    if (selectedAttachments.isNotEmpty) {
      filesList['attachment'] = selectedAttachments
          .map((e) => File(e.path))
          .toList();
    }

    try {
      await ApiRequest().multiMultipartRequest(
        endPoint: '/appointments',
        isLoading: isLoading,
        reqType: 'POST',
        body: body,
        files: filesMap,
        filesList: filesList,
        fromJson: CreateAppoinmentModel.fromJson,
        onSuccess: (result) {
          appointmentId = result.data.id;
        },
      );
    } catch (_) {
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }

    if (appointmentId != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      Get.toNamed(Routes.paymentScreen, arguments: appointmentId);
    }
  }
*/

  Future<void> bookAppointment() async {
    if (!formKey.currentState!.validate()) return;

    final detailsController = Get.find<DoctorDetailsController>();
    final doctorId = detailsController.doctorId ?? '';
    final appointmentDate = detailsController.selectedDate.value;
    final appointmentTime = detailsController.selectedTime.value;

    if (doctorId.isEmpty ||
        appointmentDate.isEmpty ||
        appointmentTime.isEmpty) {
      CustomSnackBar.error('Please select date and time first');
      return;
    }

    Get.dialog(
      const CupertinoAlertDialog(
        content: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingWidget(),
              SizedBox(height: 12),
              Text('Please wait...'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    String? paymentUrl;

    final Map<String, dynamic> body = {
      'doctorId': doctorId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'reasonTitle': reasonTitleController.text.trim(),
      'reasonDetails': reasonDetailsController.text.trim(),
    };

    final filesList = <String, List<File>>{};
    if (selectedAttachments.isNotEmpty) {
      filesList['attachment'] = selectedAttachments
          .map((e) => File(e.path))
          .toList();
    }

    try {
      await ApiRequest().multiMultipartRequest(
        endPoint: '/appointments?payNow=true', // 👈 updated endpoint
        isLoading: isLoading,
        reqType: 'POST',
        body: body,
        files: {},
        filesList: filesList,
        fromJson: CreateAppoinmentModel.fromJson,
        onSuccess: (result) {
          paymentUrl =
              result.payment?.authorizationUrl; // 👈 from payment field
        },
      );
    } catch (_) {
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }

    if (paymentUrl != null && paymentUrl!.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      Get.to(() => WebPaymentScreen(paymentUrl: paymentUrl!)); // 👈 go directly
    }
  }

  @override
  void onClose() {
    reasonTitleController.dispose();
    reasonDetailsController.dispose();
    super.onClose();
  }
}
