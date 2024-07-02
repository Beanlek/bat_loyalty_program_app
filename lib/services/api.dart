
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';

class Api {
  static Future<bool> checkToken() async {
    String? token;
    String? tokenExpiryTime;
    
    bool hadToken = false;
    DateTime tokenExpiryTimeParsed;

    await MyPrefs.init().then((prefs) {
      prefs!;

      token = MyPrefs.getToken(prefs: prefs);
      tokenExpiryTime = MyPrefs.getTokenExpiryTime(prefs: prefs);

      if (token != null && tokenExpiryTime != null) {
        tokenExpiryTimeParsed = DateTime.parse(tokenExpiryTime!).add(Duration(hours: int.parse('-4')));

        if (DateTime.now().isBefore(tokenExpiryTimeParsed)) {
          hadToken = true;
        }
      }
    });

    return hadToken;
  }

  static Future<int> login(String domainName, 
    {required String mobile, required String password, required String deviceID}
  ) async {
    int statusCode = 0;

    final Dio dio = Dio();

    String url = '${domainName}/api/auth/app/login';

    try {
      final response = await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),

        url,
        data: {
          "mobile": mobile,
          "password": password,
          "device_id": deviceID
        },
      );

      statusCode = response.statusCode!;
      print('statusCode : ${statusCode}');

      if (statusCode == 200) {
        final token = response.data['token'];
        final tokenExpiryTime = response.data['token_expiry_time'];

        await MyPrefs.init().then((prefs) {
          prefs!;
          
          MyPrefs.setToken(token, prefs: prefs);
          MyPrefs.setTokenExpiryTime(tokenExpiryTime, prefs: prefs);
        });
      }
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  static Future<int> user_self(String domainName, String token) async {
    int statusCode = 0;

    final Dio dio = Dio();

    String url = '${domainName}/api/user/app/self';

    try {
      final response = await dio.get(
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),

        url,
      );

      statusCode = response.statusCode!;

      if (statusCode == 200) {
        final user = response.data['user'];

        await MyPrefs.init().then((prefs) {
          prefs!;
          
          MyPrefs.setUser(jsonEncode(user), prefs: prefs);
        });
      }
    } catch (e) {
      print('user_self error : $e');
      statusCode = 503;
    }

    return statusCode;
  }



}