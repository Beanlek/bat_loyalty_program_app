import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

import 'package:bat_loyalty_program_app/page_register/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_register/widget/local_widgets.dart';

import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';

class RegisterStepsPage extends StatefulWidget {
  const RegisterStepsPage({super.key});

  static const routeName = '/register/steps';

  @override
  State<RegisterStepsPage> createState() => _RegisterStepsPageState();
}

class _RegisterStepsPageState extends State<RegisterStepsPage> with RegisterComponents, MyComponents{

  @override
  void initState() {
    initParam().whenComplete(() {
      setState(() {
        launchLoading = false;
      });
    });
    
    super.initState();
  }

  @override
  void dispose() {
    mainScrollController.dispose();
    pageController.dispose();

    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    postcodeController.dispose();

    stateController.dispose();
    cityController.dispose();

    securityImageController.dispose();
    securityPhraseController.dispose();
    
    super.dispose();
  }

  @override
  Future<void> initParam() async{
    super.initParam();
    setCountryStates();
    setSecurityPhrases().whenComplete(() => randomizeSecurityPhrases() );
    setSecurityImages().whenComplete(() => randomizeSecurityImages() );
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return PopScope(
      onPopInvoked: (value) {
        if (activeStep > 1) previousPage(setState);
      },
      canPop: activeStep == 1 ? true : false,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : Scaffold(
        body:
    
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 38),
              child: Column(
                children: [
                  SizedBox(height: MySize.Height(context, 0.05),),
                  MyWidgets.MyLogoHeader(context, isDarkMode, appVersion: appVersion),
                  SizedBox(height: 12,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: () {
                              print('steps.dart activeStep: $activeStep');
                              if (activeStep == 1) {
                                Navigator.pop(context);
                                return;
                              } else {
                                previousPage(setState);
                              }
                            }, icon: Icon(Icons.arrow_back_rounded)),
                    
                            SizedBox(
                              height: MySize.Height(context, 0.02),
                              width: MySize.Width(context, 0.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: RegisterWidgets.MySteps(context, activeStep: activeStep, totalSteps: totalSteps),
                              )
                            ),
                            IconButton(onPressed: () {}, icon: PLACEHOLDER_ICON),
                          ],
                        ),
                    
                        Text('Step $activeStep of $totalSteps', style: Theme.of(context).textTheme.labelMedium,)
                      ],
                    ),
                  ),

                  SizedBox(height: 12,),

                  Expanded(
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      itemCount: totalSteps + 1,
                      itemBuilder: (context, index) {
                        print('index : $index');
                        // return MyWidgets.MyErrorPage(context, isDarkMode);

                        if (index == 1) {
                          return RegisterWidgets.MyPage(context, index: 1, onSubmit: () {
                            nextPage(setState);
                          },
                          phone: args.phone,

                          usernameController: usernameController,
                          fullNameController: fullNameController,
                          emailController: emailController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          
                          isDarkMode: isDarkMode);
                        } else if (index == 2) {
                          return RegisterWidgets.MyPage(context, index: 2, onSubmit: () {
                            nextPage(setState);
                          },
                          phone: args.phone,

                          address1Controller: address1Controller,
                          address2Controller: address2Controller,
                          address3Controller: address3Controller,
                          postcodeController: postcodeController,

                          states: states,
                          stateFilters: statesFilters,
                          stateController: stateController,

                          city: city,
                          cityFilters: cityFilters,
                          cityController: cityController,

                          isDarkMode: isDarkMode);
                        } else if (index == 3) {
                          return RegisterWidgets.MyPage(context, index: 3, onSubmit: () {
                            nextPage(setState);
                          },
                          phone: args.phone,

                          viewPhrase: viewPhrase,
                          imageSelections: imageSelections,
                          phraseSelections: phraseSelections,

                          securityImages: securityImages,
                          securityImagesTemp: securityImagesTemp,
                          securityImagesRandomed: securityImagesRandomed,
                          securityImageController: securityImageController,

                          securityPhrases: securityPhrases,
                          securityPhrasesTemp: securityPhrasesTemp,
                          securityPhrasesRandomed: securityPhrasesRandomed,
                          securityPhraseController: securityPhraseController,

                          changeViewPhrase: () { setState(() { viewPhrase = !viewPhrase; });},
                          onPhraseRefresh: () { setState(() {
                            randomizeSecurityPhrases(onTap: true);
                            phraseSelections.replaceRange(0, phraseSelections.length, phraseSelections.map((_) => false));
                          });},
                          onImageRefresh: () { setState(() {
                            randomizeSecurityImages(onTap: true);
                            imageSelections.replaceRange(0, imageSelections.length, imageSelections.map((_) => false));
                          });},
                          
                          isDarkMode: isDarkMode);
                        } else if (index == 4) {
                          return RegisterWidgets.MyPage(context, index: 4, onSubmit: () {
                            FloatingSnackBar(message: 'End', context: context);
                          },
                          phone: args.phone,
                          pageController: pageController,

                          toPage1: () { setState(() { toPage(setState, page: 1); }); },
                          toPage2: () { setState(() { toPage(setState, page: 2); }); },
                          toPage3: () { setState(() { toPage(setState, page: 3); }); },

                          viewPersonalInfo: viewPersonalInfo,
                          viewAddress: viewAddress,
                          viewSecurity: viewSecurity,

                          securityImageController : securityImageController,
                          securityPhraseController : securityPhraseController,

                          usernameController : usernameController,
                          fullNameController : fullNameController,
                          emailController : emailController,
                          passwordController : passwordController,
                          confirmPasswordController : confirmPasswordController,

                          address1Controller : address1Controller,
                          address2Controller : address2Controller,
                          address3Controller : address3Controller,
                          postcodeController : postcodeController,

                          stateController : stateController,
                          cityController : cityController,

                          changeViewPersonalInfo: () { setState(() { viewPersonalInfo = !viewPersonalInfo; });},
                          changeViewAddress: () { setState(() { viewAddress = !viewAddress; });},
                          changeViewSecurity: () { setState(() { viewSecurity = !viewSecurity; });},
                          
                          isDarkMode: isDarkMode);
                        }  else {
                          return MyWidgets.MyErrorPage(context, isDarkMode);
                        }
                      },
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyWidgets.MyFooter1(context),
                  ),
                ],
              )
            ),
    
            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ]
        )
      )
    );
  }
}