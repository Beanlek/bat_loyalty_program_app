import 'package:bat_loyalty_program_app/page_resetpassword/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_resetpassword/layout/resetpassword_steps.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  static const routeName = '/reset_password';

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with MyComponents, ResetPasswordComponents{
  
  @override
  void initState() {
    super.initState();
    
    initParam(context, needToken: false).whenComplete(() { setState(() { launchLoading = false; }); });
  }

  @override
  void dispose() { 
    mainScrollController.dispose();
    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context);

    return PopScope(
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        
        body:
        
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                                GradientText(Localizations!.reset_password,
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w800),
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.primary,
                                  ]),
                                ),
                                SizedBox(height: 12,),
                                Text(Localizations.enter_username_reset_password, style: Theme.of(context).textTheme.bodySmall),
                                SizedBox(height: 24,),

                                MyWidgets.MyTextField1(context, Localizations.username, usernameController, onSubmit: (value) async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  await mainButtonValidation(context,domainName).whenComplete(() { setState(() { isLoading = false; }); });

                                }, onChanged: (_) => setState(() { print('Changed!'); mainButtonActive = true; }),),

                                usernameErrorMark ? MyWidgets.MyErrorTextField(context, errMsgs['usernameErrorMsg']! ) : SizedBox(),
                            
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                                  child: Text.rich(style: Theme.of(context).textTheme.bodySmall,
                                      TextSpan(text:Localizations.dont_remember,
                                        children: [
                                          TextSpan(text: Localizations.contact_us, style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                            recognizer: TapGestureRecognizer()..onTap = () {
                                              // Contact Us
                                            }
                                          )
                                        ]
                                      )
                                    ),
                                )
                              ],
                            ),
                        
                            MyWidgets.MyButton1(context, 150, Localizations.next,
                              () async {
                                if (mainButtonActive) {
                                  final username = usernameController.text.trim();
                                  
                                  await userValidation(context, domainName).then((valid) {
                                    if (valid) {
                                      Navigator.pushNamed( context,
                                        ResetPasswordStepsPage.routeName, 

                                        arguments: MyArguments('_', username: username)
                                      );
                                    }
                                  });
                                } else if(usernameErrorMark && usernameController.text.isNotEmpty) {
                                  FloatingSnackBar(message: errMsgs['usernameErrorMsg']!, context: context);
                                } else {
                                  FloatingSnackBar(message: 'Please complete the form.', context: context);
                                }
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
              ),
            ),

            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ],
        ),),
    ));
  }
}