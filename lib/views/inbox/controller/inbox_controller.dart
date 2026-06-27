import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:glady/core/api/end_point/api_end_points.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:http/http.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart' hide FormData, MultipartFile;
import '../model/all_conversation_model.dart';
import '../model/chat_message_model.dart';
import '../model/inbox_args_model.dart';

class InboxController extends GetxController {
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final args = InboxArgsModel.fromMap(Get.arguments);

  final RxBool shouldAutoScroll = true.obs;
  final RxBool isTyping = false.obs;
  final int maxImageCount = 5;

  final RxBool isLoading = true.obs;

  RxList<ChatMessageModel> messagesList = <ChatMessageModel>[].obs;
  final RxList<XFile> multipleImages = <XFile>[].obs;
  final RxSet<String> animatedMessageIds = <String>{}.obs;

  late IO.Socket socket;
  String myId = '';

  final RxBool isLoadingOldMessage = false.obs;
  final RxBool isPaginationLoading = false.obs;

  bool hasMore = true;
  int currentPage = 1;
  int limit = 10;
  int skip = 0;

  String _conversationId = '';
  @override
  void onInit() {
    super.onInit();
    _conversationId = args.conversationId; // may be empty
    scrollController.addListener(_onScroll);

    //
    // ✅ Fetch old messages immediately — no socket dependency
    if (_conversationId.isNotEmpty) {
      getOldMessages();
    } else {
      // New conversation — nothing to load, just stop loading spinner
      isLoading.value = false;
    }
    //
    _initSocket();
  }

  // Add this field

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isPaginationLoading.value && hasMore) {
        currentPage++;
        getOldMessages(isPagination: true);
      }
    }
  }

  void _initSocket() {
    socket = IO.io(
      "${ApiEndPoints.base}"
      "?token=${AppStorage.token}",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setReconnectionAttempts(10)
          .build(),
    );

    socket.onConnect((_) {
      log("✅ Socket connected");
    });
    socket.onDisconnect((_) => log("❌ Socket disconnected"));
    socket.onError((error) => log("❌ Socket error: $error"));
    socket.onConnectError((error) => log("❌ Socket connect error: $error"));
    socket.onReconnect((_) => log("✅ Socket reconnected"));
    socket.onReconnectError((error) => log("❌ Socket reconnect error: $error"));

    socket.on('connection_confirmed', (data) {
      log("✅ connection_confirmed: $data");
      myId = data['data']?['userId']?.toString() ?? '';
      log("✅ myId set: $myId");
    });

    socket.on('message_new', (data) {
      listenMsgInstant(data);
    });

    socket.on('typing', (data) {
      log("✏️ typing: $data");
      isTyping.value = (data['senderId'] != myId) && (data['isTyping'] == true);
    });

    socket.on('conversation_update', (data) {
      log("🔄 conversation_update: $data");
    });
  }

  void listenMsgInstant(dynamic data) {
    final senderId = data["sender"]?["id"]?.toString() ?? '';
    if (senderId == myId) return;

    List<String> imagesList = [];
    if (data["images"] != null) {
      imagesList = (data["images"] as List)
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
    }

    messagesList.add(
      ChatMessageModel(
        isMe: false,
        type: imagesList.isNotEmpty ? MessageType.image : MessageType.text,
        message: data['text'] ?? '',
        images: imagesList,
        senderId: data['_id']?.toString(),
        isUploading: false,
        isSeen: data['seen'] ?? false,
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      ),
    );

    scrollToBottom();
  }

  void sendMessage() {
    if (textController.text.trim().isEmpty && multipleImages.isEmpty) return;

    print(
      "receiver:  args.receiverId : ${args.receiverId},  args.receiverRole : ${args.receiverRole}},",
    );
    if (multipleImages.isNotEmpty) {
      sendMessageWithImages();
    } else {
      sendTextMessage();
    }
  }

  void sendTextMessage() {
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    messagesList.add(
      ChatMessageModel(
        isMe: true,
        senderId: tempId,
        type: MessageType.text,
        message: textController.text.trim(),
      ),
    );
    scrollToBottom();

    final body = {
      "sender": {"id": myId, "role": AppStorage.isUser},
      "receiver": {"id": args.receiverId, "role": args.receiverRole},
      "text": textController.text.trim(),

      // ✅ include conversationId only if it exists
      if (_conversationId.isNotEmpty) "conversationId": _conversationId,
    };

    socket.emit('send_message', body);
    textController.clear();
  }

  Future<void> sendMessageWithImages() async {
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    final localPaths = multipleImages.map((e) => e.path).toList();
    final messageText = textController.text.trim();

    // ✅ সাথে সাথে clear
    textController.clear();
    multipleImages.clear();

    messagesList.add(
      ChatMessageModel(
        isMe: true,
        senderId: tempId,
        type: MessageType.image,
        message: messageText,
        images: localPaths, // ✅ local preview
        isUploading: true,
      ),
    );
    scrollToBottom();

    final List<String> uploadedImagePaths = await uploadImages(
      localPaths.map((e) => XFile(e)).toList(),
    );

    if (uploadedImagePaths.isEmpty) {
      CustomSnackBar.error('Failed to send images');
      messagesList.removeWhere((msg) => msg.senderId == tempId);
      return;
    }

    final messageIndex = messagesList.indexWhere(
      (msg) => msg.senderId == tempId,
    );
    if (messageIndex != -1) {
      messagesList[messageIndex] = messagesList[messageIndex].copyWith(
        images: uploadedImagePaths,
        isUploading: false,
      );
      messagesList.refresh();
    }

    final body = {
      "sender": {"id": myId, "role": AppStorage.isUser},
      "receiver": {"id": args.receiverId, "role": args.receiverRole},
      "text": messageText,
      "images": uploadedImagePaths,
    };

    log(
      "receiver:  args.receiverId : ${args.receiverId},  args.receiverRole : ${args.receiverRole}},",
    );
    socket.emit('send_message', body);
  }

  Future<List<String>> uploadImages(List<XFile> images) async {
    if (images.isEmpty) return [];

    try {
      final List<String> uploadedPaths = [];
      final dio = Dio();

      for (int i = 0; i < images.length; i++) {
        final image = images[i];

        String mimeType = 'image/jpeg';
        final extension = image.path.toLowerCase();
        if (extension.endsWith('.png')) {
          mimeType = 'image/png';
        } else if (extension.endsWith('.gif'))
          mimeType = 'image/gif';
        else if (extension.endsWith('.webp'))
          mimeType = 'image/webp';

        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.name,
            contentType: MediaType.parse(mimeType),
          ),
        });

        log('📤 Uploading image ${i + 1}/${images.length}: ${image.name}');

        final response = await dio.post(
          '${ApiEndPoints.baseUrl}/chat/upload',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${AppStorage.token}',
              'Content-Type': 'multipart/form-data',
            },
            validateStatus: (status) => status! < 500,
          ),
        );

        log('📥 Response status: ${response.statusCode}');
        log('📥 Response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = response.data;
          if (responseData['success'] == true &&
              responseData['data'] != null &&
              responseData['data']['url'] != null) {
            final url = responseData['data']['url'].toString();
            if (url.isNotEmpty) {
              uploadedPaths.add(url);
              log('✅ Image url: $url');
            }
          }
        } else {
          log('❌ Upload failed: ${response.statusCode}');
        }
      }

      log('✅ Total uploaded: ${uploadedPaths.length}/${images.length}');
      return uploadedPaths;
    } catch (e) {
      log('❌ Error: $e');
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          CustomSnackBar.error('Upload timeout. Please check your connection');
        } else if (e.type == DioExceptionType.connectionError) {
          CustomSnackBar.error('Network error. Please try again');
        }
      } else {
        CustomSnackBar.error('Unexpected error during upload');
      }
      return [];
    }
  }

  Future<void> getOldMessages({bool isPagination = false}) async {
    if (isPagination && !hasMore) return;

    if (isPagination) {
      isPaginationLoading.value = true;
    } else {
      isLoading.value = true; // ✅ শুধু first load এ
    }

    final double previousOffset = isPagination && scrollController.hasClients
        ? scrollController.position.maxScrollExtent
        : 0.0;
    log("AppStorage.token: ${AppStorage.token}");
    await ApiRequest().get(
      fromJson: AllConversationModel.fromJson,
      endPoint:
          '/chat/messages/${args.conversationId}?page=$currentPage&limit=$limit',
      isLoading: isPagination
          ? isPaginationLoading
          : isLoading, // ✅ আলাদা loading variable
      onSuccess: (result) {
        final newMessages = (result.conversation ?? [])
            .map((conversion) {
              return ChatMessageModel(
                isMe: conversion.sender.id == myId,
                type: conversion.images.isNotEmpty
                    ? MessageType.image
                    : MessageType.text,
                message: conversion.text,
                images: conversion.images,
                senderId: conversion.sender.id,
                isUploading: false,
                isSeen: conversion.seen,
                createdAt: conversion.createdAt,
              );
            })
            .toList()
            .reversed
            .toList();

        if (isPagination) {
          messagesList.insertAll(0, newMessages);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              final newMax = scrollController.position.maxScrollExtent;
              scrollController.jumpTo(newMax - previousOffset);
            }
          });
        } else {
          messagesList.assignAll(newMessages);
          scrollToBottom();
        }

        skip += newMessages.length;
        if (newMessages.length < limit) hasMore = false;
      },
    );

    isPaginationLoading.value = false;
    isLoading.value = false;
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    textController.dispose();
    scrollController.dispose();

    super.onClose();
  }
}
