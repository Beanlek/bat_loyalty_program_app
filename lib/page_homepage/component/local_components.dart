import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

mixin HomeComponents {
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final ScrollController productController = ScrollController();
  final ScrollController stickyController = ScrollController();

  bool imageTaken = false;
  bool imageRetake = false;
  int loyaltyPoints = 2000;
  bool imageRetakeSuccessful = false;
  

  
    int carouselIndex = 0;
  late CarouselOptions carouselOptions;

  String token = '';

  late Map<String, dynamic> user;
  late Map<String, dynamic> outlets;
  late Future<List<Product>> futureProduct;
 late Future<List<Product>> _futureProducts;
   late Locale _currentLocale;


  final List<Product> _filteredDataList = [];
  final List<Product> _allProducts = [];
  final bool _showFilterOptions = false;
  bool isSearching = false;

  final Api api = Api();
  final Locale locale = const Locale('en');


  
  final List<Map<dynamic,dynamic>> brandMap = [
    {
      "data": "Apple",
      "filter": false
    },
    {
      "data": "Samsung",
      "filter": false
    },
    {
      "data": "Chanel",
      "filter": false
    },
    {
      "data": "Logitech",
      "filter": false
    },
  ];

  final List<Map<dynamic,dynamic>> categoryMap = [
    {
      "data": "mobile devices",
      "filter": false
    },
    {
      "data": "cosmetics",
      "filter": false
    },
    {
      "data": "mouses",
      "filter": false
    },
  ];
  
  
  late XFile receiptImage;
  late String urlOriginal;
  late String urlOcr;
  late String receiptImageId = '';
  
 
    Future<bool> takeImage(String domainName, void Function(void Function()) setState) async {
    print("OCR:: takeImage init start");
    bool imageTaken = false;
    final imagePicker = ImagePicker();
    await imagePicker.pickImage(source: ImageSource.camera).then((img) async {
      if (img != null) { receiptImage = img;
        await Api.uploadImageReceipt(domainName, token, receipt: receiptImage, outletId: 'ECO13003').then((res) {
          print("OCR:: Api.uploadImageReceipt call then");
          final int statusCode = res['status_code'];
          List<dynamic> results = List.from(res['result']);

          setState(() {
            if (statusCode == 200) {
              print('OCR: results $results');
              urlOriginal = results[0]["data"]["url_original"];
              urlOcr = results[0]["data"]["url_ocr"];
              receiptImageId = results[1];                                         
              imageTaken = true;
            } else {
              print("OCR:: api call failed $statusCode");
              imageTaken = false;
            }
          });

          print('urlOriginal: $urlOriginal');
          print('urlOcr: $urlOcr');
          print('receiptImageId: $receiptImageId');

        });
      }
    });

    return imageTaken;
  }
  
}
