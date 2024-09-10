import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

mixin ManageOutletComponents {
  DateFormat? dateTime;

  final List<Map<dynamic,dynamic>> accounts = [
    {
      "data": "7-11",
      "filter": false
    },
    {
      "data": "Family Mart",
      "filter": false
    },
  ];

  List<dynamic> accountImages = [];
  List<dynamic> accountImagesTemp = [];

  bool activeTemp = true;
  bool showInactiveOutlets = true;
  
  Map<String, dynamic> outlets = {};

  Future<void> setAccountImages() async {
    final regEx = RegExp(r'(?<=assets/account_images/)(.*)(?=.png)');

    await AssetManifest.loadFromAssetBundle(rootBundle).then((_assetManifest) async {
      final List<String> assetsAccountImages = _assetManifest.listAssets().where((string) => string.startsWith("assets/account_images/")).toList();
      
      print('assetsAccountImages.length: ${assetsAccountImages.length}');
      for (var i = 0; i < assetsAccountImages.length; i++) {
        print('count: $i');
        Map<String, dynamic> singleAccountImage = {};

        if (i == assetsAccountImages.length) {
          singleAccountImage.addEntries({
            "name": 'company',
            "path": 'assets/account_images/company.png',
          }.entries);
        } else {
          String? imageName;
          String imagePath;
          
          var match = regEx.firstMatch(assetsAccountImages[i]);
          if (match != null) imageName = match.group(0);

          imagePath = 'assets/account_images/${imageName}.png';

          singleAccountImage.addEntries({
            "name": imageName,
            "path": imagePath,
          }.entries);
        }
        
        accountImages.add(singleAccountImage);
      }

      accountImagesTemp = List<dynamic>.from(accountImages);

    });
  }
}