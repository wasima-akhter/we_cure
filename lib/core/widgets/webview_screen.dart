import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/views/profile/controller/profile_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/basic_import.dart';
import 'confirmation_widget.dart';
import 'loading_widget.dart';

// class WebPaymentScreen extends StatefulWidget {
//   const WebPaymentScreen({super.key});
//
//   @override
//   State<WebPaymentScreen> createState() => _WebPaymentScreenState();
// }
//
// class _WebPaymentScreenState extends State<WebPaymentScreen> {
//   final controller = Get.find<PaymentController>();
//   late final WebViewController _webViewController;
//   bool isLoading = true;
//   bool _successHandled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }
//
//   void _initializeWebView() {
//     final paymentUrl = controller.paymentUrl;
//
//     if (paymentUrl.isEmpty) {
//       _handleFailure("Payment URL not found");
//       return;
//     }
//
//     debugPrint("🔗 Loading Payment URL: $paymentUrl");
//
//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..addJavaScriptChannel(
//         'PaystackCallback',
//         onMessageReceived: (JavaScriptMessage message) {
//           debugPrint("📩 Paystack JS Message: ${message.message}");
//           if (message.message.contains('charge.success') ||
//               message.message.contains('success')) {
//             _handleSuccess();
//           }
//         },
//       )
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             setState(() => isLoading = true);
//           },
//           onPageFinished: (String url) {
//             setState(() => isLoading = false);
//             debugPrint("✅ Current URL: $url");
//
//             // ✅ Paystack event inject
//             _webViewController.runJavaScript('''
//               window.addEventListener('message', function(event) {
//                 if (event.data && typeof event.data === 'object') {
//                   PaystackCallback.postMessage(JSON.stringify(event.data));
//                 } else if (typeof event.data === 'string') {
//                   PaystackCallback.postMessage(event.data);
//                 }
//               });
//             ''');
//
//             final uri = Uri.parse(url);
//
//             // ✅ Paystack success
//             final trxref = uri.queryParameters['trxref'];
//             final reference = uri.queryParameters['reference'];
//             if ((trxref != null || reference != null) &&
//                 (url.contains('callback') || url.contains('verify'))) {
//               _handleSuccess();
//               return;
//             }
//
//             // ✅ Stripe success
//             final redirectStatus = uri.queryParameters['redirect_status'];
//             final paymentIntent = uri.queryParameters['payment_intent'];
//             if (paymentIntent != null && redirectStatus == 'succeeded') {
//               _handleSuccess();
//               return;
//             }
//
//             // ✅ Stripe failed
//             if (paymentIntent != null && redirectStatus == 'failed') {
//               _handleFailure("Payment failed");
//               return;
//             }
//
//             // ✅ Cancel
//             if (url.contains('cancel') || url.contains('close')) {
//               _handleFailure("Payment was cancelled");
//               return;
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint("❌ WebView Error: ${error.description}");
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(paymentUrl));
//
//     setState(() => isLoading = false);
//   }
//
//   void _handleSuccess() {
//     if (!mounted || _successHandled) return;
//     _successHandled = true;
//     controller.paymentUrl = '';
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.offAll(
//             () => ConfirmationWidget(
//           iconPath: Assets.icons.vector,
//           title: "Payment Successful",
//           subtitle:
//           'About this payment information has been sent to your email.\nWaiting for doctor confirmation.',
//         ),
//       );
//     });
//   }
//
//   void _handleFailure(String message) {
//     if (!mounted) return;
//     controller.paymentUrl = '';
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.back();
//       CustomSnackBar.error(message);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(
//         title: 'Payment',
//         isBack: true,
//       ),
//       body: isLoading
//           ? const LoadingWidget()
//           : WebViewWidget(controller: _webViewController),
//     );
//   }
// }

class WebPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const WebPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<WebPaymentScreen> createState() => _WebPaymentScreenState();
}

class _WebPaymentScreenState extends State<WebPaymentScreen> {
  late final WebViewController _webViewController;
  bool isLoading = true;
  bool _successHandled = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    if (widget.paymentUrl.isEmpty) {
      _handleFailure("Payment URL not found");
      return;
    }

    debugPrint("🔗 Loading Payment URL: ${widget.paymentUrl}");

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'PaystackCallback',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint("📩 Paystack JS Message: ${message.message}");
          if (message.message.contains('charge.success') ||
              message.message.contains('success')) {
            _handleSuccess();
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
            debugPrint("✅ Current URL: $url");

            _webViewController.runJavaScript('''
              window.addEventListener('message', function(event) {
                if (event.data && typeof event.data === 'object') {
                  PaystackCallback.postMessage(JSON.stringify(event.data));
                } else if (typeof event.data === 'string') {
                  PaystackCallback.postMessage(event.data);
                }
              });
            ''');

            final uri = Uri.parse(url);

            final trxref = uri.queryParameters['trxref'];
            final reference = uri.queryParameters['reference'];
            if ((trxref != null || reference != null) &&
                (url.contains('callback') || url.contains('verify'))) {
              _handleSuccess();
              return;
            }

            final redirectStatus = uri.queryParameters['redirect_status'];
            final paymentIntent = uri.queryParameters['payment_intent'];
            if (paymentIntent != null && redirectStatus == 'succeeded') {
              _handleSuccess();
              return;
            }

            if (paymentIntent != null && redirectStatus == 'failed') {
              _handleFailure("Payment failed");
              return;
            }

            if (url.contains('cancel') || url.contains('close')) {
              _handleFailure("Payment was cancelled");
              return;
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("❌ WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    setState(() => isLoading = false);
  }

  void _handleSuccess() {
    if (!mounted || _successHandled) return;
    _successHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<ProfileController>() &&
          AppStorage.isUser == "USER") {
        ProfileController.to.getUserProfile();
      }
      Get.offAll(
        () => ConfirmationWidget(
          iconPath: Assets.icons.vector,
          title: "Payment Successful",
          subtitle:
              'About this payment information has been sent to your email.\nWaiting for doctor confirmation.',
        ),
      );
    });
  }

  void _handleFailure(String message) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.back();
      CustomSnackBar.error(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Payment', isBack: true),
      body: isLoading
          ? const LoadingWidget()
          : WebViewWidget(controller: _webViewController),
    );
  }
}
