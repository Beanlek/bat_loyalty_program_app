import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/page_register/layout/register_steps.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_register/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with RegisterComponents, MyComponents{

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
    phoneController.dispose();
    mainScrollController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context);
    
    return PopScope(
      canPop: false,
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
                  SizedBox(height: MySize.Height(context, 0.1),),

                  Expanded(
                    child: MyWidgets.MyScroll1( context,
                      controller: mainScrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GradientText(Localizations!.register,
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w800),
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.primary,
                                  ]),
                                ),
                                SizedBox(height: 12,),
                                Text(Localizations.enter_phone_to_start_registration, style: Theme.of(context).textTheme.bodySmall),
                                SizedBox(height: 24,),
<<<<<<< Updated upstream
                                MyWidgets.MyTextField1(context, 'Phone', phoneController, digitOnly: true, onSubmit: (value) async {
=======

                                MyWidgets.MyTextField1(context, Localizations.phone, phoneController, digitOnly: true, onSubmit: (value) async {
>>>>>>> Stashed changes
                                  setState(() {
                                    isLoading = true;
                                  });

                                  await mainButtonValidation(context).whenComplete(() { setState(() { isLoading = false; }); });

                                }, onChanged: (_) => setState(() { print('Changed!'); mainButtonActive = false; }),),
<<<<<<< Updated upstream
=======

                                !pagePhoneError[0] ? MyWidgets.MyErrorTextField(context, errMsgs['phoneErrorMsg']!) : SizedBox(),
                                !pagePhoneError[1] ? MyWidgets.MyInfoTextField2(context, errMsgs['phoneErrorMsg']!) : SizedBox(),
                                pagePhoneValid ? MyWidgets.MySuccessTextField(context, Localizations.phone_number_valid) : SizedBox(),
>>>>>>> Stashed changes
                            
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(Localizations.forgot_password, style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              color: Theme.of(context).colorScheme.outline,
                                      ),),
                                      Text.rich(style: Theme.of(context).textTheme.bodySmall,
                                        TextSpan(text: Localizations.already_registered,
                                          children: [
                                            TextSpan(text: Localizations.login_here, style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              color: Theme.of(context).colorScheme.outline,
                                            ),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                Navigator.pushNamed(
                                                  context,
                                                  LoginPage.routeName
                                                );
                                              }
                                            )
                                          ]
                                        )
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                        
                            MyWidgets.MyButton1(context, 150, Localizations.next, active: mainButtonActive,
                              () async {
                                final phone = phoneController.text.trim();
                                
                                Navigator.pushNamed(
                                  context,
                                  RegisterStepsPage.routeName, 

                                  arguments: MyArguments('_', phone: phone)
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyWidgets.MyFooter1(context),
                  )
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