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
      onSuccess: (result) {
        dashboardModel.value = result;
      },
    );
  }

  //

  void handleAppointmentAction({required String appStatus, required String appId}) {
    final status = appStatus.toUpperCase() ?? '';

    if (status == 'ONGOING') {
      joinVideoCall(appId );
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
