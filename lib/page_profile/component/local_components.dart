import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/regex.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:country_state_city/country_state_city.dart' as country;

mixin ProfileComponents {
  DateFormat? dateTime;
  String createdAt = "";
  String createdAtDetail = "";
  
  bool profileEdited = false;
  
  // controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController address3Controller = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final TextEditingController accountController = TextEditingController();
  final TextEditingController outletController = TextEditingController();
  
  final TextEditingController securityImageController = TextEditingController();
  final TextEditingController securityPhraseController = TextEditingController();

  // focusnodes
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

  final FocusNode dummyFocusnode = FocusNode();

  List<dynamic> states = [];
  List<String> statesFilters = ['State'];
  List<dynamic> city = [];
  List<String> cityFilters = ['City'];

  // error handlers
  Map<String, String> errMsgs = {
    "phoneErrorMsg" : '',
    "usernameErrorMsg" : '',
    "fullNameErrorMsg" : '',
    "emailErrorMsg" : '',
    "passwordErrorMsg" : '',

    "address1ErrorMsg" : '',
    "address2ErrorMsg" : '',
    "address3ErrorMsg" : '',
    "cityErrorMsg" : '',
    "stateErrorMsg" : '',
    "postcodeErrorMsg" : '',
  };
  
  // booleans
  bool createUser = true;
  bool saveButtonActive = true;
  List<bool> errorMarks = [false, false, false, false, false, false, false, false, false, false, false];
  
  Map<String, dynamic> user = {};
  Map<String, dynamic> outlets = {};
  Map<String, dynamic> updateSelfData = {};

  void disposeAll() {
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

  String listAllOutlets({ required Map<String, dynamic> outlets }) {
    String result = "";

    for (var i = 0; i < outlets['count']; i++) {
      if (result == "") { result = "${outlets['rows'][i]['outlet_id']}\t${outlets['rows'][i]['account_id']}"; }
      else { result = "${result}\n${outlets['rows'][i]['outlet_id']}\t${outlets['rows'][i]['account_id']}"; }
    }

    return result;
  }

  void setControllers() {
    print('setControllers initiated');
    usernameController.text = user['id'];
    fullNameController.text = user['name'];
    phoneController.text = user['mobile'];
    emailController.text = user['email'];
    passwordController.text = user['password'];

    address1Controller.text = user['address1'];
    address2Controller.text = user['address2'];
    address3Controller.text = user['address3'];
    postcodeController.text = user['postcode'];
    cityController.text = user['city'];
    stateController.text = user['state'];

    accountController.text = "user[]";
    outletController.text = "user[]";
    
    securityImageController.text = "assets/security_images/${user['security_image']}.jpg";
    securityPhraseController.text = user['security_phrase'];
  }

  Future<bool> updateSelfDataValidation(BuildContext context, String domainName, void Function(void Function() fn) setState) async {
    bool thisValid = false;
    updateSelfData.clear();

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final address1 = address1Controller.text.trim();
    final address2 = address2Controller.text.trim();
    final address3 = address3Controller.text.trim();
    final state = stateController.text.trim();
    final city = cityController.text.trim();
    final postcode = postcodeController.text.trim();
    
    await inputValidation(context, 'fullName', pattern: Regex.REGEX_NAME, data: name, snackBar: false).then((valid) => setState(() { errorMarks[2] = valid; }));
    if (email.isNotEmpty || email != '') await inputValidation(context, 'email', pattern: Regex.REGEX_EMAIL, data: email, snackBar: false).then((valid) => setState(() { errorMarks[3] = valid; }));
    await inputValidation(context, 'password', pattern: Regex.REGEX_PASSWORD, data: password, snackBar: false).then((valid) => setState(() { errorMarks[4] = valid; }));
    await inputValidation(context, 'address1', pattern: Regex.REGEX_ADDRESS, data: address1, snackBar: false).then((valid) => setState(() { errorMarks[5] = valid; }));
    await inputValidation(context, 'address2', pattern: Regex.REGEX_ADDRESS, data: address2, snackBar: false).then((valid) => setState(() { errorMarks[6] = valid; }));
    await inputValidation(context, 'address3', pattern: Regex.REGEX_ADDRESS, data: address3, snackBar: false).then((valid) => setState(() { errorMarks[7] = valid; }));
    await inputValidation(context, 'state', pattern: Regex.REGEX_NAME, data: state, snackBar: false).then((valid) => setState(() { errorMarks[8] = valid; }));
    await inputValidation(context, 'city', pattern: Regex.REGEX_NAME, data: city, snackBar: false).then((valid) => setState(() { errorMarks[9] = valid; }));
    await inputValidation(context, 'postcode', pattern: Regex.REGEX_POSTCODE, data: postcode, snackBar: false).then((valid) => setState(() { errorMarks[10] = valid;}));

    errorMarks.every((e) => e == false) ? thisValid = true : null;

    if (thisValid) {
    updateSelfData.addEntries({ "name": name }.entries);
    updateSelfData.addEntries({ "address1": address1 }.entries);
    updateSelfData.addEntries({ "address2": address2 }.entries);
    updateSelfData.addEntries({ "address3": address3 }.entries);
    updateSelfData.addEntries({ "postcode": postcode }.entries);
    updateSelfData.addEntries({ "city": city }.entries);
    updateSelfData.addEntries({ "state": state }.entries);
    updateSelfData.addEntries({ "email": email }.entries);
    }

    print( updateSelfData );

    return thisValid;
  }

  void saveButtonValidation(void Function(void Function()) setState) {
    if (
      cityController.text != 'City' &&
      stateController.text != 'State'
    ) { setState((){ saveButtonActive = true; }); }
    else { setState((){ saveButtonActive = false; }); }
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

    if (data.isEmpty || data == '') { msg = '${label.capitalize()} is empty.'; valid = false; } //print("${label.capitalize()}: $data , return: ${!valid}");

    errMsgs.update('${label}ErrorMsg', (value) => msg);

    return !valid;
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

  Future<void> setCity({
    required void Function(void Function()) setState
  }) async {

    print('stateController.text: ${stateController.text}');
    var stateChosen = states.where((_singleState) {
      final stateName = _singleState['name'];
      
      return stateName.contains(stateController.text);
    }).toList();
              
    print('stateChosen : ${stateChosen[0]}');
    var stateCode = stateChosen[0]['isoCode'];
    
    await country.getStateCities('MY',stateCode).then((_cities) {

      setState(() {
        for (var i = 0; i < _cities.length; i++) {
          var singleCity = _cities[i].toJson();
          var cityName = singleCity['name'];
          
          city.add(singleCity);
          cityFilters.add(cityName);
        }
      });

      // setState(() {
      //   stepButtonValidation();
      // });
    });
  }
}