import "dart:math";

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_state_city/country_state_city.dart' as country;

mixin RegisterComponents {
  final PageController pageController = PageController(initialPage: 1);

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

  int activeStep = 1;
  int totalSteps = 4;
  
  bool mainButtonActive = false;

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

  Future<void> mainButtonValidation(BuildContext context) async {
    if (phoneController.text.isNotEmpty) { 
      await phoneNumberValidation(context).then((valid) {mainButtonActive = valid;});
    }

    else { mainButtonActive = false; }
  }

  Future<bool> phoneNumberValidation(BuildContext context) async {
    bool valid = false;

    await Future.delayed(const Duration(seconds: 1)).then((_) {
      valid = true;

      if (!valid) FloatingSnackBar(message: 'Your phone number are already registered.', context: context);
    });

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