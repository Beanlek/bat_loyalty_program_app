import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

mixin HomeComponents {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  
  final ScrollController productController = ScrollController();
  final ScrollController stickyController = ScrollController();


  bool imageTaken = false;
  bool imageRetake = false;
  int loyaltyPoints = 0;


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

  late Map<String, dynamic> user;
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