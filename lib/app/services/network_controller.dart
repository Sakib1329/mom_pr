import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  bool _isFirstCheck = true;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // If it's a list, check if none are connected. In newer connectivity_plus, it returns a list.
    if (results.contains(ConnectivityResult.none)) {
        toastification.show(
          title: Text('no_internet'.tr),
          description: Text('check_connection'.tr),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 5),
        );
    } else {
      if (!_isFirstCheck) {
        toastification.show(
          title: Text('connected'.tr),
          description: Text('internet_restored'.tr),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
    _isFirstCheck = false;
  }
}
