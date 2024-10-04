import 'dart:async';
import "dart:math";

import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/regex.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_state_city/country_state_city.dart' as country;
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

mixin RegisterComponents {
  final PageController pageController = PageController(initialPage: 1);

  final TextEditingController usernameController = TextEditingController(text: 'Cashier1021');
  final TextEditingController fullNameController = TextEditingController(text: 'Jason Olga');
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController(text: 'imr4nfazli@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: 'amast@123');
  final TextEditingController confirmPasswordController = TextEditingController(text: 'amast@12');

  final TextEditingController address1Controller = TextEditingController(text: 'No 5 Unit AD08');
  final TextEditingController address2Controller = TextEditingController(text: 'Jalan Ophelia');
  final TextEditingController address3Controller = TextEditingController(text: 'Taman Jaring');
  final TextEditingController postcodeController = TextEditingController();

  final FocusNode phoneFocusnode = FocusNode();
  final FocusNode usernameFocusnode = FocusNode();
  final FocusNode fullNameFocusnode = FocusNode();
  final FocusNode emailFocusnode = FocusNode();
  final FocusNode passwordFocusnode = FocusNode();
  final FocusNode confirmPasswordFocusnode = FocusNode();

  final FocusNode address1Focusnode = FocusNode();
  final FocusNode address2Focusnode = FocusNode();
  final FocusNode address3Focusnode = FocusNode();
  final FocusNode postcodeFocusnode = FocusNode();

  Map<String, String> errMsgs = {
    "phoneErrorMsg" : '',
    "usernameErrorMsg" : '',
    "fullNameErrorMsg" : '',
    "emailErrorMsg" : '',
    "passwordErrorMsg" : '',
    "confirmPasswordErrorMsg" : '',

    "address1ErrorMsg" : '',
    "address2ErrorMsg" : '',
    "address3ErrorMsg" : '',
    "cityErrorMsg" : '',
    "stateErrorMsg" : '',
    "postcodeErrorMsg" : '',

    "accountErrorMsg" : '',
    "outletErrorMsg" : '',
    
    "securityImageErrorMsg" : '',
    "securityPhraseErrorMsg" : '',
  };

  int activeStep = 1;
  int totalSteps = 5;
  
  bool mainButtonActive = false;
  bool step1ButtonActive = false;
  bool step2ButtonActive = false;
  bool step3ButtonActive = false;
  bool step4ButtonActive = false;
  bool finalButtonActive = false;

  bool pagePhoneValid = false;
  bool postcodeChanged = false;

  List<bool> pagePhoneError = [true, true];
  List<bool> page1Error = [true, true, true, true, true];
  List<bool> page2Error = [true, true, true, true, true, true,];
  List<bool> page3Error = [true, true];
  List<bool> page4Error = [true, true, true];

  bool viewPhrase = true;
  bool viewPersonalInfo = true;
  bool viewAddress = true;
  bool viewOutlet = true;
  bool viewSecurity = true;
  
  List<Map<dynamic, dynamic>> accounts = [];
  List<String> accountFilters = ['Company'];
  List<Map<dynamic, dynamic>> outlets = [];
  List<String> outletFilters = ['Outlet'];

  final TextEditingController accountController = TextEditingController(text: 'Company');
  final TextEditingController outletPostcodeController = TextEditingController();
  final TextEditingController outletController = TextEditingController(text: 'Outlet');

  final FocusNode outletPostcodeFocusnode = FocusNode();
  
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

  Future<void> mainButtonValidation(BuildContext context, String domainName) async {
    if (phoneController.text.isNotEmpty) { 
      await phoneNumberValidation(context, domainName).then((valid) { mainButtonActive = valid; });
    }

    else { mainButtonActive = false; }
  }

  void disposeAll() {
    pageController.dispose();

    usernameController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    postcodeController.dispose();

    phoneFocusnode.dispose();
    usernameFocusnode.dispose();
    fullNameFocusnode.dispose();
    emailFocusnode.dispose();
    passwordFocusnode.dispose();
    confirmPasswordFocusnode.dispose();

    address1Focusnode.dispose();
    address2Focusnode.dispose();
    address3Focusnode.dispose();
    postcodeFocusnode.dispose();

    accountController.dispose();
    outletController.dispose();

    stateController.dispose();
    cityController.dispose();

    securityImageController.dispose();
    securityPhraseController.dispose();
  }

  void unfocusAllNode() {
    phoneFocusnode.unfocus();
    usernameFocusnode.unfocus();
    fullNameFocusnode.unfocus();
    emailFocusnode.unfocus();
    passwordFocusnode.unfocus();
    confirmPasswordFocusnode.unfocus();

    address1Focusnode.unfocus();
    address2Focusnode.unfocus();
    address3Focusnode.unfocus();
    postcodeFocusnode.unfocus();
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

  void step4ButtonValidation(void Function(void Function()) setState) {
    if (
      accountController.text != 'Account' &&
      postcodeController.text.isNotEmpty &&
      outletController.text != 'Outlet'
    ) { setState((){ step4ButtonActive = true; }); }
    else { setState((){ step4ButtonActive = false; }); }
  }

  Future<bool> registrationDataValidation(BuildContext context, String domainName) async {
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

    Map<dynamic, dynamic> outlet = outlets.where((_outlet) {
      final _outletName = _outlet['name'].toString();
      
      return _outletName == outletController.text;
    }).toList().first;

    final outletId = outlet['id'];

    await phoneNumberValidation(context, domainName).then((valid) { if (!valid) thisValid = false; });
    await usernameValidation(context, domainName).then((valid) { if (!valid) thisValid = false; });

    if (email.isNotEmpty || email != '') { inputValidation(context, 'email', pattern: Regex.REGEX_EMAIL, data: email); }

    await inputValidation(context, 'fullName', pattern: Regex.REGEX_NAME, data: name).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'address1', pattern: Regex.REGEX_ADDRESS, data: address1).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'address2', pattern: Regex.REGEX_ADDRESS, data: address2).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'address3', pattern: Regex.REGEX_ADDRESS, data: address3).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'city', pattern: Regex.REGEX_NAME, data: city).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'state', pattern: Regex.REGEX_NAME, data: state).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'postcode', pattern: Regex.REGEX_POSTCODE, data: postcode).then((valid) { if (!valid) thisValid = false; });

    await inputValidation(context, 'securityImage', pattern: Regex.REGEX_SECURITY_IMAGE, data: securityImage).then((valid) { if (!valid) thisValid = false; });
    await inputValidation(context, 'securityPhrase', pattern: Regex.REGEX_NAME, data: securityPhrase).then((valid) { if (!valid) thisValid = false; });

    securityImage = securityImage.substring(securityImage.indexOf('S'), securityImage.indexOf('.'));

    registrationData.addEntries({ "id": id }.entries);
    registrationData.addEntries({ "outlet_id": outletId }.entries);
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

  Future<bool> phoneNumberValidation(BuildContext context, String domainName ) async {
    bool valid = false; pagePhoneValid = valid;
    String msg = 'Looks like you already registered.';

    String pattern = Regex.REGEX_PHONE;
    RegExp regex = RegExp(pattern);

    if (regex.hasMatch(phoneController.text)) { valid = true; pagePhoneError[0]= valid; }
      else { msg = 'Invalid phone number. Please try again.'; phoneController.text = ''; pagePhoneError[0]= valid;}

    if (valid) {
      await Api.registration_validate(domainName, mobile: phoneController.text, id: '_' ).then((statusCode) {
        if (statusCode == 200) {
          pagePhoneError[1] = valid;
        } else if (statusCode == 422) { valid = false; pagePhoneError[1] = valid;
        } else { msg = 'Something went wrong. Error ${statusCode}.'; valid = false; pagePhoneError[0] = valid; }

        if (!valid) FloatingSnackBar(message: msg, context: context);
      });
    }

    if (pagePhoneError.every( (e) => e == true )) pagePhoneValid = true;

    errMsgs.update('phoneErrorMsg', (value) => msg);

    return valid;
  }

  Future<bool> usernameValidation(BuildContext context, String domainName, {bool snackBar = true}) async {
    bool valid = false; pagePhoneValid = valid;
    final Localizations = AppLocalizations.of(context);
    String msg = Localizations!.username_taken;
    String pattern = Regex.REGEX_USERNAME;
    RegExp regex = RegExp(pattern);

    if (regex.hasMatch(usernameController.text.trim())) { valid = true; }
      else { msg = Localizations.invalid_username_follow_guideline; }

    if (valid) {
      await Api.registration_validate(domainName, mobile: '_', id: usernameController.text.trim() ).then((statusCode) {
        if (statusCode == 422) { valid = false; }
          else if (statusCode == 200) {}
          else { msg = '${Localizations.something_went_wrong}  ${statusCode}.'; valid = false; }

        if (!valid && snackBar) FloatingSnackBar(message: msg, context: context);
      });
    }

    errMsgs.update('usernameErrorMsg', (value) => msg);

    return valid;
  }

  Future<bool> inputValidation(BuildContext context, String label,
    { required String pattern, required String data, bool password = false, bool snackBar = true }
  ) async {
    bool valid = false;
    final Localizations = AppLocalizations.of(context)!;
    String msg = '${Localizations.invalid} ${label}. ${Localizations.please_double_check}';

    switch (label) {
      case 'fullName':
        msg = Localizations.name_contains_only_alphabet;
        break;
      case 'email':
        msg = 'Eg: emailName@gmail.com';
        break;
      case 'password':
        msg = Localizations.password_criteria;
        break;
      case 'postcode':
        msg = Localizations.password_criteria;
        break;
      default:
    }

    RegExp regex = RegExp(pattern);

    if (password) {
      if ( data == passwordController.text ) {
        if (regex.hasMatch(data)) { valid = true; }
      } else { msg = Localizations.password_does_not_match; }
    } else { if (regex.hasMatch(data)) { valid = true; } }

    if (!valid && snackBar) FloatingSnackBar(message: msg, context: context);

    if (data.isEmpty || data == '') { msg = '${label.capitalize()}  ${Localizations.is_empty}'; }

    errMsgs.update('${label}ErrorMsg', (value) => msg);

    return valid;
  }
  
  Future<void> setAccountList(String domainName, void Function(void Function()) setState) async {
    accountFilters.clear(); accounts.clear();
    accountFilters.add('Company');
    
    await Api.account_list(domainName).then((res) {
      print("res['result']: ${res['result']}");
      
      final int statusCode = res['status_code'];

      List<dynamic> results = List.from(res['result']);

      setState(() {
        if (statusCode == 200) {
          for (var account in results) {
            accountFilters.add(account['name']);
          }
          
          accounts = List.from( results );
        } else {
          accountFilters.add('Error');
        }
      });


      print('accounts: $accounts');
    });
  }

  Future<void> setOutletList(BuildContext context, String domainName, void Function(void Function()) setState ) async {
    outletFilters.clear(); outlets.clear();
    outletFilters.add('Outlet');

    Map<dynamic, dynamic> accountId = accounts.where((_account) {
      final _accountName = _account['name'].toString();
      
      return _accountName == accountController.text;
    }).toList().first;

    print('accountId: ${accountId['id']}');
    
    await Api.outlet_list(domainName, account: accountId['id'], postcode: outletPostcodeController.text).then((res) {
      final int statusCode = res['status_code'];
      print(res);
      print(statusCode);

      List<dynamic> rows = List.from(res['result']['data']['rows']);

      setState(() {
        if (statusCode == 200) {
          for (var outlet in rows) {
            outletFilters.add(outlet['name']);
          }
          
          outlets = List.from( rows );

          if (outletFilters.length == 1) FloatingSnackBar(message: 'No outlets in the desribed postcode.', context: context);
        } else {
          outletFilters.add('Error');
        }
      });


      print('outlets: $outlets');
      print('outletFilters: $outletFilters');
    });
  }
  
  Future<void> setCountryStates() async {
    await country.getStatesOfCountry('MY').then((_states) {

      for (var i = 0; i < _states.length; i++) {
        var singleState = _states[i].toJson();
        var stateName = singleState['name'];

        states.add(singleState);
        statesFilters.add(stateName);
      }
      // print('states : ${states}');
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