import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/page_register/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_register/widget/local_widgets.dart';

import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';

class RegisterStepsPage extends StatefulWidget {
  const RegisterStepsPage({super.key});

  static const routeName = '/register/steps';

  @override
  State<RegisterStepsPage> createState() => _RegisterStepsPageState();
}

class _RegisterStepsPageState extends State<RegisterStepsPage> with RegisterComponents, MyComponents{

  @override
  void initState() {
    initParam(context, needToken: false).whenComplete(() {
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
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async{
    super.initParam(context, needToken: false).whenComplete((){ setAccountList(domainName, setState); });

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
                              // print('steps.dart activeStep: $activeStep');
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
                          return RegisterWidgets.MyPage(context, index: 1, onSubmit: () async {
                            setState(() { isLoading = true; });

                            final name = fullNameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final confirmPassword = confirmPasswordController.text.trim();

                            await usernameValidation(context, domainName, snackBar: false).then((valid) => setState(() { page1Error[0] = valid; }));
                            await inputValidation(context, 'fullName', pattern: RegisterComponents.REGEX_NAME, data: name, snackBar: false).then((valid) => setState(() { page1Error[1] = valid; }));
                            if (email.isNotEmpty || email != '') await inputValidation(context, 'email', pattern: RegisterComponents.REGEX_EMAIL, data: email, snackBar: false).then((valid) => setState(() { page1Error[2] = valid; }));
                            await inputValidation(context, 'password', pattern: RegisterComponents.REGEX_PASSWORD, data: password, snackBar: false).then((valid) => setState(() { page1Error[3] = valid; }));
                            await inputValidation(context, 'confirmPassword', pattern: RegisterComponents.REGEX_PASSWORD, data: confirmPassword, password: true, snackBar: false).then((valid) => setState(() { page1Error[4] = valid; isLoading = false; }));
                            
                            page1Error.every((e) => e == true) ? nextPage(setState) : null;
                          },
                          phone: args.phone,
                          errMsgs: errMsgs,
                          pageError: page1Error,
                          stepButtonActive: step1ButtonActive,
                          stepButtonValidation: () { step1ButtonValidation(setState); },

                          usernameController: usernameController,
                          fullNameController: fullNameController,
                          emailController: emailController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,

                          usernameFocusnode: usernameFocusnode,
                          fullNameFocusnode: fullNameFocusnode,
                          emailFocusnode: emailFocusnode,
                          passwordFocusnode: passwordFocusnode,
                          confirmPasswordFocusnode: confirmPasswordFocusnode,
                          
                          isDarkMode: isDarkMode);
                        } else if (index == 2) {
                          return RegisterWidgets.MyPage(context, index: 2, onSubmit: () async {
                            setState(() { isLoading = true; });

                            final address1 = address1Controller.text.trim();
                            final address2 = address2Controller.text.trim();
                            final address3 = address3Controller.text.trim();
                            final state = stateController.text.trim();
                            final city = cityController.text.trim();
                            final postcode = postcodeController.text.trim();
                            
                            await inputValidation(context, 'address1', pattern: RegisterComponents.REGEX_ADDRESS, data: address1, snackBar: false).then((valid) => setState(() { page2Error[0] = valid; }));
                            await inputValidation(context, 'address2', pattern: RegisterComponents.REGEX_ADDRESS, data: address2, snackBar: false).then((valid) => setState(() { page2Error[1] = valid; }));
                            await inputValidation(context, 'address3', pattern: RegisterComponents.REGEX_ADDRESS, data: address3, snackBar: false).then((valid) => setState(() { page2Error[2] = valid; }));
                            await inputValidation(context, 'state', pattern: RegisterComponents.REGEX_NAME, data: state, snackBar: false).then((valid) => setState(() { page2Error[3] = valid; }));
                            await inputValidation(context, 'city', pattern: RegisterComponents.REGEX_NAME, data: city, snackBar: false).then((valid) => setState(() { page2Error[4] = valid; }));
                            await inputValidation(context, 'postcode', pattern: RegisterComponents.REGEX_POSTCODE, data: postcode, snackBar: false).then((valid) => setState(() { page2Error[5] = valid; isLoading = false;}));
                            
                            page2Error.every((e) => e == true) ? nextPage(setState) : null;
                          },
                          phone: args.phone,
                          errMsgs: errMsgs,
                          pageError: page2Error,
                          stepButtonActive: step2ButtonActive,
                          stepButtonValidation: () { step2ButtonValidation(setState); },

                          isLoadingTrue: () { setState(() => isLoading = true); },
                          isLoadingFalse: () { setState(() => isLoading = false); },

                          address1Controller: address1Controller,
                          address2Controller: address2Controller,
                          address3Controller: address3Controller,
                          postcodeController: postcodeController,

                          address1Focusnode: address1Focusnode,
                          address2Focusnode: address2Focusnode,
                          address3Focusnode: address3Focusnode,
                          postcodeFocusnode: postcodeFocusnode,

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
                          errMsgs: errMsgs,
                          pageError: page3Error,
                          stepButtonActive: step3ButtonActive,
                          stepButtonValidation: () { step3ButtonValidation(setState); },

                          isLoadingTrue: () { setState(() => isLoading = true); },
                          isLoadingFalse: () { setState(() => isLoading = false); },

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
                            securityPhraseController.clear();
                            step3ButtonValidation(setState);
                            randomizeSecurityPhrases(onTap: true);
                            phraseSelections.replaceRange(0, phraseSelections.length, phraseSelections.map((_) => false));
                          });},
                          onImageRefresh: () { setState(() {
                            securityImageController.clear();
                            step3ButtonValidation(setState);
                            randomizeSecurityImages(onTap: true);
                            imageSelections.replaceRange(0, imageSelections.length, imageSelections.map((_) => false));
                          });},
                          
                          isDarkMode: isDarkMode);
                        } else if (index == 4) {
                          return RegisterWidgets.MyPage(context, index: 4, onSubmit: () async {
                            nextPage(setState);
                          },
                          phone: args.phone,
                          errMsgs: errMsgs,
                          pageError: page4Error,
                          stepButtonActive: step4ButtonActive,
                          stepButtonValidation: () { step4ButtonValidation(setState); },
                          pageController: pageController,

                          isLoadingTrue: () { setState(() => isLoading = true); },
                          isLoadingFalse: () { setState(() => isLoading = false); },

                          accounts: accounts,
                          accountFilters: accountFilters,
                          accountController: accountController,

                          outlets: outlets,
                          outletFilters: outletFilters,
                          outletController: outletController,

                          setOutletList: () { setOutletList(domainName, setState); },
                          
                          isDarkMode: isDarkMode);
                        } else if (index == 5) {
                          return RegisterWidgets.MyPage(context, index: 5, onSubmit: () async {
                            setState(() { isLoading = true; phoneController.text = args.phone; });
                            
                            await registrationDataValidation(context, domainName).then((valid) async {
                              if (valid) {
                                await Api.user_register(context, domainName, registrationData: registrationData).then((statusCode) {
                                  print({ statusCode });

                                  if (statusCode == 200) {
                                    setState(() { isLoading = false; });

                                    FloatingSnackBar(message: 'Account successfully registered! Log in to proceed.', context: context);

                                    Navigator.pushNamed(
                                      context,
                                      LoginPage.routeName
                                    );
                                  } else if (statusCode == 422) {
                                    FloatingSnackBar(message: 'Error ${statusCode}. Phone or Username already existed.', context: context);
                                  } else {
                                    FloatingSnackBar(message: 'Something went wrong. Error ${statusCode}.', context: context);
                                  }
                                  
                                  setState(() { isLoading = false; });
                                });
                              }
                            });
                          },
                          phone: args.phone,
                          errMsgs: errMsgs,
                          pageError: [],
                          stepButtonActive: finalButtonActive,
                          stepButtonValidation: () {},
                          pageController: pageController,

                          isLoadingTrue: () { setState(() => isLoading = true); },
                          isLoadingFalse: () { setState(() => isLoading = false); },

                          toPage1: () { setState(() { toPage(setState, page: 1); }); },
                          toPage2: () { setState(() { toPage(setState, page: 2); }); },
                          toPage3: () { setState(() { toPage(setState, page: 3); }); },
                          toPage4: () { setState(() { toPage(setState, page: 4); }); },

                          viewPersonalInfo: viewPersonalInfo,
                          viewAddress: viewAddress,
                          viewOutlet: viewOutlet,
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

                          accountController : accountController,
                          outletController : outletController,

                          changeViewPersonalInfo: () { setState(() { viewPersonalInfo = !viewPersonalInfo; });},
                          changeViewAddress: () { setState(() { viewAddress = !viewAddress; });},
                          changeViewOutlet: () { setState(() { viewOutlet = !viewOutlet; });},
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