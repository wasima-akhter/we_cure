import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/views/chat/model/chat_person_model.dart';

import '../../../core/utils/basic_import.dart';
/*
class ChatController extends GetxController {
  RxBool isLoading = false.obs;

  ChatPersonListModel? chatPersonListModel;

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  RxString searchQuery = ''.obs;

  RxList<PersonData> filteredList = <PersonData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllUserChatPerson();
  }

  @override
  void onClose() {
    searchFocusNode.unfocus();
    searchFocusNode.dispose();
    searchController.dispose();

    super.onClose();
  }

  void onSearchChanged(String query) {
    searchFocusNode.unfocus();
    searchQuery.value = query;
    final allData = chatPersonListModel?.data ?? [];
    if (query.trim().isEmpty) {
      filteredList.assignAll(allData);
    } else {
      filteredList.assignAll(
        allData.where((item) {
          final name = item.participants.isNotEmpty
              ? item.participants.first.name.toLowerCase()
              : '';
          return name.contains(query.toLowerCase().trim());
        }).toList(),
      );
    }
  }

  Future<ChatPersonListModel> getAllUserChatPerson() async {
    return ApiRequest().get(
      fromJson: ChatPersonListModel.fromJson,
      endPoint: '/chat/conversations',
      isLoading: isLoading,
      onSuccess: (result) {
        chatPersonListModel = result;
        filteredList.assignAll(result.data);
      },
    );
  }
}
*/

class ChatController extends GetxController {
  RxBool isLoading = false.obs;

  ChatPersonListModel? chatPersonListModel;

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  RxString searchQuery = ''.obs;

  RxList<PersonData> filteredList = <PersonData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllUserChatPerson();
  }

  @override
  void onClose() {
    searchFocusNode.unfocus();
    searchFocusNode.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    searchFocusNode.unfocus();
    searchQuery.value = query;
    final allData = chatPersonListModel?.data ?? [];
    if (query.trim().isEmpty) {
      filteredList.assignAll(allData);
    } else {
      filteredList.assignAll(
        allData.where((item) {
          final name = item.participants.isNotEmpty
              ? item.participants.first.name.toLowerCase()
              : '';
          return name.contains(query.toLowerCase().trim());
        }).toList(),
      );
    }
  }

  Future<void> getAllUserChatPerson() async {
    await ApiRequest().get(
      fromJson: ChatPersonListModel.fromJson,
      endPoint: '/chat/conversations',
      isLoading: isLoading,
      onSuccess: (result) {
        chatPersonListModel = result;
        filteredList.assignAll(result.data);
      },
    );
  }
}
