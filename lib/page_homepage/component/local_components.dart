import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
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

  Future<bool> takeImage() async {
    bool imageTaken = false;
    final imagePicker = ImagePicker();
    await imagePicker.pickImage(source: ImageSource.camera).then((img) {
      if (img != null) {receiptImage = img; imageTaken = true;}
    });

    return imageTaken;
  }

  
}
