
import 'dart:convert';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:dio/dio.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

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
    } on DioException catch (e) {
      statusCode = e.response!.statusCode ?? 503;
      String errMsg = 'Unknown error.';

      if (e.response != null) { errMsg = e.response!.data['errMsg']; }
      print(errMsg);
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

  static Future<int> user_register(BuildContext context, String domainName, 
    { required Map<String, dynamic> registrationData }
  ) async {
    int statusCode = 0;

    registrationData.forEach((key, data) {
      if (data.isEmpty || data == '') { statusCode = 400; FloatingSnackBar(message: 'Error ${statusCode}. ${key.capitalize()} is empty.', context: context); }
    }); if ( statusCode == 400 ) { return statusCode; }

    final Dio dio = Dio();

    String url = '${domainName}/api/user/app/register';

    try {
      final response = await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),

        url,
        data: { "data": registrationData }
      );

      statusCode = response.statusCode!;

    } on DioException catch (e) {
      statusCode = e.response!.statusCode ?? 503;
      String errMsg = 'Unknown error.';

      if (e.response != null) { errMsg = e.response!.data['errMsg']; }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }
}