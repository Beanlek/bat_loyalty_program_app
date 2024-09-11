import 'dart:convert';

import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';

class Api {
  static Future<bool> checkToken() async {
    String? token;
    String? tokenExpiryTime;

    bool hadToken = false;
    DateTime tokenExpiryTimeParsed;

    await MyPrefs.init().then((prefs) async {
      prefs!;

      token = MyPrefs.getToken(prefs: prefs);
      tokenExpiryTime = MyPrefs.getTokenExpiryTime(prefs: prefs);

      if (token != null && tokenExpiryTime != null) {
        tokenExpiryTimeParsed = DateTime.parse(tokenExpiryTime!)
            .add(Duration(hours: int.parse('-4')));

        if (DateTime.now().isBefore(tokenExpiryTimeParsed)) {
          hadToken = true;
        }
      }
    });

    return hadToken;
  }

  static Future<void> setAllDomain() async {
    Map<String, dynamic> allDomainMap = {};

    await MyPrefs.init().then((prefs) async {
      prefs!;
      await dotenv.load(fileName: ".env");
      final DOMAIN_LOCAL = dotenv.env['DOMAIN_LOCAL']!;
      final DOMAIN_MASTER = dotenv.env['DOMAIN_MASTER']!;
      final DOMAIN_DEV = dotenv.env['DOMAIN_DEV']!;

      allDomainMap.putIfAbsent('local', () => DOMAIN_LOCAL);
      allDomainMap.putIfAbsent('master', () => DOMAIN_MASTER);
      allDomainMap.putIfAbsent('dev', () => DOMAIN_DEV);

      MyPrefs.setAllDomain(jsonEncode(allDomainMap), prefs: prefs);
    });
  }

  static Future<void> logout() async {
    await MyPrefs.init().then((prefs) async {
      prefs!;

      prefs.remove('token');
    });
  }

  static Future<int> login(String domainName,
      {required String mobile,
      required String password,
      required String deviceID}) async {
    int statusCode = 0;

    final Dio dio = Dio();

    String url = '${domainName}/api/auth/app/login';

    try {
      final response = await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        url,
        data: {"mobile": mobile, "password": password, "device_id": deviceID},
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
      if (e.response != null) {
        statusCode = e.response!.statusCode ?? 503;
      } else {
        statusCode = 503;
      }

      String errMsg = 'Unknown error. $e';

      if (e.response != null) {
        errMsg = e.response!.data['errMsg'];
      }
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
      final user = response.data['data']['user'];
        // final user = response.data['user'];      
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
      {required Map<String, dynamic> registrationData}) async {
    int statusCode = 0;

    registrationData.forEach((key, data) {
      if (data.isEmpty || data == '') {
        statusCode = 400;
        FloatingSnackBar(
            message: 'Error ${statusCode}. ${key.capitalize()} is empty.',
            context: context);
      }
    });
    if (statusCode == 400) {
      return statusCode;
    }

    final Dio dio = Dio();
    String url = '${domainName}/api/user/app/register';

    try {
      final response = await dio.post(
          options: Options(headers: {
            'Content-Type': 'application/json',
          }),
          url,
          data: {"data": registrationData});

      statusCode = response.statusCode!;
    } on DioException catch (e) {
      statusCode = e.response!.statusCode ?? 503;
      String errMsg = 'Unknown error.';

      if (e.response != null) {
        errMsg = e.response!.data['errMsg'];
      }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  // make api to get all products
  static Future<List<Product>> fetchProducts(
      String domainName, String token) async {
    String url = '${domainName}/api/product/app/list';   
   // print('url : $url');
    final Dio dio = Dio();
    int statusCode = 0;    
    try {
      final response = await dio.get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        
      );

      statusCode = response.statusCode!;
     // print('statusCode fetch product : ${statusCode}');
      if (statusCode == 200) {

        //  print('response.data type: ${response.data.runtimeType}');
        // print('response.data: ${response.data}');

        // Cast the response data to List<Map<String, dynamic>>
        if (response.data is List) {
          List<Product> products = (response.data as List)
              .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
              .toList();
          return products;
        } else {
          throw Exception('Unexpected data format');
        }              

      } else {
        print(statusCode);
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Errorrr: $e');
      throw Exception('Failed to load the products');
    }
  }
}
