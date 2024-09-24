<<<<<<< Updated upstream
=======
import 'package:bat_loyalty_program_app/l10n/l10n.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:intl/intl.dart';

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

  DateFormat? monthYear;

  String currentPath = '';
  List<String> paths = [];

  late String domainName;
  late String appVersion;
  late String deviceID;
  late String token;

<<<<<<< Updated upstream

=======
 
  late Future<bool> isRefresh;
  
  late Locale currentLocale = L10n.locals[0]; // Initialize with the first locale
  bool isnitialized = false;

  
  late Future<AppLocalizations?> futureLocale;



  Future<AppLocalizations?> getFutureLocale(BuildContext context) async {
    final _futureLocale = AppLocalizations.of(context);    
    return _futureLocale; 
  }
>>>>>>> Stashed changes

  Future<void> initParam() async {
    await MyPrefs.init().then((prefs) {
      prefs!;

      domainName = MyPrefs.getDomainName(prefs: prefs)!;
      appVersion = MyPrefs.getAppVersion(prefs: prefs) ?? 'N/A';
      deviceID = MyPrefs.getDeviceID(prefs: prefs) ?? 'N/A';
      token = MyPrefs.getToken(prefs: prefs) ?? 'N/A';
      monthYear = DateFormat('MMMM yyyy');
    });
  }

  void setPath({key, required String prevPath, required String routeName}) {
    currentPath = '';
    paths.clear();

    currentPath = prevPath + routeName;

    final splitted = currentPath.split('/');
    for (var path in splitted) {
      if (path != '') paths.add(path.capitalize());
    }

    print('${routeName} : ${paths}');
  }
}
