import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/model/basic_success_model.dart';
import '../../../core/api/services/api_request.dart';
import '../../../core/helpers/timezone_service.dart';
import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../model/bank_details_model.dart';

class BankDetailsController extends GetxController {
  final bankCodeController = TextEditingController();

  final isBankNameFocus = FocusNode();

  final bankNameController = TextEditingController();

  final numberController = TextEditingController();

  final passwordFocus = FocusNode();

  RxBool isLoading = false.obs;

  RxBool isGetDetails = false.obs;

  static final ApiRequest _api = ApiRequest();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // --------------------------------------------

  // GET BANKS

  // --------------------------------------------

  final RxList<BankModel> banks = <BankModel>[].obs;

  final selectedBank = Rxn<BankModel>();

  final RxBool bankApiFailed = false.obs;

  Future<void> getBanks() async {
    try {
      isGetDetails.value = true;
      bankApiFailed.value = false;

      final json = await _api.getRaw(
        url: 'https://api.paystack.co/bank?country=nigeria',
      );

      banks.assignAll(
        (json['data'] as List).map((e) => BankModel.fromJson(e)).toList(),
      );

      if (kDebugMode) {
        banks.insert(
          0,
          BankModel(
            name: "Test Bank Account",
            code: "058",
            testAccountNumber: "0000000000",
          ),
        );
      }

      if (banks.isEmpty) {
        bankApiFailed.value = true;
      }
    } catch (e) {
      bankApiFailed.value = true;
      CustomSnackBar.error(e.toString());
    } finally {
      isGetDetails.value = false;
    }
  }

  void selectBank(String bankName) {
    final bank = banks.firstWhere((e) => e.name == bankName);

    selectedBank.value = bank;

    bankNameController.text = bank.name;
    bankCodeController.text = bank.code;

    if (bank.testAccountNumber != null) {
      numberController.text = bank.testAccountNumber!;
    }
  }

  ///

  // Map<String, dynamic> get _requestBody => {

  //   "bankName": bankCodeController.text.trim(),

  //   "accountName": bankNameController.text.trim(),

  //   "accountNumber": numberController.text.trim(),

  // };

  Map<String, dynamic> get _requestBody => {
    "bankCode": bankCodeController.text.trim(),

    "bankName": bankNameController.text.trim(),

    "accountNumber": numberController.text.trim(),

    //     {

    //   "bankCode": "044",

    //   "accountNumber": "1234567890",

    //   "bankName": "Access Bank"

    // }
  };

  void _assignData(BankDetailsModel result) {
    bankCodeController.text = result.data?.bankCode ?? '';

    bankNameController.text = result.data?.bankName ?? '';

    numberController.text = result.data?.accountNumber ?? '';

    log("Bank Code: ${result.data?.bankCode}");

    log("Bank Name: ${result.data?.bankName}");

    log("Account Number: ${result.data?.accountNumber}");

    log("Has Recipient: ${result.data?.hasRecipient}");
  }

  Future<BasicSuccessModel> addDoctorBankAccount() async {
    return await _api.post(
      fromJson: BasicSuccessModel.fromJson,

      endPoint: ApiEndPoints.addDoctorBankAccount,

      isLoading: isLoading,

      showSuccessSnackBar: true,

      body: _requestBody,

      onSuccess: (result) {
        if (isFirstTime) {
          Get.offAllNamed(Routes.navigationScreen);

          Future.delayed(const Duration(milliseconds: 500), () async {
            await TimezoneService.checkAndSyncTimezone();
          });
        }
      },

      onError: (error) {
        log("Bank account error: $error");
      },
    );
  }

  Future<BasicSuccessModel> addUserBankAccount() async {
    return await _api.patch(
      fromJson: BasicSuccessModel.fromJson,

      endPoint: ApiEndPoints.addUserBankAccount,

      isLoading: isLoading,

      showSuccessSnackBar: true,

      body: _requestBody,

      onSuccess: (result) {
        Get.back();
      },
    );
  }

  Future<BankDetailsModel> getUserBankAccount() async {
    return await _api.get(
      fromJson: BankDetailsModel.fromJson,

      endPoint: ApiEndPoints.addUserBankAccount,

      isLoading: isGetDetails,

      showResponse: true,

      onSuccess: (result) {
        _assignData(result);
      },
    );
  }

  Future<BankDetailsModel> getBankDetails() async {
    return await _api.get(
      fromJson: BankDetailsModel.fromJson,

      endPoint: ApiEndPoints.addDoctorBankAccount,

      isLoading: isGetDetails,

      showResponse: true,

      onSuccess: (result) {
        _assignData(result);
      },
    );
  }

  bool isFirstTime = false;

  @override
  void onInit() {
    super.onInit();

    getBanks();

    isFirstTime = Get.arguments?['isFirstTime'] ?? false;

    if (AppStorage.isUser == 'USER') {
      getUserBankAccount();
    } else {
      if (!isFirstTime) {
        getBankDetails();
      }
    }

    if (kDebugMode) {
      bankCodeController.text = "044";

      bankNameController.text = "Access Bank";

      numberController.text = "1234567890";
    }

    //     {

    //   "bankCode": "044",

    //   "accountNumber": "1234567890",

    //   "bankName": "Access Bank"

    // }
  }

  @override
  void onClose() {
    bankCodeController.dispose();

    bankNameController.dispose();

    numberController.dispose();

    isBankNameFocus.dispose();

    passwordFocus.dispose();

    super.onClose();
  }
}

class BankModel {
  final String name;
  final String code;
  final String? testAccountNumber;

  BankModel({required this.name, required this.code, this.testAccountNumber});

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      testAccountNumber: json['testAccountNumber'],
    );
  }
}

/*



Doctor Uploads Documents

          │

          ▼

Documents Uploaded Successfully

          │

          ▼

Awaiting Verification Screen

          │

          ▼

Continue to Bank Details

          │

          ▼

Fill Bank Details

          │

          ▼

Submit

          │

          ▼

Login Screen



*/
