import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'language_service.dart';

class AppLifecycleService extends GetxService
    with WidgetsBindingObserver {

  Locale? _lastLocale;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    _lastLocale = Get.deviceLocale;
  }

  String _getBackendLanguageCode(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'en_US';
      case 'fr':
        return 'fr_FR';
      case 'es':
        return 'es_ES';
      default:
        return 'en_US'; // fallback
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final systemLocale = Get.deviceLocale;
      if (systemLocale == null) return;

      if (_lastLocale?.languageCode != systemLocale.languageCode) {
        _lastLocale = systemLocale;


        final backendCode = _getBackendLanguageCode(systemLocale);


        LanguageApiService.changeLanguage(backendCode);
      }
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
