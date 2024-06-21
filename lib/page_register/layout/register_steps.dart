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
    
    super.dispose();
  }

  @override
  Future<void> initParam() async{
    super.initParam();
    setCountryStates();
    setSecurityImages();
  }
  
  @override
  Widget build(BuildContext context) {
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

                        if (index == 1) {
                          return RegisterWidgets.MyPage(context, index: 1, onSubmit: () {
                            nextPage(setState);
                          },

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
                          }, isDarkMode: isDarkMode);
                        } else if (index == 4) {
                          return RegisterWidgets.MyPage(context, index: 4, onSubmit: () {
                            FloatingSnackBar(message: 'End', context: context);
                          }, isDarkMode: isDarkMode);
                        } else if (index == 5) {
                          return RegisterWidgets.MyPage(context, index: 5, isDarkMode: isDarkMode);
                        } else {
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