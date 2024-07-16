import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

mixin HomeComponents {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  bool imageTaken = false;
  bool imageRetake = false;
  int loyaltyPoints = 0;

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