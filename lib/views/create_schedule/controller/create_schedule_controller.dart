import 'package:flutter/foundation.dart';

import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/utils/basic_import.dart';
import '../../schedule/controller/schedule_controller.dart';
import '../../schedule/model/schedule_model.dart';
import '../model/edit_schedule_model.dart';

/*
class CreateScheduleController extends GetxController {
  final feeController = TextEditingController();
  final durationController = TextEditingController();

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxString startTime = ''.obs;
  RxString endTime = ''.obs;

  @override
  void onInit() {
    if (kDebugMode) {
      durationController.text = "30";
      feeController.text = "1";
    }
    super.onInit();
  }

  List<String> dayList = [];
  RxBool isLoading = false.obs;

  Future<void> createSchedule() async {
    if (dayList.isEmpty) {
      CustomSnackBar.error('Please select at least one day');
      return;
    }
    if (feeController.text.isEmpty || durationController.text.isEmpty) {
      CustomSnackBar.error('Please fill all fields');
      return;
    }

    await ApiRequest().post(
      fromJson: ScheduleModel.fromJson,
      endPoint: ApiEndPoints.createSchedule,
      isLoading: isLoading,
      showSuccessSnackBar: true,
      body: {
        "days": dayList.map((e) => e.toUpperCase()).toList(),
        "startTime": startTime.value,
        "endTime": endTime.value,
        "slotSizeMinutes": int.tryParse(durationController.text) ?? 0,
        "fee": int.tryParse(feeController.text) ?? 0,
      },
      onSuccess: (result) {
        Get.close(1);
        Get.find<ScheduleController>().getAllSchedule();
      },
    );
  }

  @override
  void onClose() {
    feeController.dispose();
    durationController.dispose();
    super.onClose();
  }
}
*/

class CreateScheduleController extends GetxController {
  final feeController = TextEditingController();
  final durationController = TextEditingController();

  RxString startTime = ''.obs;
  RxString endTime = ''.obs;

  RxInt calculatedDuration = 0.obs;

  void calculateDuration() {
    final start = startTime.value;
    final end = endTime.value;

    if (start.isEmpty || end.isEmpty) return;

    final startParts = start.split(':');
    final endParts = end.split(':');

    if (startParts.length < 2 || endParts.length < 2) return;

    final startHour = int.tryParse(startParts[0]) ?? 0;
    final startMin = int.tryParse(startParts[1]) ?? 0;

    final endHour = int.tryParse(endParts[0]) ?? 0;
    final endMin = int.tryParse(endParts[1]) ?? 0;

    final startMinutes = startHour * 60 + startMin;
    final endMinutes = endHour * 60 + endMin;

    final diff = endMinutes - startMinutes;

    // if (diff > 0) {
    //   calculatedDuration.value = diff;
    //   durationController.text = diff.toString();
    // } else {
    //   calculatedDuration.value = 0;
    //   durationController.text = '';
    // }
  }

  // Edit mode state
  Schedules? editingSchedule;
  bool get isEditMode => editingSchedule != null;

  List<String> dayList = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Check if opened for editing
    if (Get.arguments != null && Get.arguments is Schedules) {
      editingSchedule = Get.arguments as Schedules;
      _prefillData(editingSchedule!);
    } else if (kDebugMode) {
      durationController.text = "30";
      feeController.text = "50";
    }
  }

  // In CreateScheduleController, add this:
  final dayDisplayController = TextEditingController();

  void _prefillData(Schedules schedule) {
    feeController.text = schedule.fee.toString();
    durationController.text = schedule.slotSizeMinutes.toString();
    startTime.value = schedule.startTime;
    endTime.value = schedule.endTime;
    dayList = [schedule.dayOfWeek];
    dayDisplayController.text = schedule.dayOfWeek; // 👈 for the locked field
  }

  @override
  void onClose() {
    feeController.dispose();
    durationController.dispose();
    dayDisplayController.dispose(); // 👈 dispose it
    super.onClose();
  }

  Future<void> createSchedule() async {
    final validationError = _validateForm();

    if (validationError != null) {
      CustomSnackBar.error(validationError);
      return;
    }

    if (isEditMode) {
      await _editSchedule();
    } else {
      await _createSchedule();
    }
  }

  String? _validateForm() {
    if (dayList.isEmpty) {
      return 'Please select at least one day';
    }

    if (startTime.value.isEmpty || endTime.value.isEmpty) {
      return 'Please select start and end time';
    }

    if (durationController.text.trim().isEmpty) {
      return 'Please enter duration';
    }

    if (feeController.text.trim().isEmpty) {
      return 'Please enter fee';
    }

    final feeError = _validateFee();
    if (feeError != null) return feeError;

    final durationError = _validateDuration();
    if (durationError != null) return durationError;

    final timeError = _validateTimeRange();
    if (timeError != null) return timeError;

    return null;
  }

  String? _validateFee() {
    final fee = double.tryParse(feeController.text.trim());

    if (fee == null) {
      return 'Fee must be a valid number';
    }

    if (fee < 50) {
      return 'Fee must be at least ₦50';
    }

    return null;
  }

  String? _validateDuration() {
    final duration = int.tryParse(durationController.text.trim());

    if (duration == null || duration <= 0) {
      return 'Duration must be greater than 0';
    }

    return null;
  }

  String? _validateTimeRange() {
    try {
      final startParts = startTime.value.split(':');
      final endParts = endTime.value.split(':');

      final startMinutes =
          (int.parse(startParts[0]) * 60) + int.parse(startParts[1]);

      final endMinutes = (int.parse(endParts[0]) * 60) + int.parse(endParts[1]);

      if (startMinutes >= endMinutes) {
        return 'Starting time must be earlier than ending time';
      }

      return null;
    } catch (_) {
      return 'Invalid time selected';
    }
  }

  Future<void> _createSchedule() async {
    await ApiRequest().post(
      fromJson: ScheduleModel.fromJson,
      endPoint: ApiEndPoints.createSchedule,
      isLoading: isLoading,
      showSuccessSnackBar: true,
      body: {
        "days": dayList.map((e) => e.toUpperCase()).toList(),
        "startTime": startTime.value,
        "endTime": endTime.value,
        "slotSizeMinutes": int.tryParse(durationController.text) ?? 0,
        "fee": int.tryParse(feeController.text) ?? 0,
      },
      onSuccess: (result) {
        Get.close(1);
        Get.find<ScheduleController>().getAllSchedule();
      },
    );
  }

  Future<void> _editSchedule() async {
    await ApiRequest().patch(
      // 👈 PATCH method
      fromJson: ScheduleResponse.fromJson,
      endPoint: '${ApiEndPoints.editSchedule}/${editingSchedule!.id}',
      isLoading: isLoading,
      showSuccessSnackBar: true,
      body: {
        "dayOfWeek": dayList.first.toUpperCase(), // single day for edit
        "startTime": startTime.value,
        "endTime": endTime.value,
        "slotSizeMinutes": int.tryParse(durationController.text) ?? 0,
        "fee": int.tryParse(feeController.text) ?? 0,
      },
      onSuccess: (result) {
        Get.close(1);
        Get.find<ScheduleController>().getAllSchedule();
      },
    );
  }
}
