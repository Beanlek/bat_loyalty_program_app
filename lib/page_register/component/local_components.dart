import "dart:math";

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
  
  List<dynamic> states = [];
  List<String> statesFilters = ['State'];
  List<dynamic> city = [];
  List<String> cityFilters = ['City'];
  final TextEditingController stateController = TextEditingController(text: 'State');
  final TextEditingController cityController = TextEditingController(text: 'City');

  List<dynamic> securityImages = [];
  List<dynamic> securityImagesTemp = [];
  List<dynamic> securityImagesRandomed = [];
  List<String> securityPhrases = [];
  final TextEditingController securityImageController = TextEditingController();
  final TextEditingController securityPhraseController = TextEditingController();

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

  //setSecurityPhrases

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

  void randomizeSecurityImages() {
    final random = Random();
    List<dynamic> randomList = [];
    
    for (var i = 0; i < 5; i++) {randomList.add(securityImagesTemp[random.nextInt(securityImagesTemp.length)]);}

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
}