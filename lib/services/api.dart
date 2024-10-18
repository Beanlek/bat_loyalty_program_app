import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bat_loyalty_program_app/model/product.dart';

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
            final String cachedUser = MyPrefs.getUser(prefs: prefs)!;
            final Map<String, dynamic> mappedUser = jsonDecode(cachedUser);
            final String password = mappedUser['password'];
            
            await user_self(domainName, token!, password:password).then((res) {
              print(res);
              if (res != 200) hadToken = false;
            });
          }
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

      if (e.response != null) { errMsg = e.response!.data['errMsg'].toString(); }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  static Future<List<dynamic>> getReceipts(String domainName, String token) async {
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
        
        errMsg = e.response!.data['errMsg'].toString(); 
        result.update("result", (value) => [{ "errMsg": errMsg }]);

      } else { 
        statusCode = 503;
        result.update("result", (value) => [{ "errMsg": errMsg }]);
       }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
      result.update("result", (value) => [{ "errMsg": e }]);
    }

    result.update("status_code", (value) => statusCode);

    return result;
  }

   static Future<Map<String, dynamic>> user_validate(String domainName, {required String user_id}) async {
    int statusCode = 0;
    Map<String, dynamic> result = {
      "status_code": statusCode,
      "result": []
    };
    final Dio dio = Dio();

    String url = '${domainName}/api/user/app/userValidate';

    try {
      final response = await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),

        url,
        data: {
          "user_id": user_id,
        },
      );

      statusCode = response.statusCode!;

      if (statusCode == 200) {
        result.update("result", (value) => [response.data] );
      }
    } on DioException catch (e) {
      String errMsg = 'Unknown error. $e';

      if (e.response != null) {
        statusCode = e.response!.statusCode ?? 503;
        
        errMsg = e.response!.data['errMsg'].toString(); 
        result.update("result", (value) => [{ "errMsg": errMsg }]);

      } else { statusCode = 503; }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
      result.update("result", (value) => [{ "errMsg": e }]);
    }

    result.update("status_code", (value) => statusCode); print('result: $result');

    return result;
  }

  static Future<Map<String, dynamic>> outlet_list(String domainName, {key, required String account, required String postcode}) async {
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
          "id": account,
          "postcode": postcode
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
        
        errMsg = e.response!.data['errMsg'].toString(); 
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

      if (e.response != null) { errMsg = e.response!.data['errMsg'].toString(); }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  static Future<Map<String, dynamic>> uploadImageReceipt(String domainName, String token, { required XFile receipt, required String outletId }) async{
    print("OCR:: Api.uploadImageReceipt call start");
    int statusCode = 0;
    Map<String, dynamic> result = {
      "status_code": statusCode,
      "result": []
    };
    

    String url_string_uploadReceipt = '${domainName}/a/s3/uploadReceipt/${outletId}';
    final Uri url_uploadReceipt = Uri.parse(url_string_uploadReceipt);
    
    String url_getImage = '${domainName}/a/s3/getReceiptImageUrl';

    final Dio dio = Dio();

    File file = File(receipt.path);
    String fileName = file.path.split('/').last;

    try {
      print("OCR:: 1st post api call init");
      
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data"
      };
      var request = http.MultipartRequest('POST', url_uploadReceipt)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(
            'file', receipt.path,
            filename: fileName,
            contentType: MediaType('image', 'jpg')
          ));
      var response = await request.send();

      statusCode = response.statusCode;
      print('OCR:: StsCode uploadReceipt : $statusCode');


      if (statusCode == 201 || statusCode == 200) {
        var receiptImageId = 'null';

        await response.stream.bytesToString().then((res) async {
          var resMap = jsonDecode(res);
          receiptImageId = resMap["receiptImageId"];

          print("OCR:: 2nd get api call init");

          final response = await dio.get(
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            }),

            url_getImage,
            data: {
              "receiptImageId" : receiptImageId
            }
          );

          statusCode = response.statusCode!;
          print('OCR:: StsCode getImage : $statusCode');
          
          result.update("result", (value) => [ response.data, receiptImageId ]);

        });

      } else {
        await response.stream.bytesToString().then((res) {
          result.update("result", (value) => [ res ]);
          print('OCR:: response.stream : ${res}');
        });
      }

    } on DioException catch (e) {
      String errMsg = 'Unknown error. $e';
      print("OCR:: error $errMsg");

      if (e.response != null) {
        statusCode = e.response!.statusCode ?? 503;
        
        errMsg = e.response!.data['errMsg'].toString(); 
        result.update("result", (value) => [{ "errMsg": errMsg }]);

      } else { statusCode = 503; result.update("result", (value) => [{ "errMsg": errMsg }]);}

      print("OCR:: error $errMsg");
    } catch (e) {
      print("OCR:: $e");
      statusCode = 503;
      result.update("result", (value) => [{ "errMsg": e }]);
    }

    result.update("status_code", (value) => statusCode);

    return result;
  }

  static Future<int> user_account_update_active(BuildContext context, String domainName, String token, 
    { required Map<String, dynamic> updateActiveData }
  ) async {
    int statusCode = 0;

    updateActiveData.forEach((key, data) {
      if (data == null) { statusCode = 400; FloatingSnackBar(message: 'Error ${statusCode}. ${key.capitalize()} is empty.', context: context); }
    }); if ( statusCode == 400 ) { return statusCode; }

    final Dio dio = Dio();

    String url = '${domainName}/api/user_account/app/updateActive';

    try {
      final response = await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),

        url,
        data: { "data": updateActiveData }
      );

      statusCode = response.statusCode!;

    } on DioException catch (e) {
      statusCode = e.response!.statusCode ?? 503;
      String errMsg = 'Unknown error.';

      if (e.response != null) { errMsg = e.response!.data.toString(); }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  static Future<int> user_account_insert(BuildContext context, String domainName, String token, 
    { required String outletId }
  ) async {
    int statusCode = 0;
    
    if (outletId == '') { statusCode = 400; FloatingSnackBar(message: 'Error ${statusCode}. Outlet Id is empty.', context: context); }
    if ( statusCode == 400 ) { return statusCode; }

    final Dio dio = Dio();

    String url = '${domainName}/api/user_account/app/insert';

    try {
      final response = await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),

        url,
        data: { "data": { "outlet_id" : outletId } }
      );

      statusCode = response.statusCode!;

    } on DioException catch (e) {
      statusCode = e.response!.statusCode ?? 503;
      String errMsg = 'Unknown error.';

      if (e.response != null) { errMsg = e.response!.data.toString(); }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

  static Future<int> user_self(String domainName, String token, {required String password}) async {
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
        final Map<String, dynamic> user = response.data['data']['user'];
        final Map<String, dynamic> outlets = response.data['data']['outlets'];

        user['password'] = password;

        await MyPrefs.init().then((prefs) {
          prefs!;
          
          MyPrefs.setUser(jsonEncode(user), prefs: prefs);
          MyPrefs.setOutlets(jsonEncode(outlets), prefs: prefs);
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

  static Future<int> user_update_self(BuildContext context, String domainName, String token, 
    { required Map<String, dynamic> updateSelfData }
  ) async {
    int statusCode = 0;

    updateSelfData.forEach((key, data) {
      if (data.isEmpty || data == '') { statusCode = 400; FloatingSnackBar(message: 'Error ${statusCode}. ${key.capitalize()} is empty.', context: context); }
    }); if ( statusCode == 400 ) { return statusCode; }

    final Dio dio = Dio();

    String url = '${domainName}/api/user/app/updateSelf';

    try {
      final response = await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),

        url,
        data: { "data": updateSelfData }
      );

      statusCode = response.statusCode!;

    } on DioException catch (e) {
      statusCode = e.response!.statusCode ?? 503;
      String errMsg = 'Unknown error.';

      if (e.response != null) { errMsg = e.response!.data.toString(); }
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

      if (e.response != null) { errMsg = e.response!.data['errMsg'].toString(); }
      print(errMsg);
    } catch (e) {
      print(e);
      statusCode = 503;
    }

    return statusCode;
  }

 static Future<List<Product>> fetchProducts(String domainName, String token) async {
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
    print('statusCode fetch product : ${statusCode}');
      if (statusCode == 200) {

        //print('response.data type: ${response.data.runtimeType}');
        //print('response.data: ${response.data}');

        // Cast the response data to List<Map<String, dynamic>>
        if (response.data is List) {
          List<Product> products = (response.data as List).map((productJson) => Product.fromJson(productJson as Map<String, dynamic>)).toList();
          return products;
        } else {
          throw Exception('Unexpected data format');
        }              

      } else {
        print(statusCode);
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Errorr: $e');
      throw Exception('Failed to load the products');
    }
  }

  static Future<Product> fetchProductsByID(String domainName, String token, String productId) async {
    String url = '${domainName}/api/product/app/get/$productId';   
    print('url: $url');
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
      if (statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;

          // Parse the product data
          Product product = Product.fromJson(data);
          print('Product: $product');
          return product;
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        print(statusCode);
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load the product');
    }
  }

static Future<int> deleteProduct(String domainName, String token, String productId) async {
  int statusCode = 0;
  final Dio dio = Dio();
  String url = '${domainName}/api/product/app/delete/$productId';
  try {
    final response = await dio.delete(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    statusCode = response.statusCode!;
  } catch (e) {
    statusCode = 503;
  }
  return statusCode;
}

static Future<int> deleteImage(String domainName,String token, String receiptImageId) async {
    int statusCode = 0;
    final Dio dio = Dio();
    String url = '${domainName}/a/s3/deleteFileAWS';
    print('url delete api receipt: $url');
    try {
      final response = await dio.delete(
        url,
        data: {
          'receiptImageId': receiptImageId,
        },  
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      statusCode = response.statusCode!;

       print('Delete response status: $statusCode');
    } catch (e) {
      statusCode = 503;
      print('Error deleting image: $e');
    }
    return statusCode;
  }

static Future<Map<String, dynamic>> calculatePointReceipts(String domainName, String token, String receiptImageId) async {
    final Dio dio = Dio();
    int statusCode = 0;
    String url = '${domainName}/a/ocr/calculatePoints';    
    try {
      final response = await dio.post(
        url,
        data: {
          "receiptImageId": receiptImageId,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      statusCode = response.statusCode!;

      if(statusCode == 200){           
      return {
        'status': response.data['status'] ?? 'Failed',
        'collected_point': response.data['collected_point'] ?? 0,
      };
      } else {
      return {
        'status': 'Error',
        'collected_point': 0,
      };
    }   
    } catch (e) {
      return {
        "status": "Failed",
        "collected_point": 0,
      };
    }
  }

static Future<List<Map<String, dynamic>>> fetchReceiptList1(String domainName, String token) async {
    final dio = Dio();
    final url = '$domainName/api/receipt/app/list';
    final options = Options(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await dio.get<List<dynamic>>(url, options: options);
      final statusCode = response.statusCode!;
      if (statusCode == 200) {
        return response.data?.cast<Map<String, dynamic>>() ?? <Map<String, dynamic>>[];
      } else {
        return [];
      }
    } on DioException catch (e) {
      print(e);
      return [];
    }
  }
  
static Future<Map<String, List<Map<String, dynamic>>>> fetchReceiptList(String domainName, String token, String userId, int page, int limit) async {
    final dio = Dio();
   
    final url = '$domainName/api/receipt/app/list';
    final options = Options(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await dio.get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'user_id': userId,
          'page': page,
          'limit': limit,
          },

        options: options,
      );

        // print('API Response Status Code: ${response.statusCode}');
        // print('API Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        // Convert the response data to the expected format
        Map<String, List<Map<String, dynamic>>> formattedData = {};
        
        response.data!.forEach((date, receipts) {
          if (receipts is List) {
            formattedData[date] = List<Map<String, dynamic>>.from(receipts);
          }
        });

        return formattedData;
      } else {
        print('Error: ${response.statusCode}');
        return {};
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      return {};
    }
  }

  static Future<Map<String, dynamic>> getReceiptImageUrl(String domainName, String token, String receiptImageId) async {
    final dio = Dio();
    String url = '${domainName}/a/s3/getReceiptImageUrl';
    int statusCode = 0;

    Map<String, dynamic> resultImage = {
      "status_code": statusCode,
      "result": []
    };

    try {
      final response = await dio.get(
        url,
        data: {          
          'receiptImageId': receiptImageId,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      statusCode = response.statusCode!;
      if (statusCode == 200) {
        resultImage.update("result", (value) => [ response.data, receiptImageId ]);
        
      } else {
        print('Error: ${response.statusCode}');
        return {
          'status': 'Error',
          'data': 'null',
        };
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      return {
        'status': 'Error',
        'data': 'null',
      };
    }

    return resultImage;
  }
  
  
  }


