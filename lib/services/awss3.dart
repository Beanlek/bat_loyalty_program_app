import 'dart:io';
import 'dart:typed_data';

import 'package:bat_loyalty_program_app/amplifyconfiguration.dart';

import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';

class AwsS3 {
  
  static Future<void> configure() async {
    try {
      await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    } catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }
  
  static Future<Object> uploadImageReceipt( {key, required XFile receipt, required String userId}) async {
    Object status = false;
    
    File local = File(receipt.path);
    Uint8List bytes = local.readAsBytesSync();
    final streamInt = Stream.value( List<int>.from(bytes), );
    
    try {
      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          streamInt,
          size: local.lengthSync(),
        ),
        path: StoragePath.fromString('receipts/${userId}/${receipt.name}'),
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;

      safePrint('Successfully uploaded file: ${result.uploadedItem.path}');
      status = true;

      return status;

    } on StorageException catch (e) {
      safePrint('StorageException: ${e.message}');
      status = e.message;

      return status;
    }
  }

  static Future<Map<dynamic, dynamic>> getReceiptImageUrl( {key, required String userId, required XFile receipt }) async {
    Object status = false;
    Map<dynamic, dynamic> result = {};

    void setResult(Object _result) {
      result.addEntries( {"status": status}.entries );
      result.addEntries( {"result": _result}.entries );
    }
    
    try {
      final response = await Amplify.Storage.getUrl( path: StoragePath.fromString('receipts/${userId}/${receipt.name}') ).result;
      safePrint('url: ${response.url}');
      status = true;

      setResult(response.url);
      
      return result;
    } on StorageException catch (e) {
      safePrint(e.message);
      status = e.message;

      setResult('null');

      return result;
    } catch (e) {
      safePrint(e);
      status = e;

      setResult('null');

      return result;
    }
  }

}