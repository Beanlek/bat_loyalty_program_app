import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';

import 'package:bat_loyalty_program_app/page_register/layout/register.dart';
import 'package:bat_loyalty_program_app/page_homepage/layout/homepage.dart';

import 'package:bat_loyalty_program_app/page_login/component/local_components.dart';

import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginComponents, MyComponents{

  @override
  void initState() {
    initParam().whenComplete(() { setState(() { launchLoading = false; }); });
    
    super.initState();
  }

  @override
  void dispose() {
    mainScrollController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    
    super.dispose();
  }

  @override
  Future<void> initParam() async {
    super.initParam();

    await MyPrefs.init().then((prefs) {
      prefs!;

      final allDomainString = MyPrefs.getAllDomain(prefs: prefs)!;
      final Map<String, dynamic> allDomain = jsonDecode(allDomainString);

      allDomain.forEach((key, value) => domainList.add(value));
    });

    print('domainName : $domainName');
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return PopScope(
      canPop: false,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : Scaffold(

        floatingActionButton: MyWidgets.ToChangeEnv( context, domainNow: domainName, domainList: domainList, onChanged: (value) async { value!;
          setState(() { isLoading = true; });
        
          await MyPrefs.init().then((prefs) { prefs!;
            MyPrefs.setDomainName(value, prefs: prefs);
            setState(() { isLoading = false; domainName = value; });
          });
        } ),
        
        body: 
        
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 38),
              child: Column(
                children: [
                  SizedBox(height: MySize.Height(context, 0.05),),
                  MyWidgets.MyLogoHeader(context, isDarkMode, appVersion: appVersion),
                  SizedBox(height: MySize.Height(context, 0.08),),

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
                                GradientText('Log In',
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w800),
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.primary,
                                  ]),
                                ),
                                SizedBox(height: 24,),
                                MyWidgets.MyTextField1(context, 'Username or Phone', phoneController, focusNode: phoneFocusnode, onSubmit: (_) => passwordFocusnode.requestFocus(),),
                                pageError[0] ? MyWidgets.MyErrorTextField(context, errMsgs['phoneErrorMsg']! ) : SizedBox(),
                                SizedBox(height: 12,),
                                MyWidgets.MyTextField1(context, 'Password', passwordController, focusNode: passwordFocusnode, isPassword: true, onSubmit: (_) => passwordFocusnode.unfocus()),
                                pageError[1] ? MyWidgets.MyErrorTextField(context, errMsgs['passwordErrorMsg']! ) : SizedBox(),
                        
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Forgot Password', style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              color: Theme.of(context).colorScheme.outline,
                                      ),),
                                      Text.rich(style: Theme.of(context).textTheme.bodySmall,
                                        TextSpan(text: 'New? ',
                                          children: [
                                            TextSpan(text: 'Register Here.', style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              color: Theme.of(context).colorScheme.outline,
                                            ),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RegisterPage.routeName
                                                );
                                              }
                                            )
                                          ]
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        
                            MyWidgets.MyButton1(context, 150, 'Log In', 
                              () async {
                                setState(() { isLoading = true; 
                                  errMsgs.update('phoneErrorMsg', (value) => 'Please enter your username or phone.');
                                  errMsgs.update('passwordErrorMsg', (value) => 'Please enter your password.');
                                });
                        
                                final String mobile = phoneController.text.trim();
                                final String password = passwordController.text.trim();

                                setState(() { pageError[0] = mobile.isEmpty; });
                                setState(() { pageError[1] = password.isEmpty; });

                                if (pageError.every((e) => e == false)) {
                                  await Api.login(domainName, mobile: mobile, password: password, deviceID: deviceID).then((statusCode) async {
                                    await MyPrefs.init().then((prefs) async {
                                      prefs!;
                                      
                                      final token = MyPrefs.getToken(prefs: prefs);
                          
                                      if (statusCode == 200 && token != null) {
                                        await Api.user_self(domainName, token);
                          
                                        Navigator.pushNamed(
                                          context,
                                          Homepage.routeName
                                        );
                          
                                        FloatingSnackBar(message: 'Successfully Log In.', context: context);
                                      } else if (statusCode == 422) {
                                        String msg = 'Wrong username or password.';
                                        
                                        setState(() { 
                                          pageError[0] = true;
                                          pageError[1] = true;
                                          errMsgs.update('phoneErrorMsg', (value) => msg);
                                          errMsgs.update('passwordErrorMsg', (value) => msg);
                                        });

                                        FloatingSnackBar(message: msg, context: context);
                                      } else {
                                        FloatingSnackBar(message: 'Unable to Log In. Error ${statusCode}.', context: context);
                                      }
                                    });
                                    
                                  });
                                }
                                setState(() { isLoading = false; });
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text('Running on ${domainName}', style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w300, fontSize: 10),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyWidgets.MyFooter1(context),
                  )
                ],
              ),
            ),

            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ],
        ),
      ),
    );
  }
}