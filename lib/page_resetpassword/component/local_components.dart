import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

mixin ResetPasswordComponents {
  final ScrollController imageScrollController = ScrollController();
  
  // 1st page
  final TextEditingController usernameController = TextEditingController();
  // 2nd page
  final TextEditingController securityImageController = TextEditingController();
  final TextEditingController securityPhraseController = TextEditingController();
  // 3rd page
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newConfirmPasswordController = TextEditingController();

  final FocusNode usernameFocusnode = FocusNode();
  final FocusNode securityPhraseFocusnode = FocusNode();
  final FocusNode newPasswordFocusnode = FocusNode();
  final FocusNode newConfirmPasswordFocusnode = FocusNode();

  // from user_self
  String trueSecurityImage = '';
  String trueSecurityPhrase = '';

  List<dynamic> securityImages = [];
  List<dynamic> securityImagesTemp = [];
  List<dynamic> securityImagesRandomed = [];

  List<String> securityPhrases = [];
  List<String> securityPhrasesTemp = [];
  List<String> securityPhrasesRandomed = [];

  // error handler
  bool usernameErrorMark = false;
  bool securityPhraseErrorMark = false;
  bool securityImageErrorMark = false;
  bool newPasswordErrorMark = false;
  bool newConfirmPasswordErrorMark = false;

  Map<String, String> errMsgs = {
    "usernameErrorMsg" : '',

    "securityPhraseErrorMsg" : '',
    "securityImageErrorMsg" : '',

    "newPasswordErrorMsg" : '',
    "newConfirmPasswordErrorMsg" : '',
  };

  // bool
  bool mainButtonActive = false;

  Future<void> mainButtonValidation(BuildContext context, String domainName) async {
    if (usernameController.text.isNotEmpty) { 
      await userValidation(context, domainName).then((valid) { mainButtonActive = valid; });
    }

    else {
      mainButtonActive = false; usernameErrorMark = true;
      errMsgs.update('usernameErrorMsg', (value) => 'Please enter your username.');
    }
  }

  Future<bool> userValidation(BuildContext context, String domainName ) async {
    bool valid = false;
    String msg = 'Username does not exist.';
    
    await Api.user_validate(domainName, user_id: usernameController.text ).then((Map<String, dynamic> res) {
      final int statusCode = res['status_code'];
      List<dynamic> results = List.from(res['result']);

      if (statusCode == 200) {
        
        valid = true;
      } else if (statusCode == 422) {

        valid = false;
        msg = results[0]["errMsg"];
      } else {

        valid = false;
        msg = 'Something went wrong. Error ${statusCode}.';
      }

      usernameErrorMark = !valid;

      if (!valid) FloatingSnackBar(message: msg, context: context);
    });

    errMsgs.update('usernameErrorMsg', (value) => msg);

    return valid;
  }

}