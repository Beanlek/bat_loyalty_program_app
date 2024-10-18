import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';


mixin ImageStatusComponents <T extends StatefulWidget> on State<T>{

  bool receivedFullPage = false;
  int totalItems = 0;

  Map<String, dynamic> user = {};  
  Map<String, dynamic> receipts1 = {};
  Map<String, dynamic> receiptData2= {};
  // List<Map<dynamic, dynamic>> receiptsList = [];

  DateFormat? dateTime;
  List<dynamic> accountImages = [];
  List<dynamic> accountImagesTemp = [];

  late Future<Map<String, List<Map<dynamic, dynamic>>>> receiptListFuture;
  
  Map<String, List<Map<dynamic, dynamic>>> receiptData = {};
  bool isLoadingLocal = false;
  bool hasMore = true;
  int currentPageImage = 1;
  final int itemsPerPage = 10; // Adjust this value as needed

 final pageSize = 20;
 final PagingController<int, MapEntry<String, List<Map<String, dynamic>>>> pagingController = PagingController(firstPageKey: 1);
 bool isFetchingNextPage = false;

      // Map<String, dynamic> receiptData = {
      //   "Today": [
      //     {
      //       "image": 'assets/images_examples/receipt-001.jpg',
      //       "status": "In Process",
      //       "created_at": '2024-07-03 09:11:30',
      //     },          
      //   ],
      //   "14 July 2024": [
      //     {
      //       "image": 'assets/images_examples/receipt-003.jpg',
      //       "status": "Successful",
      //       "created_at": '2024-07-14 10:45:30',
      //     },
      //     {
      //       "image": 'assets/images_examples/receipt-003.jpg',
      //       "status": "Successful",
      //       "created_at": '2024-07-14 10:45:30',
      //     },
      //     {
      //       "image": 'assets/images_examples/receipt-002.jpg',
      //       "status": "Successful",
      //       "created_at": '2024-07-14 12:30:20',
      //     },
      //   ],
      //   "13 July 2024": [
      //     {
      //       "image": 'assets/images_examples/receipt-002.jpg',
      //       "status": "Failed",
      //       "created_at": '2024-07-13 09:50:10',
      //     },
      //     {
      //       "image": 'assets/images_examples/receipt-001.jpg',
      //       "status": "In Process",
      //       "created_at": '2024-07-13 11:05:40',
      //     },
      //   ],
      //   "12 July 2024": [
      //     {
      //       "image": 'assets/images_examples/receipt-002.jpg',
      //       "status": "Failed",
      //       "created_at": '2024-07-12 08:15:30',
      //     },
      //     {
      //       "image": 'assets/images_examples/receipt-003.jpg',
      //       "status": "Successful",
      //       "created_at": '2024-07-12 13:45:00',
      //     },
      //   ],
      // };

  Map<dynamic, dynamic> receipts = {
    "Today": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'

      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "14 July 2024": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-002.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "13 July 2024": [
      {
        "image": 'assets/images_examples/receipt-002.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "12 Jun 2024": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
  };

  final List<Map<dynamic,dynamic>> dateMap = [
    {
      "data": "Any time",
      "filter": false
    },
    {
      "data": "Today",
      "filter": false
    },
    {
      "data": "This week",
      "filter": false
    },
    {
      "data": "This month",
      "filter": false
    },
    {
      "data": "This year",
      "filter": false
    },
  ];

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

  Future<void> fetchPage(int pageKey,String token, String domainName) async {
    isFetchingNextPage = true;
    print('Fetching call for page: $pageKey');
    try {
      final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
      print('Fetching page $pageKey for user ${args.username}');
     
      final newItems = await Api.fetchReceiptList(
         domainName,
         token,
         args.username,
         pageKey,
         pageSize,
      );

      print('Received ${newItems.length} items for page $pageKey');      
      print('First item: ${newItems.entries.first}');
      print('Last item: ${newItems.entries.last}');

      print('Received ${newItems.length} items for page $pageKey');      

       final allDetails = newItems.entries.expand((entry) => entry.value).toList();      
      int count = allDetails.length;
      
      if(newItems.isEmpty){
        print('No items received for page $pageKey');
        pagingController.appendLastPage([]);
      }else {
        print('Received ${newItems.length} items for page $pageKey and size $pageSize');
      
      final isLastPage = count < pageSize;
      
  if (isLastPage) {
    print('This is the last page (page $pageKey)');
    pagingController.appendLastPage(newItems.entries.toList());
  } else {
    final nextPageKey = pageKey + 1;
    print('appending page $nextPageKey and setting next key to $nextPageKey');
    pagingController.appendPage(newItems.entries.toList(), nextPageKey);
  }
}
    } catch (error) {
      print('Error fetching page $pageKey: $error');
      pagingController.error = error;
    } finally {
      isFetchingNextPage = false; // Stop fetching
    }
  } 

  
}