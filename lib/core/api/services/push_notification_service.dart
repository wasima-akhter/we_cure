import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:glady/core/api/model/basic_success_model.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:glady/core/utils/basic_import.dart';
import 'package:glady/views/navigation/controller/navigation_controller.dart';

import '../../utils/app_storage.dart';
/*
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
*/

/*
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint("==============================");
  debugPrint("🔥 [FCM] BACKGROUND MESSAGE");
  debugPrint("ID: ${message.messageId}");
  debugPrint("DATA: ${message.data}");
  debugPrint("TITLE: ${message.notification?.title}");
  debugPrint("BODY: ${message.notification?.body}");
  debugPrint("==============================");
}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static String?
  _cachedToken; // 👈 holds the token until we're allowed to send it

  static Future<void> init() async {
    debugPrint("🔥 [FCM] Initialization started");

    try {
      final permission = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint(
        "🔥 [FCM] Permission status: ${permission.authorizationStatus}",
      );

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

      // fetch + cache only — do NOT send yet, we likely have no session
      _cachedToken = await getToken();
      if (_cachedToken != null) {
        debugPrint("✅ [FCM] Device token cached: $_cachedToken");

        // if a session already exists (e.g. app restart while logged in),
        // send immediately
        if (AppStorage.token.isNotEmpty) {
          await sendTokenToServer(_cachedToken!);
        }
      } else {
        debugPrint("❌ [FCM] Device token is NULL");
      }

      _messaging.onTokenRefresh.listen((token) {
        debugPrint("🔄 [FCM] Token refreshed");
        _cachedToken = token;

        // only push to backend if we're currently authenticated;
        // otherwise it'll be sent by syncTokenIfPending() after login
        if (AppStorage.token.isNotEmpty) {
          sendTokenToServer(token);
        }
      }, onError: (error) => debugPrint("❌ [FCM] Token refresh error: $error"));

      debugPrint("✅ [FCM] Initialization completed successfully");
    } catch (e, stack) {
      debugPrint("❌ [FCM] Initialization failed: $e");
      debugPrint(stack.toString());
    }
  }

  /// Call this right after login succeeds — sends whatever token
  /// we already have cached, now that we have a valid access token.
  static Future<void> syncTokenAfterLogin() async {
    final token = _cachedToken ?? await getToken();
    if (token == null) {
      debugPrint("❌ [FCM] No token available to sync after login");
      return;
    }
    await sendTokenToServer(token);
  }

  static Future<String?> getToken() async {
    try {
      debugPrint("🔥 [FCM] Fetching FCM token...");

      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        debugPrint("🍎 [FCM] Checking APNS token");

        final apnsToken = await _messaging.getAPNSToken();

        if (apnsToken == null) {
          debugPrint("❌ [FCM] APNS token unavailable");

          return null;
        }

        debugPrint("✅ [FCM] APNS token received");
      }

      final token = await _messaging.getToken();

      debugPrint("🔥 [FCM] getToken result: $token");

      return token;
    } catch (e, stack) {
      debugPrint("❌ [FCM] getToken failed: $e");

      debugPrint(stack.toString());

      return null;
    }
  }

  static Future<BasicSuccessModel> sendTokenToServer(String token) async {
    debugPrint("📤 [FCM] Sending token to backend");

    debugPrint(token);

    try {
      final result = await ApiRequest().patch(
        body: {'token': token},

        fromJson: BasicSuccessModel.fromJson,

        endPoint: '/users/fcm-token',

        isLoading: false.obs,

        onSuccess: (result) {
          debugPrint("✅ [FCM] Token saved successfully");

          debugPrint(result.toString());
        },
      );

      debugPrint("✅ [FCM] Backend token update completed");

      return result;
    } catch (e, stack) {
      debugPrint("❌ [FCM] Backend token update failed");

      debugPrint("Error: $e");

      debugPrint(stack.toString());

      rethrow;
    }
  }

  static void _handleNavigation(RemoteMessage message) {
    debugPrint("🚀 [FCM] Handling navigation");

    final type = message.data['type'];
    final id = message.data['id'];

    debugPrint("Navigation type: $type");

    debugPrint("Navigation id: $id");

    switch (type) {
      case 'appointment':
        debugPrint("➡️ Opening appointment screen");

        if (Get.isRegistered<NavigationController>()) {
          NavigationController.to.selectedIndex.value = 2;
        }

        Get.toNamed(Routes.navigationScreen);

        break;

      case 'chat':
        debugPrint("➡️ Opening chat screen");

        if (Get.isRegistered<NavigationController>()) {
          NavigationController.to.selectedIndex.value = 3;
        }

        Get.toNamed(Routes.navigationScreen);

        break;

      default:
        debugPrint("➡️ Opening home screen");

        if (Get.isRegistered<NavigationController>()) {
          NavigationController.to.selectedIndex.value = 0;
        }

        Get.toNamed(Routes.navigationScreen);
    }
  }

  static void _showCustomNotification(RemoteMessage message) {
    debugPrint("🔔 [FCM] Showing foreground snackbar");

    final notification = message.notification;

    if (notification == null) {
      debugPrint("❌ [FCM] Snackbar cancelled. No notification");

      return;
    }

    // Get.rawSnackbar(
    //   snackPosition: SnackPosition.TOP,
    //   message: notification.body ?? '',

    //   duration: const Duration(seconds: 4),
    // );

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.zero,
      borderRadius: 18.r,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 350),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,

      messageText: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: CustomColors.primary.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42.r,
              width: 42.r,
              decoration: BoxDecoration(
                color: CustomColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.notifications_rounded,
                color: CustomColors.primary,
                size: 24.r,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    notification.title ?? "Notification",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.blackColor,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.h),

                  TextWidget(
                    notification.body ?? '',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.grayShade,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.r,
              color: CustomColors.grayShade,
            ),
          ],
        ),
      ),

      onTap: (_) {
        Get.closeCurrentSnackbar();
        _handleNavigation(message);
      },
    );
    debugPrint("✅ [FCM] Snackbar displayed");
  }

  static void testForegroundNotification() {
    debugPrint("🧪 [FCM TEST] Creating mock foreground notification");

    final mockMessage = RemoteMessage(
      messageId: "mock_message_001",
      data: {"type": "appointment", "id": "12345"},
      notification: const RemoteNotification(
        title: "New Chat Message",
        body: "You have received a new message from a patient",
      ),
    );

    debugPrint("🧪 [FCM TEST] Mock data: ${mockMessage.data}");

    _showCustomNotification(mockMessage);

    debugPrint("🧪 [FCM TEST] Mock notification triggered");
  }
}
*/

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('');
  debugPrint('════════════════════════════════════════════');
  debugPrint('🔥 [FCM] BACKGROUND MESSAGE RECEIVED');
  debugPrint('════════════════════════════════════════════');

  debugPrint('📨 Message ID: ${message.messageId}');
  debugPrint('📦 Data: ${message.data}');
  debugPrint('🔔 Has notification: ${message.notification != null}');
  debugPrint('🔔 Title: ${message.notification?.title}');
  debugPrint('📝 Body: ${message.notification?.body}');
  debugPrint('🕐 Sent time: ${message.sentTime}');
  debugPrint('💾 From: ${message.from}');

  if (message.notification != null) {
    debugPrint('📱 Message type: NOTIFICATION');
  } else {
    debugPrint('📦 Message type: DATA-ONLY');
  }

  debugPrint('════════════════════════════════════════════');
  debugPrint('');
}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static String? _cachedToken;

  static AppLifecycleState? _appLifecycleState;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _localNotificationInitialized = false;

  // ============================================================
  // Lifecycle tracking
  // ============================================================

  static void updateAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;

    debugPrint('📱 [APP] Lifecycle changed → ${state.name}');
  }

  static String get _currentAppState {
    final state = _appLifecycleState;

    if (state == null) {
      return 'UNKNOWN';
    }

    switch (state) {
      case AppLifecycleState.resumed:
        return 'FOREGROUND / RESUMED';

      case AppLifecycleState.inactive:
        return 'INACTIVE';

      case AppLifecycleState.paused:
        return 'BACKGROUND / PAUSED';

      case AppLifecycleState.detached:
        return 'DETACHED';

      case AppLifecycleState.hidden:
        return 'HIDDEN';
    }
  }

  // ============================================================
  // Initialization
  // ============================================================

  static Future<void> init() async {
    debugPrint('');
    debugPrint('════════════════════════════════════════════');
    debugPrint('🔥 [FCM] INITIALIZATION STARTED');
    debugPrint('════════════════════════════════════════════');

    try {
      // ----------------------------------------------------------
      // Permission
      // ----------------------------------------------------------

      final permission = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('🔐 [FCM] Permission: ${permission.authorizationStatus}');

      await _initializeLocalNotifications();
      await _createAndroidNotificationChannel();

      // ----------------------------------------------------------
      // Foreground notification presentation
      // ----------------------------------------------------------

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('🔔 [FCM] Foreground notification presentation enabled');

      // ----------------------------------------------------------
      // Background handler
      // ----------------------------------------------------------

      FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

      debugPrint('🌙 [FCM] Background message handler registered');

      // ----------------------------------------------------------
      // FOREGROUND MESSAGE
      // ----------------------------------------------------------

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          debugPrint('');
          debugPrint('════════════════════════════════════════════');
          debugPrint('🔥 [FCM] FOREGROUND MESSAGE RECEIVED');
          debugPrint('════════════════════════════════════════════');

          _logMessage(message, source: 'onMessage');

          debugPrint('📱 App state: $_currentAppState');

          debugPrint('════════════════════════════════════════════');
          debugPrint('');

          final notification = message.notification;

          if (notification == null) {
            debugPrint(
              '⚠️ [FCM] Foreground message has no notification payload',
            );

            return;
          }

          // _showCustomNotification(message);
          _showLocalNotification(message); // real OS notification
        },
        onError: (error) {
          debugPrint('❌ [FCM] onMessage error: $error');
        },
      );

      // ----------------------------------------------------------
      // USER TAPPED NOTIFICATION FROM BACKGROUND
      // ----------------------------------------------------------

      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          debugPrint('');
          debugPrint('════════════════════════════════════════════');
          debugPrint('🚀 [FCM] NOTIFICATION OPENED FROM BACKGROUND');
          debugPrint('════════════════════════════════════════════');

          _logMessage(message, source: 'onMessageOpenedApp');

          debugPrint('📱 App state: $_currentAppState');

          debugPrint('════════════════════════════════════════════');
          debugPrint('');

          _handleNavigation(message);
        },
        onError: (error) {
          debugPrint('❌ [FCM] onMessageOpenedApp error: $error');
        },
      );

      // ----------------------------------------------------------
      // APP OPENED FROM TERMINATED STATE
      // ----------------------------------------------------------

      final initialMessage = await _messaging.getInitialMessage();

      if (initialMessage != null) {
        debugPrint('');
        debugPrint('════════════════════════════════════════════');
        debugPrint('🚀 [FCM] APP OPENED FROM TERMINATED STATE');
        debugPrint('════════════════════════════════════════════');

        _logMessage(initialMessage, source: 'getInitialMessage');

        debugPrint('════════════════════════════════════════════');
        debugPrint('');

        Future.delayed(const Duration(seconds: 1), () {
          _handleNavigation(initialMessage);
        });
      } else {
        debugPrint('ℹ️ [FCM] No initial notification message');
      }

      // ----------------------------------------------------------
      // Token
      // ----------------------------------------------------------

      _cachedToken = await getToken();

      if (_cachedToken != null) {
        debugPrint('✅ [FCM] Device token cached');

        if (AppStorage.token.isNotEmpty) {
          debugPrint('🔐 [FCM] User authenticated → syncing token');

          await sendTokenToServer(_cachedToken!);
        } else {
          debugPrint('ℹ️ [FCM] No authenticated session → token kept cached');
        }
      } else {
        debugPrint('❌ [FCM] Device token is NULL');
      }

      // ----------------------------------------------------------
      // Token refresh
      // ----------------------------------------------------------

      _messaging.onTokenRefresh.listen(
        (token) {
          debugPrint('');
          debugPrint('🔄 [FCM] TOKEN REFRESHED');
          debugPrint('🔑 Token: $token');
          debugPrint('');

          _cachedToken = token;

          if (AppStorage.token.isNotEmpty) {
            debugPrint('🔐 [FCM] Authenticated → sending refreshed token');

            sendTokenToServer(token);
          } else {
            debugPrint('ℹ️ [FCM] Not authenticated → token cached only');
          }
        },
        onError: (error) {
          debugPrint('❌ [FCM] Token refresh error: $error');
        },
      );

      debugPrint('');
      debugPrint('════════════════════════════════════════════');
      debugPrint('✅ [FCM] INITIALIZATION COMPLETED');
      debugPrint('════════════════════════════════════════════');
      debugPrint('');
    } catch (e, stack) {
      debugPrint('');
      debugPrint('❌ [FCM] INITIALIZATION FAILED');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      debugPrint('');
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('👆 [LOCAL NOTIFICATION] Tapped: ${response.payload}');

        // TODO: navigate based on payload
      },
    );

    // ==========================================================
    // Android 13+ notification permission
    // ==========================================================

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final granted = await androidPlugin?.requestNotificationsPermission();

    debugPrint('🔐 [LOCAL NOTIFICATION] Permission granted: $granted');

    _localNotificationInitialized = true;

    debugPrint('✅ [LOCAL NOTIFICATION] Plugin initialized');
  }

  static Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'High priority push notifications',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    debugPrint('✅ [FCM] Android notification channel created');
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) {
      debugPrint('⚠️ [FCM] No notification payload');
      return;
    }

    if (!_localNotificationInitialized) {
      debugPrint('⚠️ [FCM] Local notification plugin not initialized');
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'High priority push notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.messageId?.hashCode.abs() ?? DateTime.now().millisecond,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );

    debugPrint('✅ [FCM] REAL SYSTEM NOTIFICATION SHOWN');
  }
  // ============================================================
  // Message Logger
  // ============================================================

  static void _logMessage(RemoteMessage message, {required String source}) {
    debugPrint('📍 Source: $source');
    debugPrint('🆔 Message ID: ${message.messageId}');
    debugPrint('📦 Data: ${message.data}');
    debugPrint('🔔 Notification: ${message.notification != null}');
    debugPrint('🔔 Title: ${message.notification?.title}');
    debugPrint('📝 Body: ${message.notification?.body}');
    debugPrint('🕐 Sent time: ${message.sentTime}');
    debugPrint('📤 From: ${message.from}');

    final type = message.data['type'];
    final id = message.data['id'];

    debugPrint('🏷️ Type: $type');
    debugPrint('🆔 Data ID: $id');

    if (message.notification != null) {
      debugPrint('📱 Payload: notification + data');
    } else {
      debugPrint('📦 Payload: data-only');
    }
  }

  // ============================================================
  // Login Sync
  // ============================================================

  static Future<void> syncTokenAfterLogin() async {
    debugPrint('🔐 [FCM] Syncing token after login...');

    final token = _cachedToken ?? await getToken();

    if (token == null) {
      debugPrint('❌ [FCM] No token available after login');

      return;
    }

    debugPrint('📤 [FCM] Sending cached token after login');

    await sendTokenToServer(token);
  }

  // ============================================================
  // Get Token
  // ============================================================

  static Future<String?> getToken() async {
    try {
      debugPrint('🔥 [FCM] Fetching FCM token...');

      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        debugPrint('🍎 [FCM] Checking APNS token...');

        final apnsToken = await _messaging.getAPNSToken();

        if (apnsToken == null) {
          debugPrint('❌ [FCM] APNS token unavailable');

          return null;
        }

        debugPrint('✅ [FCM] APNS token available');
      }

      final token = await _messaging.getToken();

      debugPrint('🔑 [FCM] FCM token: $token');

      return token;
    } catch (e, stack) {
      debugPrint('❌ [FCM] getToken failed: $e');

      debugPrint(stack.toString());

      return null;
    }
  }

  // ============================================================
  // Send Token
  // ============================================================

  static Future<BasicSuccessModel> sendTokenToServer(String token) async {
    debugPrint('📤 [FCM] Sending token to backend...');

    try {
      final result = await ApiRequest().patch(
        body: {'token': token},
        fromJson: BasicSuccessModel.fromJson,
        endPoint: '/users/fcm-token',
        isLoading: false.obs,
        onSuccess: (result) {
          debugPrint('✅ [FCM] Token saved successfully');
        },
      );

      debugPrint('✅ [FCM] Backend token update completed');

      return result;
    } catch (e, stack) {
      debugPrint('❌ [FCM] Backend token update failed: $e');

      debugPrint(stack.toString());

      rethrow;
    }
  }

  // ============================================================
  // Navigation
  // ============================================================

  static void _handleNavigation(RemoteMessage message) {
    debugPrint('');
    debugPrint('🚀 [FCM] HANDLING NOTIFICATION NAVIGATION');

    final type = message.data['type'];
    final id = message.data['id'];

    debugPrint('🏷️ Type: $type');
    debugPrint('🆔 ID: $id');

    switch (type) {
      case 'appointment':
        debugPrint('➡️ [FCM] Opening appointment');

        if (Get.isRegistered<NavigationController>()) {
          NavigationController.to.selectedIndex.value = 2;
        }

        Get.toNamed(Routes.navigationScreen);

        break;

      case 'chat':
        debugPrint('➡️ [FCM] Opening chat');

        if (Get.isRegistered<NavigationController>()) {
          NavigationController.to.selectedIndex.value = 3;
        }

        Get.toNamed(Routes.navigationScreen);

        break;

      default:
        debugPrint('➡️ [FCM] Opening home');

        if (Get.isRegistered<NavigationController>()) {
          NavigationController.to.selectedIndex.value = 0;
        }

        Get.toNamed(Routes.navigationScreen);
    }
  }

  // ============================================================
  // Foreground Notification
  // ============================================================

  static void _showCustomNotification(RemoteMessage message) {
    debugPrint('🔔 [FCM] Showing foreground notification UI');

    final notification = message.notification;

    if (notification == null) {
      debugPrint('⚠️ [FCM] Cannot show notification: payload is null');

      return;
    }

    debugPrint('🔔 Title: ${notification.title}');

    debugPrint('📝 Body: ${notification.body}');

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.zero,
      borderRadius: 18.r,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 350),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,

      messageText: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: CustomColors.primary.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42.r,
              width: 42.r,
              decoration: BoxDecoration(
                color: CustomColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.notifications_rounded,
                color: CustomColors.primary,
                size: 24.r,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    notification.title ?? "Notification",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.blackColor,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.h),

                  TextWidget(
                    notification.body ?? '',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.grayShade,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.r,
              color: CustomColors.grayShade,
            ),
          ],
        ),
      ),

      onTap: (_) {
        debugPrint('👆 [FCM] Foreground notification tapped');

        Get.closeCurrentSnackbar();

        _handleNavigation(message);
      },
    );

    debugPrint('✅ [FCM] Foreground notification UI displayed');
  }

  // ============================================================
  // Test
  // ============================================================

  static void testForegroundNotification() {
    debugPrint('🧪 [FCM TEST] Triggering mock foreground notification');

    final mockMessage = RemoteMessage(
      messageId: "mock_message_001",
      data: {"type": "appointment", "id": "12345"},
      notification: const RemoteNotification(
        title: "New Chat Message",
        body: "You have received a new message from a patient",
      ),
    );

    _logMessage(mockMessage, source: 'TEST');

    _showCustomNotification(mockMessage);

    _showLocalNotification(mockMessage); // real OS notification
  }
}
