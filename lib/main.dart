import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glady/views/splash/controller/splash_controller.dart';

import 'core/api/services/push_notification_service.dart';
import 'core/helpers/network_manager.dart';
import 'core/utils/app_storage.dart';
import 'core/utils/basic_import.dart';
import 'core/widgets/offline_widget.dart';
import 'firebase_options.dart';
import 'initial.dart';
import 'views/splash/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();

  await Initial.init();
  Get.put(NetworkChecker());
  Get.put(SplashController());

  final hasInternet = await NetworkManager.hasConnection();
  bool? lastStatus = hasInternet;
  NetworkManager.connectionStream().listen((isConnected) {
    if (lastStatus != null && lastStatus != isConnected) {
      if (!isConnected) {
        Get.to(() => const OfflineWidget());
      } else {
        if (Get.key.currentState?.canPop() ?? false) {
          Get.back();
        } else {
          Get.offAllNamed(Routes.splashScreen);
        }
      }
    }
    lastStatus = isConnected;
  });
  runApp(
    DevicePreview(
      enabled: false, // set false in release
      builder: (context) => MyApp(hasInternet: hasInternet),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasInternet;

  const MyApp({super.key, required this.hasInternet});

  @override
  Widget build(BuildContext context) {
    String savedLang = AppStorage.languageCode;
    final themes = Themes();
    return ScreenUtilInit(
      designSize: const Size(411, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => GetMaterialApp(
        // translations: Languages(),
        // locale: Locale(savedLang, savedLang == 'en' ? 'US' : 'GK'),
        // fallbackLocale: Locale('en', 'US'),
        navigatorObservers: [GetObserver(), appRouteObserver],
        debugShowCheckedModeBanner: false,
        home: hasInternet ? const SplashScreen() : const OfflineWidget(),
        title: Strings.appName,
        theme: Themes.light,
        darkTheme: Themes.dark,
        getPages: Routes.list,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400),
        themeMode: themes.currentTheme,
        // themeMode: ThemeMode.light,
        builder: (context, widget) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (ctx) {
                  return Directionality(
                    textDirection: Get.locale?.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: widget ?? const SizedBox.shrink(), // ✅ null-safe
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
