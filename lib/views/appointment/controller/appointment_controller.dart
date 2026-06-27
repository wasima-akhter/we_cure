import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../model/doctor_appoinment_model.dart';
import '../model/user_all_appoinment.dart';

class AppointmentController extends GetxController {
  static AppointmentController get to => Get.find<AppointmentController>();
  final isUserLoading = false.obs;
  final isDoctorLoading = false.obs;

  final userAppointments = Rxn<UserAllAppointment>();
  final doctorAppointments = Rxn<DoctorAppointmentsModel>();

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    if (AppStorage.isUser == 'USER') {
      fetchUserAppointments();
    } else {
      fetchDoctorAppointments();
    }
  }

  Future<void> fetchUserAppointments() async {
    await ApiRequest().get(
      fromJson: UserAllAppointment.fromJson,
      endPoint: ApiEndPoints.appointments,
      isLoading: isUserLoading,
      onSuccess: (result) {
        userAppointments.value = result;
        for (var a in result.data) {
          print('Appointment: ${a.id} | Status: ${a.status}');
        }
      },
    );
  }

  Future<void> fetchDoctorAppointments() async {
    await ApiRequest().get(
      fromJson: DoctorAppointmentsModel.fromJson,
      endPoint: ApiEndPoints.doctorAppointments,
      isLoading: isDoctorLoading,
      onSuccess: (result) {
        doctorAppointments.value = result;
      },
    );
  }

  void handleAppointmentAction(dynamic appointment) {
    final status = appointment.status?.toUpperCase() ?? '';

    if (status == 'ONGOING') {
      joinVideoCall(appointment.id);
    } else if (status == 'COMPLETED' ||
        status == 'CANCELLED' ||
        status == 'UPCOMING') {
      Get.toNamed(Routes.appointmentDetailsScreen, arguments: appointment.id);
    }
  }

  void joinVideoCall(String appointmentId) {
    Get.toNamed(Routes.videoCallScreen, arguments: appointmentId);
  }
}
