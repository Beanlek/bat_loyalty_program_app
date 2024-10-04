import 'package:flutter/material.dart';

mixin LoginComponents {
  final TextEditingController phoneController = TextEditingController(text: 'Cashier1021');
  final TextEditingController passwordController = TextEditingController(text: 'amast@123');
  // final TextEditingController phoneController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  final FocusNode phoneFocusnode = FocusNode();
  final FocusNode passwordFocusnode = FocusNode();

  List<bool> pageError = [false, false];
  List<String> domainList = [];

  Map<String, String> errMsgs = {
    "phoneErrorMsg" : "",
    "passwordErrorMsg" : ""
  };
}