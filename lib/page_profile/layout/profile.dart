import 'dart:convert';

import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile_edit.dart';
import 'package:bat_loyalty_program_app/page_profile/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
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
    initParam(context).whenComplete(() { setState(() { launchLoading = false; }); });
    
    super.initState();
  }

  @override
  void dispose() { super.dispose(); }
  
  @override
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context);
    
    dateTime = DateFormat('dd/MM/yyyy').add_Hms();
  }

  @override
  Future<void> refreshPage(BuildContext context) async {
    await super.refreshPage(context).whenComplete(() async {

      await MyPrefs.init().then((prefs) async { prefs!;

        final _user = MyPrefs.getUser(prefs: prefs) ?? '{}';
        setState(() { user = jsonDecode(_user); }); print(user); print(launchLoading);

      });
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; print('profileEdited: $profileEdited');

    if (launchLoading) {
      final userMap = jsonDecode(args.user); user = Map.from(userMap); print('user: $user');
      final outletsMap = jsonDecode(args.outlets); outlets = Map.from(outletsMap);
    }
    DateTime createdAtParsed = DateTime.parse(user['created_at']).add(Duration(hours: int.parse('8'))); print(user['created_at']);
    setState(() => createdAt = monthYear2!.format(createdAtParsed) ); print(createdAt);
    setState(() => createdAtDetail = dateTime!.format(createdAtParsed) );

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ProfilePage.routeName);

    return PopScope(
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyWidgets.MyAppBar(context, isDarkMode, 'Profile', appVersion: appVersion),
        
        body:
    
        Stack(
          children: [
            CustomMaterialIndicator(
              edgeOffset: 10, backgroundColor: Colors.transparent, elevation: 0,
              onRefresh: () async { setState(() { refreshing = true; isLoading = true; }); await refreshPage(context).whenComplete(() => setState(() { isLoading = false; })); },
              
              // trigger: IndicatorTrigger.trailingEdge,
              // triggerMode: IndicatorTriggerMode.anywhere,

              indicatorBuilder: (context, controller) => Icon(FontAwesomeIcons.rotateRight, size: MySize.Width(context, 0.08),),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths)),
                        
                      Expanded( child: MyWidgets.MyScroll1( context, controller: mainScrollController, height: MySize.Height(context, 0.85), child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                      Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(user['id'], style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                                        Text('+6${user['mobile']}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),),
                                      ],),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text('Joined ${createdAt}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),),
                                        MyWidgets.MyTileButton(context, 'Edit', icon: FontAwesomeIcons.pen, iconSize: MySize.Height(context, 0.01), buttonHeight: MySize.Height(context, 0.03),
                                          onPressed: () => Navigator.pushNamed( context, ProfileEditPage.routeName , arguments: MyArguments(token, prevPath: currentPath, user: jsonEncode(user)))),
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
                                    SingleChildScrollView( child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text('Information', style: Theme.of(context).textTheme.titleMedium!.copyWith( color: Theme.of(context).colorScheme.onSecondary),),
                                      SizedBox(height: 12,),
                                    
                                      ProfileWidgets.InfoTile(context, 'Username', subtitle: user['id']),
                                      ProfileWidgets.InfoTile(context, 'Full Name', subtitle: user['name']),
                                      ProfileWidgets.InfoTile(context, 'Mobile', subtitle: user['mobile']),
                                      ProfileWidgets.InfoTile(context, 'Email', subtitle: user['email']),
                                    
                                      SizedBox(height: 16,),
                                      
                                      ProfileWidgets.InfoTile(context, 'Outlets', subtitle: listAllOutlets(outlets: outlets)),
                        
                                      SizedBox(height: 16,),
                                      
                                      ProfileWidgets.InfoTile(context, 'Shipping\nAddress', subtitle:
                                        '${user['address1']}, ${user['address2']},\n${user['address3']}, ${user['postcode']},\n${user['city']}, ${user['state']}'
                                      ),
                                    
                                      SizedBox(height: 16,),
                                      
                                      ProfileWidgets.InfoTile(context, 'Joined At', subtitle: createdAtDetail),
                                    
                                      SizedBox(height: 12,),
                                      Divider( color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),),
                                    ],)),
                        
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
                      )))
                      
                      
                    ],
                  )
                ),
              ),
            ),
            
            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ]
        )
      ))
    );
  }
}