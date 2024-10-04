import 'package:bat_loyalty_program_app/l10n/l10n.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  bool isRefresing = false;
  bool launchLoading = true;
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

 
  late Future<bool> isRefresh;
  
  late Locale currentLocale = L10n.locals[0]; // Initialize with the first locale
  bool isnitialized = false;

  
  late Future<AppLocalizations?> futureLocale;



  Future<AppLocalizations?> getFutureLocale(BuildContext context) async {
    final _futureLocale = AppLocalizations.of(context);    
    return _futureLocale; 
  }

  Future<Object?> myPushNamed(BuildContext context, void Function(void Function() fn) setState, String routeName, {
      Object? arguments,
  }) async {
    bool _res = false;
    
    await Navigator.pushNamed( context, routeName , arguments: arguments).then((res) async {
      _res = res as bool;

      if (res == true) { print('pushNamed res == true');
        await setIsRefreshTrue().whenComplete(() => setState((){isRefresh = getIsRefresh();}) );

        return res;
      } else {return res;}
    }); print("exit await myPushNamed"); return _res;
  }

  Future<bool> getIsRefresh() async {
    bool _isRefresh = false;
    
    await MyPrefs.init().then((prefs) {
      prefs!;
      
      _isRefresh = MyPrefs.getIsRefresh(prefs: prefs) ?? false;
    });
    
    return _isRefresh; 
  }

  Future<void> setIsRefreshTrue() async {
    await MyPrefs.init().then((prefs) {
      prefs!;
      
      MyPrefs.setIsRefresh(prefs: prefs, true);
    });
  }

  Future<bool> popDialog() async {return true;}

  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    isRefresh = getIsRefresh(); print('run :: isRefresh = getIsRefresh();');
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

  Future<void> refreshPage(BuildContext context, void Function(void Function() fn) setState) async {
    await Future.delayed(const Duration(seconds: 1));
    await initParam(context).whenComplete(() async {
      await MyPrefs.init().then((prefs) {
        prefs!;
        
        MyPrefs.setIsRefresh(prefs: prefs, false);
        setState(() {isRefresh = getIsRefresh();}); print('run :: isRefresh = getIsRefresh();');
      });
    });
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