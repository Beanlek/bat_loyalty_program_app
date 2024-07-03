import 'dart:async';
import "dart:math";

import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_state_city/country_state_city.dart' as country;
import 'package:flutter/widgets.dart';

mixin RegisterComponents {
  final PageController pageController = PageController(initialPage: 1);

  final TextEditingController usernameController = TextEditingController(text: 'User1000');
  final TextEditingController fullNameController = TextEditingController(text: 'Ahmad Albab');
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController(text: 'imr4nfazli@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: 'amast@123');
  final TextEditingController confirmPasswordController = TextEditingController(text: 'amast@12');

  final TextEditingController address1Controller = TextEditingController(text: 'No 2 1C/KU5');
  final TextEditingController address2Controller = TextEditingController(text: 'Jalan Raya');
  final TextEditingController address3Controller = TextEditingController(text: 'Taman Bunga');
  final TextEditingController postcodeController = TextEditingController();

  final FocusNode usernameFocusnode = FocusNode();
  final FocusNode fullNameFocusnode = FocusNode();
  final FocusNode phoneFocusnode = FocusNode();
  final FocusNode emailFocusnode = FocusNode();
  final FocusNode passwordFocusnode = FocusNode();
  final FocusNode confirmPasswordFocusnode = FocusNode();

  final FocusNode address1Focusnode = FocusNode();
  final FocusNode address2Focusnode = FocusNode();
  final FocusNode address3Focusnode = FocusNode();
  final FocusNode postcodeFocusnode = FocusNode();

  Map<String, String> errMsgs = {
    "usernameErrorMsg" : '',
    "fullNameErrorMsg" : '',
    "phoneErrorMsg" : '',
    "emailErrorMsg" : '',
    "passwordErrorMsg" : '',
    "confirmPasswordErrorMsg" : '',

    "address1ErrorMsg" : '',
    "address2ErrorMsg" : '',
    "address3ErrorMsg" : '',
    "cityErrorMsg" : '',
    "stateErrorMsg" : '',
    "postcodeErrorMsg" : '',
    "securityImageErrorMsg" : '',
    "securityPhraseErrorMsg" : '',
  };

  int activeStep = 1;
  int totalSteps = 4;
  
  bool mainButtonActive = false;
  bool step1ButtonActive = false;
  bool step2ButtonActive = false;
  bool step3ButtonActive = false;
  bool finalButtonActive = false;

  List<bool> page1Error = [true, true, true, true, true];
  List<bool> page2Error = [true, true, true, true, true, true,];
  List<bool> page3Error = [true, true];

  bool viewPhrase = true;
  bool viewPersonalInfo = true;
  bool viewAddress = true;
  bool viewSecurity = true;
  
  List<dynamic> states = [];
  List<String> statesFilters = ['State'];
  List<dynamic> city = [];
  List<String> cityFilters = ['City'];
  final TextEditingController stateController = TextEditingController(text: 'State');
  final TextEditingController cityController = TextEditingController(text: 'City');

  List<bool> imageSelections = [false, false, false, false];
  List<bool> phraseSelections = [false, false, false, false, false];
  List<dynamic> securityImages = [];
  List<dynamic> securityImagesTemp = [];
  List<dynamic> securityImagesRandomed = [];
  List<String> securityPhrases = [];
  List<String> securityPhrasesTemp = [];
  List<String> securityPhrasesRandomed = [];
  final TextEditingController securityImageController = TextEditingController();
  final TextEditingController securityPhraseController = TextEditingController();

  Map<String, dynamic> registrationData = {};

  static const REGEX_PHONE = r'^(?:[+]6)?0(([0-9]{2,3}((\s[0-9]{3,4}\s[0-9]{4})|(-[0-9]{3,4}\s[0-9]{4})|(-[0-9]{7,8})))|([0-9]{9,10}))$';
  // malaysian phone no, 01112341234 @ 601112341234

  static const REGEX_EMAIL = r'\w+@\w+\.\w+';
  // standard email, imran@gmail.com

  static const REGEX_USERNAME = r'^[a-zA-Z]+[a-zA-Z0-9]*$';
  // starts with a letter

  static const REGEX_NAME = r'^([^0-9]*)$';
  // also used for city and state // text only

  static const REGEX_ADDRESS = r'^.*';
  // allow all

  static const REGEX_PASSWORD = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  // 1 lowercase 1 special 1 digit

  static const REGEX_POSTCODE = r'^[0-9]{5}$';
  // 5 integer only

  static const REGEX_SECURITY_IMAGE = r'^assets/security_images/SIMG-\d{4}\.jpg$';
  // SIMG-<any number>

  Future<void> mainButtonValidation(BuildContext context) async {
    if (phoneController.text.isNotEmpty) { 
      await phoneNumberValidation(context).then((valid) { mainButtonActive = valid; });
    }

    else { mainButtonActive = false; }
  }

  void step1ButtonValidation(void Function(void Function()) setState) {
    if (
      usernameController.text.isNotEmpty &&
      fullNameController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty
    ) { setState((){ step1ButtonActive = true; }); }
    else { setState((){ step1ButtonActive = false; }); }
  }

  void step2ButtonValidation(void Function(void Function()) setState) {
    if (
      address1Controller.text.isNotEmpty &&
      address2Controller.text.isNotEmpty &&
      address3Controller.text.isNotEmpty &&
      cityController.text != 'City' &&
      stateController.text != 'State' &&
      postcodeController.text.isNotEmpty
    ) { setState((){ step2ButtonActive = true; }); }
    else { setState((){ step2ButtonActive = false; }); }
  }

  void step3ButtonValidation(void Function(void Function()) setState) {
    if (
      securityImageController.text.isNotEmpty &&
      securityPhraseController.text.isNotEmpty
    ) { setState((){ step3ButtonActive = true; }); }
    else { setState((){ step3ButtonActive = false; }); }
  }

  Future<bool> registrationDataValidation(BuildContext context) async {
    bool thisValid = true;
    
    final id = usernameController.text.trim();
    final mobile = phoneController.text.trim();
    final password = passwordController.text.trim();

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();

    final address1 = address1Controller.text.trim();
    final address2 = address2Controller.text.trim();
    final address3 = address3Controller.text.trim();
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final postcode = postcodeController.text.trim();

    String securityImage = securityImageController.text.trim();
    final securityPhrase = securityPhraseController.text.trim();

    await phoneNumberValidation(context).then((valid) { if (!valid) thisValid = false; });
    await usernameValidation(context).then((valid) { if (!valid) thisValid = false; });

    if (email.isNotEmpty || email != '') { inputValidation(context, 'email', pattern: REGEX_EMAIL, data: email); }

    await inputValidation(context, 'fullName', pattern: REGEX_NAME, data: name).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'address1', pattern: REGEX_ADDRESS, data: address1).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'address2', pattern: REGEX_ADDRESS, data: address2).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'address3', pattern: REGEX_ADDRESS, data: address3).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'city', pattern: REGEX_NAME, data: city).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'state', pattern: REGEX_NAME, data: state).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'postcode', pattern: REGEX_POSTCODE, data: postcode).then((valid) { if (!valid) thisValid = false; });

    await inputValidation(context, 'securityImage', pattern: REGEX_SECURITY_IMAGE, data: securityImage).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'securityPhrase', pattern: REGEX_NAME, data: securityPhrase).then((valid) { if (!valid) thisValid = false; });

    securityImage = securityImage.substring(securityImage.indexOf('S'), securityImage.indexOf('.'));

    registrationData.addEntries({ "id": id }.entries);
    registrationData.addEntries({ "name": name }.entries);
    registrationData.addEntries({ "password": password }.entries);
    registrationData.addEntries({ "address1": address1 }.entries);
    registrationData.addEntries({ "address2": address2 }.entries);
    registrationData.addEntries({ "address3": address3 }.entries);
    registrationData.addEntries({ "postcode": postcode }.entries);
    registrationData.addEntries({ "city": city }.entries);
    registrationData.addEntries({ "state": state }.entries);
    registrationData.addEntries({ "email": email }.entries);
    registrationData.addEntries({ "mobile": mobile }.entries);
    registrationData.addEntries({ "security_image": securityImage }.entries);
    registrationData.addEntries({ "security_phrase": securityPhrase }.entries);

    print( registrationData );

    return thisValid;
  }

  Future<bool> phoneNumberValidation(BuildContext context) async {
    bool valid = false;
    String msg = 'Your phone number are already registered.';

    await Future.delayed(const Duration(seconds: 1)).then((_) {
      String pattern = REGEX_PHONE;
      RegExp regex = RegExp(pattern);

      if (regex.hasMatch(phoneController.text)) { valid = true; }
        else { msg = 'Invalid phone number. Please try again.'; phoneController.text = ''; }

      if (!valid) FloatingSnackBar(message: msg, context: context);
    });

    errMsgs.update('phoneErrorMsg', (value) => msg);

    return valid;
  }

  Future<bool> usernameValidation(BuildContext context, {bool snackBar = true}) async {
    bool valid = false;
    String msg = 'Your username are already taken.';

    await Future.delayed(const Duration(seconds: 1)).then((_) {
      String pattern = REGEX_USERNAME;
      RegExp regex = RegExp(pattern);

      if (regex.hasMatch(usernameController.text)) { valid = true; }
        else { msg = 'Invalid username. Please follow the guideline.'; }

      if (!valid && snackBar) FloatingSnackBar(message: msg, context: context);
    });
    
    errMsgs.update('usernameErrorMsg', (value) => msg);
    
    return valid;
  }

  Future<bool> inputValidation(BuildContext context, String label,
    { required String pattern, required String data, bool password = false, bool snackBar = true }
  ) async {
    bool valid = false;
    String msg = 'Invalid ${label}. Please double check.';

    switch (label) {
      case 'fullName':
        msg = 'Make sure your name contains only alphabet.';
        break;
      case 'email':
        msg = 'Eg: emailName@gmail.com';
        break;
      case 'password':
        msg = 'At least 1 digit and 1 special character';
        break;
      case 'postcode':
        msg = 'Make sure contains 5 digit.';
        break;
      default:
    }

    RegExp regex = RegExp(pattern);

    if (password) {
      if ( data == passwordController.text ) {
        if (regex.hasMatch(data)) { valid = true; }
      } else { msg = 'Password does not match.'; }
    } else { if (regex.hasMatch(data)) { valid = true; } }

    if (!valid && snackBar) FloatingSnackBar(message: msg, context: context);

    if (data.isEmpty || data == '') { msg = '${label.capitalize()} is empty.'; }

    errMsgs.update('${label}ErrorMsg', (value) => msg);

    return valid;
  }
  
  Future<void> setCountryStates() async {
    await country.getStatesOfCountry('MY').then((_states) {

      for (var i = 0; i < _states.length; i++) {
        var singleState = _states[i].toJson();
        var stateName = singleState['name'];

        states.add(singleState);
        statesFilters.add(stateName);
      }
      print('states : ${states}');
    });
  }

  Future<void> setSecurityPhrases() async {
    await rootBundle.loadString('assets/security_phrases/SPHRASES.txt').then((_phraseBundle) {

      final phrases = _phraseBundle.split('\n');

      securityPhrases = List<String>.from(phrases);
      securityPhrasesTemp = List<String>.from(phrases);
    });
  }

  void randomizeSecurityPhrases({key, bool? onTap}) {
    final random = Random();
    List<String> randomList = [];
    
    for (var i = 0; i < 5; i++) {
      var randomPhrases = securityPhrasesTemp[random.nextInt(securityPhrasesTemp.length)];

      if (i == 0) {
        randomList.add(randomPhrases);
      }
      
      else {
        var sameRandom = false;
        
        for (var j = 0; j < randomList.length; j++) {
          if (randomList[j] == randomPhrases) {
            print("sameRandom break");
            sameRandom = true;
            break;
          }
        }
        
        if (!sameRandom) {randomList.add(randomPhrases);}
        else {i--;}
      }

      // print("in localcomponent $i: ${randomList[i]}");

    }

    securityPhrasesRandomed = List<String>.from(randomList);
  }

  //finalSubmit

  Future<void> setSecurityImages() async {
    final regEx = RegExp(r'(?<=assets/security_images/)(.*)(?=.jpg)');

    await AssetManifest.loadFromAssetBundle(rootBundle).then((_assetManifest) async {
      final List<String> assetsSecurityImages = _assetManifest.listAssets().where((string) => string.startsWith("assets/security_images/")).toList();

      for (var i = 0; i < assetsSecurityImages.length; i++) {
        Map<String, dynamic> singleSecurityImage = {};
        
        String? imageName;
        String imagePath;
        
        var match = regEx.firstMatch(assetsSecurityImages[i]);
        if (match != null) imageName = match.group(0);

        imagePath = 'assets/security_images/${imageName}.jpg';

        singleSecurityImage.addEntries({
          "name": imageName,
          "path": imagePath,
        }.entries);
        
        securityImages.add(singleSecurityImage);
      }

      securityImagesTemp = List<dynamic>.from(securityImages);

    });
  }

  void randomizeSecurityImages({key, bool? onTap}) {
    final random = Random();
    List<dynamic> randomList = [];
    
    for (var i = 0; i < 4; i++) {
      var randomImage = securityImagesTemp[random.nextInt(securityImagesTemp.length)];

      if (i == 0) {
        randomList.add(randomImage);
      }
      
      else {
        var sameRandom = false;
        
        for (var j = 0; j < randomList.length; j++) {
          if (randomList[j] == randomImage) {
            print("sameRandom break");
            sameRandom = true;
            break;
          }
        }
        
        if (!sameRandom) {randomList.add(randomImage);}
        else {i--;}
      }

      // print("in localcomponent $i: ${randomList[i]}");

    }

    securityImagesRandomed = List<dynamic>.from(randomList);
  }

  void nextPage(void Function(void Function()) setState) {
    setState(() {
      activeStep++;
      pageController.animateToPage(
        activeStep,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void previousPage(void Function(void Function()) setState) {
    setState(() {
      activeStep--;
      pageController.animateToPage(
        activeStep,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void toPage(void Function(void Function()) setState, {key, required int page}) {
    setState(() {
      activeStep = page;
      pageController.animateToPage(
        activeStep,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }
}