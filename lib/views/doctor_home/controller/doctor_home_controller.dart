import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../../home/model/home_appoinment_model.dart';

class DoctorHomeController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<DoctorDashboardModel?> dashboardModel = Rx<DoctorDashboardModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<DoctorDashboardModel> fetchDashboard() async {
    return ApiRequest().get(
      fromJson: DoctorDashboardModel.fromJson,
      endPoint: ApiEndPoints.doctorHome,
      isLoading: isLoading,
      showResponse: true,
      onSuccess: (result) {
        dashboardModel.value = result;
      },
    );
  }

  Future<void> testPushNotification() async {
    await ApiRequest().post(
      fromJson: (p0) {},
      endPoint: '/notifications/test-push',
      body: {
        'title': 'Hello from Backend!',
        'body': 'This is a test push notification.',
        'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
      },
      isLoading: isLoading,
      onSuccess: (_) {
        debugPrint('Test push notification sent successfully');
      },
    );
  }

  //

  void handleAppointmentAction({
    required String appStatus,
    required String appId,
  }) {
    final status = appStatus.toUpperCase() ?? '';

    if (status == 'ONGOING') {
      joinVideoCall(appId);
    } else if (status == 'COMPLETED' ||
        status == 'CANCELLED' ||
        status == 'UPCOMING') {
      Get.toNamed(Routes.appointmentDetailsScreen, arguments: appId);
    }
  }

  void joinVideoCall(String appointmentId) {
    Get.toNamed(Routes.videoCallScreen, arguments: appointmentId);
  }
}
