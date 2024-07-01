import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';

extension StringExtension on String {
  String capitalize() {
    String _string = '';

    _string = "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

    return _string;
  }

  String obscure() {
    String _string = '';

    _string = replaceAll(RegExp(r'.'), '*');

    return _string;
  }
}

mixin MyComponents {
  final ScrollController mainScrollController = ScrollController();
  
  bool isLoading = false;
  bool launchLoading = true;

  late String domainName;
  late String appVersion;
  late String deviceID;

  Future<void> initParam() async {
    await MyPrefs.init().then((prefs) {
      prefs!;
      
      domainName = MyPrefs.getDomainName(prefs: prefs)!;
      appVersion = MyPrefs.getAppVersion(prefs: prefs) ?? 'N/A';
      deviceID = MyPrefs.getDeviceID(prefs: prefs) ?? 'N/A';
    });
  }
}