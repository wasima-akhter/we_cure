/*
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/core/utils/basic_import.dart';
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background: ${message.notification?.title}');
}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // ✅ App OPEN থাকলে
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _showCustomNotification(message);
    });

    // ✅ App BACKGROUND এ tap করলে
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message);
    });

    // ✅ App KILLED থাকলে tap করলে
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(seconds: 1), () {
        _handleNavigation(initialMessage);
      });
    }

    final token = await getToken();
    debugPrint('✅ FCM Token: $token');

    _messaging.onTokenRefresh.listen((token) {
      sendTokenToServer(token);
    });
  }

  static void _handleNavigation(RemoteMessage message) {
    final type = message.data['type'];
    final id = message.data['id'];
    switch (type) {
      case 'appointment':
        Get.toNamed(Routes.appointmentScreen, arguments: id);
        break;
      case 'chat':
        Get.toNamed(Routes.chatScreen, arguments: id);
        break;
      default:
        Get.toNamed(Routes.navigationScreen);
    }
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static Future<BasicSuccessModel> sendTokenToServer(String token) async {
    return ApiRequest().patch(
      body: {'token': token},
      fromJson: BasicSuccessModel.fromJson,
      endPoint: '/users/fcm-token',
      isLoading: false.obs,
      onSuccess: (result) {
        debugPrint(
          '✅---------------------------------------------------------------------',
        );
        debugPrint('✅ FCM Token: $token');
        debugPrint(
          '✅---------------------------------------------------------------------',
        );
      },
    );
  }

  //In app notification style
  static void _showCustomNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      padding: EdgeInsets.zero,
      borderRadius: 16.r,
      messageText: GestureDetector(
        onTap: () {
          Get.closeCurrentSnackbar();
          _handleNavigation(message);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20.r,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: CustomColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  color: CustomColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      notification.title ?? '',
                      fontSize: Dimensions.titleSmall,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.blackColor,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    TextWidget(
                      notification.body ?? '',
                      fontSize: Dimensions.labelMedium,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.secondaryDarkText,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: CustomColors.secondaryDarkText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/core/utils/basic_import.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background: \${message.notification?.title}');
}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _showCustomNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(seconds: 1), () {
        _handleNavigation(initialMessage);
      });
    }

    final token = await getToken();
    debugPrint('✅ FCM Token: \$token');

    _messaging.onTokenRefresh.listen((token) {
      sendTokenToServer(token);
    });
  }

  static void _handleNavigation(RemoteMessage message) {
    final type = message.data['type'];
    final id = message.data['id'];
    switch (type) {
      case 'appointment':
        Get.toNamed(Routes.appointmentScreen, arguments: id);
        break;
      case 'chat':
        Get.toNamed(Routes.chatScreen, arguments: id);
        break;
      default:
        Get.toNamed(Routes.navigationScreen);
    }
  }

  static Future<String?> getToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint(
            '⚠️ APNS token not available (simulator). Skipping FCM token fetch.',
          );
          return null;
        }
      }
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('⚠️ FCM token error: \$e');
      return null;
    }
  }

  static Future<BasicSuccessModel> sendTokenToServer(String token) async {
    return ApiRequest().patch(
      body: {'token': token},
      fromJson: BasicSuccessModel.fromJson,
      endPoint: '/users/fcm-token',
      isLoading: false.obs,
      onSuccess: (result) {
        debugPrint('✅ FCM Token: \$token');
      },
    );
  }

  static void _showCustomNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      padding: EdgeInsets.zero,
      borderRadius: 16.r,
      messageText: GestureDetector(
        onTap: () {
          Get.closeCurrentSnackbar();
          _handleNavigation(message);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20.r,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: CustomColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  color: CustomColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      notification.title ?? '',
                      fontSize: Dimensions.titleSmall,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.blackColor,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    TextWidget(
                      notification.body ?? '',
                      fontSize: Dimensions.labelMedium,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.secondaryDarkText,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: CustomColors.secondaryDarkText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
