import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:bat_loyalty_program_app/services/awss3.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class Api {
  static Future<bool> checkToken(String domainName, {key, bool main = false}) async {
    String? token;
    String? tokenExpiryTime;
    
    bool hadToken = false;
    DateTime tokenExpiryTimeParsed;

    await MyPrefs.init().then((prefs) async {
      prefs!;

      token = MyPrefs.getToken(prefs: prefs);
      tokenExpiryTime = MyPrefs.getTokenExpiryTime(prefs: prefs);

      if (token != null && tokenExpiryTime != null) {
        tokenExpiryTimeParsed = DateTime.parse(tokenExpiryTime!).add(Duration(hours: int.parse('-4')));

        if (DateTime.now().isBefore(tokenExpiryTimeParsed)) {
          hadToken = true;

          if (!main) {
          await user_self(domainName, token!).then((res) {
            print(res);
            if (res != 200) hadToken = false;
          }); }
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
      if (e.response != null) { statusCode = e.response!.statusCode ?? 503; }
      else { statusCode = 503; }
      
      String errMsg = 'Unknown error. $e';

      if (e.response != null) { errMsg = e.response!.data['errMsg']; }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  static Future<List<dynamic>> getReceipts(String domainName) async {
    // int statusCode = 0;
    // final Dio dio = Dio();
    List<dynamic> receipts = [];

    return receipts;
  }

  static Future<Map<String, dynamic>> account_list(String domainName) async {
    int statusCode = 0;
    Map<String, dynamic> result = {
      "status_code": statusCode,
      "result": []
    };
    final Dio dio = Dio();

    String url = '${domainName}/api/account/app/list';

    try {
      final response = await dio.get(
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),

        url,
      );

      statusCode = response.statusCode!;

      if (statusCode == 200) {
        result.update("result", (value) => response.data );
      }
    } on DioException catch (e) {
      String errMsg = 'Unknown error. $e';

      if (e.response != null) {
        statusCode = e.response!.statusCode ?? 503;
        
        errMsg = e.response!.data['errMsg']; 
        result.update("result", (value) => [{ "errMsg": errMsg }]);

      } else { statusCode = 503; }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
      result.update("result", (value) => [{ "errMsg": e }]);
    }

    result.update("status_code", (value) => statusCode);

    return result;
  }

  static Future<Map<String, dynamic>> outlet_list(String domainName, {key, required String account}) async {
    int statusCode = 0;
    Map<String, dynamic> result = {
      "status_code": statusCode,
      "result": []
    };
    final Dio dio = Dio();

    String url = '${domainName}/api/user/app/getOutletRegister';

    try {
      final response = await dio.get(
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {
          "id": account
        },

        url,
      );

      statusCode = response.statusCode!;

      if (statusCode == 200) {
        result.update("result", (value) => response.data);
      } else { result.update("result", (value) => [ response.data]); }
    } on DioException catch (e) {
      String errMsg = 'Unknown error. $e';

      if (e.response != null) {
        statusCode = e.response!.statusCode ?? 503;
        
        errMsg = e.response!.data['errMsg']; 
        result.update("result", (value) => [{ "errMsg": errMsg }]);

      } else { statusCode = 503; }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
      result.update("result", (value) => [{ "errMsg": e }]);
    }

    result.update("status_code", (value) => statusCode);

    return result;
  }

  static Future<int> registration_validate(String domainName, {key, required String mobile, required String id}) async {
    int statusCode = 0; print(domainName);

    final Dio dio = Dio();

    String url = '${domainName}/api/user/app/registerValidate';

    try {
      final response = await dio.get(
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {
          "name": id,
          "mobile": mobile,
        },

        url,
      );

      statusCode = response.statusCode!;

    } on DioException catch (e) {
      if (e.response != null) { statusCode = e.response!.statusCode ?? 503; }
      else { statusCode = 503; }
      
      String errMsg = 'Unknown error. $e';

      if (e.response != null) { errMsg = e.response!.data['errMsg']; }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  static Future<int> uploadImageReceipt(String domainName, String token, { required XFile receipt, required String userId, required String outletId }) async{
    int statusCode = 0;

    final Dio dio = Dio();

    String url = '${domainName}/api/user/app/registerValidate';

    try {
      await AwsS3.uploadImageReceipt(
        userId: userId,
        receipt: receipt
      ).then((res) async {
        if (res == true) {
          await AwsS3.getReceiptImageUrl(userId: userId, receipt: receipt).then((res) async {
            if (res['status'] == true) {
              try {
                final response = await dio.post(
                  options: Options(headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $token',
                  }),

                  url,
                  data: {
                    "user_id": userId,
                    "outlet_id": outletId,
                    "created_by": userId,
                    "image": res['result'].toString()
                  }
                );

                statusCode = response.statusCode!;

              } on DioException catch (e) {
                String errMsg = 'Unknown error. $e';

                if (e.response != null) {
                  statusCode = e.response!.statusCode ?? 503;
                  
                  errMsg = e.response!.data['errMsg']; 

                } else { statusCode = 503; }

                safePrint(errMsg);
              } catch (e) {
                print(e);
                statusCode = 503;
              }
            } else { safePrint(res['result']); statusCode = 503; }
          });
        } else { safePrint(res); statusCode = 503; }
      });
    } catch (e) {
      safePrint(e);
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
    } on DioException catch (e) {
      String errMsg = 'Unknown error. $e';

      if (e.response != null) {
        statusCode = e.response!.statusCode ?? 503;
        
        errMsg = e.response!.data; 

      } else { statusCode = 503; }
      print(errMsg);
    } catch (e) {
      print(e);
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