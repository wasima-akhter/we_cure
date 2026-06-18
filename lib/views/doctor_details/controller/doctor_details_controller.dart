import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/views/doctor_details/model/all_date_model.dart';
import 'package:glady/views/doctor_details/model/doctor_details_model.dart';
import 'package:glady/views/doctor_details/model/time_model.dart';

import '../../../core/utils/basic_import.dart' hide Data;

class DoctorDetailsController extends GetxController {
  String? doctorId = '';

  @override
  void onInit() {
    super.onInit();
    doctorId = Get.arguments as String;
    getDoctorDetailsInfo(doctorId ?? '');
    fetchAllDate();
  }

  // Booking Dialog
  RxString selectedDate = ''.obs;
  RxString selectedTime = ''.obs;
  RxBool showTimeSlots = false.obs;
  RxInt selectedDateIndex = (-1).obs;
  RxInt selectedTimeIndex = (-1).obs;

  RxList<AllDates> datesDayList = <AllDates>[].obs;
  RxList<AllTimes> timeList = <AllTimes>[].obs;

  // API
  RxBool isLoading = false.obs;
  DoctorDetailsInfoModel? doctorDetailsInfoModel;

  final doctorDetailsInfoModelEmpty = DoctorDetailsInfoModel(
    success: false,
    statusCode: 0,
    message: '',
    data: Data(
      doctor: Doctor(
        id: '',
        userId: UserId(id: '', email: null, name: '', profileImage: ''),
        currentOrganization: '',
        specialtyId: SpecialtyId(id: '', name: ''),
        about: '',
        consultationFee: null,
        verificationStatus: '',
        isVerified: false,
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
        v: 0,
        verificationNote: '',
        accountName: 'N/A',
        accountNumber: 'N/A',
        bankName: 'N/A',
        paystackRecipientCode: 'N/A',
        pendingPayouts: 0,
        recipientCreatedAt: null,
        totalEarnings: 0,
        totalPayouts: 0,
        dateOfBirth: '',
        experienceYears: 0,
        totalExperienceYears: 0,
      ),
      services: [],
      experiences: [],
      rating: Rating(
        average: 0.0,
        total: 0,
        breakdown: {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
      ),
      reviews: [],
      availability: [],
    ),
  );

  Future<DoctorDetailsInfoModel> getDoctorDetailsInfo(String doctorId) async {
    return ApiRequest().get(
      fromJson: DoctorDetailsInfoModel.fromJson,
      endPoint: '/doctors/$doctorId/public',
      isLoading: isLoading,
      onSuccess: (result) {
        doctorDetailsInfoModel = result;
        // doctorDetailsInfoModel = doctorDetailsInfoModelEmpty;
      },
    );
  }

  RxBool isLoadingDate = false.obs;
  AllDateModel? allDateModel;

  Future<void> fetchAllDate() async {
    try {
      await ApiRequest().get(
        fromJson: AllDateModel.fromJson,
        endPoint: ApiEndPoints.availableDates,
        queryParams: {'doctorId': doctorId},
        isLoading: isLoadingDate,
        onSuccess: (result) {
          allDateModel = result;
          datesDayList.clear();
          datesDayList.assignAll(result.data);

          debugPrint(result.data.toString());
        },
      );
    } catch (_) {}
  }

  RxBool isLoadingTime = false.obs;
  AllTimeModel? allTimeModel;

  Future<void> fetchAllTimes(String date) async {
    try {
      timeList.clear();
      selectedTimeIndex.value = -1;
      selectedTime.value = '';
      await ApiRequest().get(
        fromJson: AllTimeModel.fromJson,
        endPoint: ApiEndPoints.availableSlots,
        queryParams: {'doctorId': doctorId, 'date': date},
        isLoading: isLoadingTime,
        onSuccess: (result) {
          allTimeModel = result;
          timeList.assignAll(result.data);
        },
      );
    } catch (_) {}
  }

  Future<void> refreshDoctorDetails() async {
    try {
      // reset booking selections
      selectedDate.value = '';
      selectedTime.value = '';
      selectedDateIndex.value = -1;
      selectedTimeIndex.value = -1;

      timeList.clear();
      datesDayList.clear();

      // reload APIs together
      await Future.wait([getDoctorDetailsInfo(doctorId ?? ''), fetchAllDate()]);
    } catch (e) {
      debugPrint("Doctor refresh error: $e");
    }
  }
}
