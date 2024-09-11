import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPrefs {
  // init
  static Future<SharedPreferences?> init() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  // token
  static void setToken(String token, {required SharedPreferences prefs}) {
    prefs.setString('token', token);
  }
  static String? getToken({required SharedPreferences prefs}) {
    return prefs.getString('token');
  }

  static void setTokenExpiryTime(String tokenExpiryTime, {required SharedPreferences prefs}) {
    prefs.setString('tokenExpiryTime', tokenExpiryTime);
  }
  static String? getTokenExpiryTime({required SharedPreferences prefs}) {
    return prefs.getString('tokenExpiryTime');
  }

  // device and app information
  static void setAppVersion({required SharedPreferences prefs}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    prefs.setString('appVersion', packageInfo.version);
  }
  static String? getAppVersion({required SharedPreferences prefs}) {
    return prefs.getString('appVersion');
  }

  static void setDeviceID({required SharedPreferences prefs}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    prefs.setString('deviceID', androidInfo.id.toString());
  }
  static String? getDeviceID({required SharedPreferences prefs}) {
    return prefs.getString('deviceID');
  }

  // domain name
  static void setDomainName(String domainName, {required SharedPreferences prefs}) {
    prefs.setString('domainName', domainName);
  }
  static String? getDomainName({required SharedPreferences prefs}) {
    return prefs.getString('domainName');
  }

  static void setAllDomain(String allDomain, {required SharedPreferences prefs}) {
    prefs.setString('allDomain', allDomain);
  }
  static String? getAllDomain({required SharedPreferences prefs}) {
    return prefs.getString('allDomain');
  }

  // user information
  static void setUser(String user, {required SharedPreferences prefs}) {
    prefs.setString('user', user);
  }
  static String? getUser({required SharedPreferences prefs}) {
    return prefs.getString('user');
  }

  static void setOutlets(String outlets, {required SharedPreferences prefs}) {
    prefs.setString('outlets', outlets);
  }
  static String? getOutlets({required SharedPreferences prefs}) {
    return prefs.getString('outlets');
  }

  // refresh data
  static void setIsRefresh(bool isRefresh, {required SharedPreferences prefs}) {
    prefs.setBool('isRefresh', isRefresh);
  }
  static bool? getIsRefresh({required SharedPreferences prefs}) {
    return prefs.getBool('isRefresh');
  }

}