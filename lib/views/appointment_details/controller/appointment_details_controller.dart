import 'dart:developer';

import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/views/profile/controller/profile_controller.dart';

import '../../../core/utils/basic_import.dart';
import '../model/appoinment_details_model.dart';
import '../model/user_appoinment_details_model.dart';
import '../model/user_appoint_chat_details.dart';

class AppointmentDetailsController extends GetxController {
  late String appointmentId = '';
  final reasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    appointmentId = Get.arguments;

    if (AppStorage.isUser == 'USER') {
      fetchUserAppointmentDetails();
    } else {
      fetchDoctorAppointmentDetails();
    }

    // getChattingInfo(appointmentId);
  }

  void refreshData() {
    if (AppStorage.isUser == 'USER') {
      fetchUserAppointmentDetails();
    } else {
      fetchDoctorAppointmentDetails();
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    feedbackController.dispose();
    super.onClose();
  }

  // ChattingInfoModel? chattingInfoModel;
  // RxBool isLoadingInfo = false.obs;
  //
  // Future<ChattingInfoModel> getChattingInfo(String appointmentId) async {
  //   return await ApiRequest().get(
  //     fromJson: ChattingInfoModel.fromJson,
  //     endPoint: '/chat/messages-by-appointment',
  //     queryParams: {
  //       'appointmentId' : appointmentId
  //     },
  //     isLoading: isLoadingInfo,
  //     onSuccess: (result) => chattingInfoModel = result,
  //   );
  // }

  RxBool isLoading = false.obs;
  Rx<DoctorAppointmentDetailsModel?> doctorAppointmentDetailsModel =
      Rx<DoctorAppointmentDetailsModel?>(null);

  Future<void> fetchDoctorAppointmentDetails() async {
    await ApiRequest().get(
      fromJson: DoctorAppointmentDetailsModel.fromJson,
      endPoint: ApiEndPoints.doctorAppointmentDetails,
      isLoading: isLoading,
      id: appointmentId,
      // showResponse: true,
      onSuccess: (result) {
        doctorAppointmentDetailsModel.value = result;
        print('✅ Data loaded: ${result.data.patient.name}');

        //  print("dorctor id: ${result.data.}");
        print("doctor appointment id: ${result.data.id}");
      },
    );
  }

  Rx<UserAppointmentDetailsModel?> userAppointmentDetailsModel =
      Rx<UserAppointmentDetailsModel?>(null);

  Future<void> fetchUserAppointmentDetails() async {
    await ApiRequest().get(
      fromJson: UserAppointmentDetailsModel.fromJson,
      endPoint: ApiEndPoints.userAppointmentDetails,
      isLoading: isLoading,
      id: appointmentId,
      showResponse: true,
      onSuccess: (result) {
        userAppointmentDetailsModel.value = result;

        print("user appointment id: ${result.data?.id}");
        print("user appointment id: ${result.data?.id}");

        if (Get.isRegistered<ProfileController>()) {
          final profCtrl = Get.find<ProfileController>();
        }
        // fetchUserAppointedChatDetails(
        //   userId: result.data.doctorInfo.userId,
        //   appointmentId: appointmentId,
        // );
      },
    );
  }

  RxBool isLoadingChatDetails = false.obs;
  Rx<UserAppointChatDetailsModel?> userDoctorAppointChatDetailsModel =
      Rx<UserAppointChatDetailsModel?>(null);

  Future<void> fetchUserDoctorAppointedChatDetails({
    required String targeted_userId,
    required String appointmentId,
  }) async {
    await ApiRequest().get(
      fromJson: UserAppointChatDetailsModel.fromJson,
      // endPoint: '${ApiEndPoints.userAppointmentDetails}/$targeted_userId',
      endPoint:
          '${ApiEndPoints.userDoctorAppointedChatDetails}/$targeted_userId',
      isLoading: isLoadingChatDetails,
      showResponse: true,
      onSuccess: (result) {
        userDoctorAppointChatDetailsModel.value = result;
        log('conversationId : ${result.conversationId}');
        log('recipient name : ${result.recipient.name}');
        log('total messages : ${result.meta.total}');
      },
    );
  }

  // From DoctorProfileController or wherever you trigger chat
  // In AppointmentDetailsController

  void openChatAsDoctor() async {
    final patientDetails = doctorAppointmentDetailsModel.value?.data.patient;

    if (patientDetails == null) {
      CustomSnackBar.error('Appointment details not loaded yet.');
      return;
    }

    // 👇 fetch on button tap, then navigate
    await fetchUserDoctorAppointedChatDetails(
      targeted_userId: patientDetails.userId ?? '',
      appointmentId: appointmentId,
    );

    final chatDetails = userDoctorAppointChatDetailsModel.value;

    if (chatDetails == null) {
      CustomSnackBar.error('Could not load chat details.');
      return;
    }

    final data = doctorAppointmentDetailsModel.value?.data;
    if (data == null) {
      CustomSnackBar.error('Appointment details not loaded yet.');
      return;
    }

    final patient = data.patient;

    Get.toNamed(
      Routes.inboxScreen,
      arguments: {
        'conversationId':
            chatDetails.conversationId ?? '', // new or let backend handle
        'receiverId': chatDetails.recipient.id, // patient's userId
        'receiverRole': 'USER',
        'avatar': chatDetails.recipient.image,
        'name': chatDetails.recipient.name,
        'isOnline': false,
      },
    );
  }

  //{{baseUrl}}/api/chat/messages-by-user/696472aa51ce4bd422d0e5e9?appointmentId=6a31fe95016d4b96fde5a5d2

  RxBool isDeleting = false.obs;

  Future<BasicSuccessModel> rejectAppointment() async {
    return ApiRequest().post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: '/appointments/doctor/$appointmentId/reject',
      isLoading: isDeleting,
      body: {'reason': reasonController.text.trim()},
      onSuccess: (result) {
        Get.offAllNamed(Routes.navigationScreen);
      },
    );
  }

  //Review

  RxBool isSubmit = false.obs;

  RxInt rating = 0.obs;
  final feedbackController = TextEditingController();

  void setRating(int value) {
    rating.value = value;
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      Get.snackbar('Error', 'Please select rating');
      return;
    }

    if (feedbackController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please write feedback');
      return;
    }

    await ApiRequest().post(
      fromJson: BasicSuccessModel.fromJson,
      endPoint: '/reviews',
      isLoading: isSubmit,
      body: {
        "appointmentId": appointmentId,
        "rating": rating.value,
        "reviewText": feedbackController.text.trim(),
      },
      onSuccess: (result) {
        Get.close(2);
        CustomSnackBar.success(
          title: 'Review Submitted',
          message: 'Thank you for your feedback.',
        );
      },
    );
  }

  void showReviewDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.defaultHorizontalSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              TextWidget(
                'How Was Your Doctor',
                fontSize: Dimensions.titleLarge,
                fontWeight: FontWeight.bold,
              ),

              Space.height.v20,

              /// Star Rating
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return GestureDetector(
                      onTap: () => setRating(starIndex),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          Icons.star,
                          size: 30.w,
                          color: rating.value >= starIndex
                              ? CustomColors.primary
                              : Colors.grey.shade400,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              Space.height.v20,

              /// Feedback Field
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(Dimensions.radius),
                ),
                child: TextField(
                  controller: feedbackController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write Your Feedback",
                  ),
                ),
              ),

              Space.height.v20,
              Obx(
                () => PrimaryButtonWidget(
                  isLoading: isSubmit.value,
                  onPressed: submitReview,
                  title: 'Submit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
