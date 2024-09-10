import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
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

  String clean() {
    String _string = '';

    _string = replaceAll(RegExp(r'_'), ' ');
    _string = _string.split(' ').map((word) => word.capitalize()).join(' ');

    return _string;
  }
}

mixin MyComponents {
  final ScrollController mainScrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  
  bool isLoading = false;
  bool launchLoading = true;
  bool refreshing = false;
  bool canPop = true;

  DateFormat? monthYear;
  DateFormat? monthYear2;

  String currentPath = '';
  List<String> paths = [];

  List<String> filtersApplied = [];

  late String domainName;
  late String appVersion;
  late String deviceID;
  late String token;

  Future<bool> popDialog() async {return true;}

  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    await MyPrefs.init().then((prefs) async {
      prefs!;
      
      domainName = MyPrefs.getDomainName(prefs: prefs)!;
      appVersion = MyPrefs.getAppVersion(prefs: prefs) ?? '';
      deviceID = MyPrefs.getDeviceID(prefs: prefs) ?? 'N/A';
      token = MyPrefs.getToken(prefs: prefs) ?? 'N/A';

      monthYear = DateFormat('MMMM yyyy');
      monthYear2 = DateFormat('MMM yyyy');

      if (needToken) {
        await Api.checkToken(domainName).then((res) {
          if (!res) {
            FloatingSnackBar(message: 'Session time out.', context: context);
            Navigator.pushNamed( context, LoginPage.routeName );
          }
        });
      }
    });
  }

  Future<void> refreshPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    await initParam(context);
  }

  void setPath({key, required String prevPath, required String routeName}) {
    currentPath = '';
    paths.clear();

    currentPath = prevPath + routeName;

    final splitted = currentPath.split('/');
    for (var path in splitted) { if (path != '' ) paths.add(path.capitalize()); }

    print('${routeName} : ${paths}');
  }

  void applyFilters(BuildContext context, { key, required String data }) {
    filtersApplied.contains(data) ? filtersApplied.removeWhere((item) => item == data) : filtersApplied.add(data);
  }
  void clearFilters() {
    filtersApplied.clear();
  }
  
}