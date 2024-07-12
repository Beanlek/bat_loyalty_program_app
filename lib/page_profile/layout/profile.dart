import 'dart:convert';

import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_profile/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';

import 'package:bat_loyalty_program_app/page_profile/component/local_components.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ProfileComponents, MyComponents{

  @override
  void initState() {
    initParam().whenComplete(() { setState(() { launchLoading = false; }); });
    
    super.initState();
  }

  @override
  void dispose() { super.dispose(); }
  
  @override
  Future<void> initParam() async {
    super.initParam();
    
    dateTime = DateFormat('dd/MM/yyyy').add_Hms();
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final userMap = jsonDecode(args.user); user = Map.from(userMap);
    
    DateTime createdAtParsed = DateTime.parse(user['createdAt']).add(Duration(hours: int.parse('8')));
    String createdAt = monthYear!.format(createdAtParsed);
    String createdAtDetail = dateTime!.format(createdAtParsed);

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ProfilePage.routeName);

    return PopScope(
      canPop: true,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : Scaffold(
        appBar: MyWidgets.MyAppBar(context, isDarkMode, 'Profile', appVersion: appVersion),
        
        body:
    
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths)),

                  Expanded(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(children: [
                      SizedBox( height: MySize.Height(context, 0.15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox.expand(
                                child: CircleAvatar(
                                  backgroundColor: MyColors.greyImran2,
                                  child: Icon(
                                    Icons.person,
                                    size: MySize.Height(context, 0.07),
                                    color: MyColors.greyImran,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 24,),
                        
                            Expanded(flex: 2, 
                              child: Padding( padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Column( children: [
                                    Text(user['id'], style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                                    Text('+6${user['mobile']}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),),
                                  ],),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text('Joined ${createdAt}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),),
                                    Row(children: [Icon(FontAwesomeIcons.pen, size: MySize.Height(context, 0.01),), SizedBox(width: 10,), Text('Edit', style: Theme.of(context).textTheme.labelSmall)],)
                                  ],
                                  ),
                                ],),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 12,),
                    
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                            gradient: LinearGradient(colors: [
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.primary,
                            ], begin: Alignment.bottomLeft, end: Alignment.topRight)
                          ),

                          child: Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 32),
                            child: Column( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Information', style: Theme.of(context).textTheme.titleMedium!.copyWith( color: Theme.of(context).colorScheme.onSecondary),),
                                  SizedBox(height: 12,),
                                
                                  ProfileWidgets.InfoTile(context, 'Username', subtitle: user['id']),
                                  ProfileWidgets.InfoTile(context, 'Full Name', subtitle: user['name']),
                                  ProfileWidgets.InfoTile(context, 'Mobile', subtitle: user['mobile']),
                                  ProfileWidgets.InfoTile(context, 'Email', subtitle: user['email']),
                                
                                  SizedBox(height: 16,),
                                  
                                  ProfileWidgets.InfoTile(context, 'Outlets', subtitle: "outlet[0]['id']\noutlet[1]['id']"),

                                  SizedBox(height: 16,),
                                  
                                  ProfileWidgets.InfoTile(context, 'Shipping\nAddress', subtitle:
                                    '${user['address1']}, ${user['address2']},\n${user['address3']}, ${user['postcode']},\n${user['city']}, ${user['state']}'
                                  ),
                                
                                  SizedBox(height: 16,),
                                  
                                  ProfileWidgets.InfoTile(context, 'Joined At', subtitle: createdAtDetail),
                                
                                  SizedBox(height: 12,),
                                  Divider( color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),),
                                ],),

                                MyWidgets.MyTileButton(context, 'Log Out', icon: FontAwesomeIcons.signOut, color: Theme.of(context).primaryColor, iconSize: MySize.Width(context, 0.04),
                                  onPressed: () async {
                                    await showDialog(context: context, builder: (context) => PopUps.Default(context, 'Logging Out',
                                      subtitle: 'You are logging out. Proceed?', warning: 'Once logged out, all progress will not be saved.'),).then((res) async {
                                        if (res) await Api.logout().whenComplete(() => Navigator.pushNamed( context, LoginPage.routeName ));
                                      });
                                  }
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],),
                  ))
                  
                  
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