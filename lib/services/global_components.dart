import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';

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