import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../../widgets/custom_button.dart';
import '../../../res/colors/color.dart';

class SimpleWebViewPage extends StatefulWidget {
  final String url;
  final String buttonTitle;

  const SimpleWebViewPage({super.key, required this.url, required this.buttonTitle});

  @override
  State<SimpleWebViewPage> createState() => _SimpleWebViewPageState();
}

class _SimpleWebViewPageState extends State<SimpleWebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool _hasHandledSuccess = false; // Flag to prevent multiple handling
  bool _showWebView = true; // Control WebView visibility

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true);
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
            print('Page started loading: $url'); // Debug URL
            _handleSuccessFallback(url); // Fallback handling
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
            print('Page finished loading: $url'); // Debug URL
            _handleSuccessFallback(url); // Fallback handling
          },
          onNavigationRequest: (request) {
            print('Navigation request: ${request.url}'); // Debug URL
            // Check for success URLs (including example.com)
            if (!_hasHandledSuccess &&
                (request.url.contains('example.com') ||
                    request.url.contains('/success') ||
                    request.url.contains('payment/success') ||
                    (request.url.contains('checkout.stripe.com') && request.url.contains('success')))) {
              print('Success URL detected! Handling...'); // Confirm block entry
              _handleSuccess();
              return NavigationDecision.prevent; // Prevent loading the success page
            }
            // Handle cancel or failure URLs (optional)
            if (!_hasHandledSuccess &&
                (request.url.contains('/cancel') || request.url.contains('payment/cancel'))) {
              print('Failure URL detected!'); // Debug
              _handleFailure();
              return NavigationDecision.prevent;
            }
            // Block navigation to unwanted domains (e.g., YouTube)
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    // Timeout fallback: Close after 30 seconds if stuck
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted && !_hasHandledSuccess) {
        print('Timeout: Force closing WebView');
        _handleTimeout();
      }
    });
  }

  // Handle success with delay and post-frame callback
  void _handleSuccess() {
    if (_hasHandledSuccess) return;
    _hasHandledSuccess = true;
    print('Showing success snackbar and navigating back...');

    // Load blank page and hide WebView
    _controller.loadRequest(Uri.parse('about:blank')); // Interrupt current page
    setState(() => _showWebView = false); // Hide WebView

    // Show snackbar
    Get.snackbar(
      'Success',
      'Payment Successful!',
      backgroundColor: AppColor.vividAmber,
      colorText: AppColor.black,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
    );

    // Delay navigation to ensure snackbar is visible
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop(); // Use Navigator.pop as fallback
          print('Navigated back successfully');
        });
      }
    });
  }

  // Fallback: Handle success in onPageStarted/onPageFinished
  void _handleSuccessFallback(String url) {
    if (_hasHandledSuccess) return;
    if (url.contains('example.com') ||
        url.contains('/success') ||
        url.contains('payment/success') ||
        (url.contains('checkout.stripe.com') && url.contains('success'))) {
      print('Fallback success detected in page load: $url');
      _controller.loadRequest(Uri.parse('about:blank')); // Interrupt current page
      _handleSuccess();
    }
  }

  // Handle failure
  void _handleFailure() {
    if (_hasHandledSuccess) return;
    _hasHandledSuccess = true;
    _controller.loadRequest(Uri.parse('about:blank')); // Interrupt current page
    setState(() => _showWebView = false); // Hide WebView
    Get.snackbar(
      'Error',
      'Payment Cancelled or Failed',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  // Handle timeout
  void _handleTimeout() {
    if (_hasHandledSuccess) return;
    _hasHandledSuccess = true;
    _controller.loadRequest(Uri.parse('about:blank')); // Interrupt current page
    setState(() => _showWebView = false); // Hide WebView
    Get.snackbar(
      'Timeout',
      'Payment process timed out',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    print('Disposing WebViewController');
    _controller.clearCache();
    _controller.clearLocalStorage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        leading: BackButton(color: AppColor.white),
        title: Text(
          widget.buttonTitle,
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      ),
      body: Stack(
        children: [
          if (_showWebView) // Conditionally show WebView
            WebViewWidget(controller: _controller),
          if (isLoading && _showWebView)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}