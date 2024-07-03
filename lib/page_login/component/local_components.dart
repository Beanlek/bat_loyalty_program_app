import 'package:flutter/material.dart';

mixin LoginComponents {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(text: 'amast@123');

  final FocusNode phoneFocusnode = FocusNode();
  final FocusNode passwordFocusnode = FocusNode();

  List<bool> pageError = [false, false];

  Map<String, String> errMsgs = {
    "phoneErrorMsg" : "",
    "passwordErrorMsg" : ""
  };
}