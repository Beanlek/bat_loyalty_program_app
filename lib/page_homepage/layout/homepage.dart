import 'dart:convert';
import 'package:bat_loyalty_program_app/page_homepage/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_homepage/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  
  static const routeName = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with HomeComponents, MyComponents{

  @override
  void initState() {
    loyaltyPoints = 2000;
    initParam().whenComplete(() { setState(() { launchLoading = false; }); });
    
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    
    super.dispose();
  }

  @override
  Future<void> initParam() async{
    super.initParam();

    await MyPrefs.init().then((prefs) async {
      prefs!;

      await Api.checkToken().then((res) {
        if (res) token = MyPrefs.getToken(prefs: prefs)!;
        
        if (!res) {
          FloatingSnackBar(message: 'Session time out.', context: context);
          Navigator.pushNamed( context, LoginPage.routeName );
        }
      });
      
      final _user = MyPrefs.getUser(prefs: prefs) ?? '{}';
      user = jsonDecode(_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : Scaffold(
        
        key: scaffoldKey,
        appBar: HomeWidgets.MyAppBar(context, isDarkMode, appVersion: appVersion, scaffoldKey: scaffoldKey,
          onTap: () => Navigator.pushNamed( context, ProfilePage.routeName , arguments: MyArguments(token, prevPath: "/home", user: jsonEncode(user)))),

        body: 
        
        Stack(
          children: [
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MySize.Height(context, 0.135),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Loyalty Points', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),),
                          Expanded(child: Row(
                            children: [
                              Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['id']!, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.normal),),
                                  Text.rich(
                                    TextSpan(text: loyaltyPoints.toString(), style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.outlineVariant),
                                        children: [
                                          TextSpan(text: ' pts', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.outlineVariant
                                        )
                                      )
                                    ])
                                  )
                                ],
                              )),
                              Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyWidgets.MyTileButton(context, 'Tracking History', icon: Icons.history),
                                  MyWidgets.MyTileButton(context, 'Images Status', icon: Icons.image),
                                ],
                              )),
                            ],
                          )),
                        ],
                      )
                    ),

                    SizedBox(height: 12,),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Catalogue', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),),

                          //Search Bar

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

        drawer: HomeWidgets.MyDrawer(context, isDarkMode, appVersion: appVersion, domainName: domainName, 
          items: [
            HomeWidgets.Item(context, icon: FontAwesomeIcons.userAlt, label: 'Profile',
              onTap: () => Navigator.pushNamed( context, ProfilePage.routeName , arguments: MyArguments(token, prevPath: "/home", user: jsonEncode(user)))),
            HomeWidgets.Item(context, icon: FontAwesomeIcons.storeAlt, label: 'Manage Outlets',
              onTap: () => false),

            Divider(color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.5),),

            HomeWidgets.Item(context, icon: FontAwesomeIcons.history, label: 'Tracking History',
              onTap: () => false),
            HomeWidgets.Item(context, icon: FontAwesomeIcons.images, label: 'Images Status',
              onTap: () => false),

            Divider(color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.5),),

            HomeWidgets.Item(context, icon: FontAwesomeIcons.gear, label: 'Settings',
              onTap: () => false),
            HomeWidgets.Item(context, icon: FontAwesomeIcons.signOut, label: 'Log Out',
              onTap: () async {
                await showDialog(context: context, builder: (context) => PopUps.Default(context, 'Logging Out',
                  subtitle: 'You are logging out. Proceed?', warning: 'Once logged out, all progress will not be saved.'),).then((res) async {
                    if (res) await Api.logout().whenComplete(() => Navigator.pushNamed( context, LoginPage.routeName ));
                  });
              }),
          ]
        )
      ),
    );
  }
}