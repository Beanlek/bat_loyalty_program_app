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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    
<<<<<<< Updated upstream
    super.initState();
=======
    initParam(context).whenComplete(() {
       setState(() {         
        launchLoading = false; 
        }); 
      });
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isnitialized) {
      futureLocale = getFutureLocale(context);
      isnitialized = true;
    }
>>>>>>> Stashed changes
  }

  @override
  void dispose() { super.dispose(); }
  
  @override
  Future<void> initParam() async {
    super.initParam();
    
    dateTime = DateFormat('dd/MM/yyyy').add_Hms();

     futureLocale = getFutureLocale(context);
  }
<<<<<<< Updated upstream
=======

  @override
  Future<void> refreshPage(BuildContext context, void Function(void Function() fn) setState) async {
    await super.refreshPage(context, setState).whenComplete(() async {

      await MyPrefs.init().then((prefs) async { prefs!;

        final _user = MyPrefs.getUser(prefs: prefs) ?? '{}';
        setState(() { user = jsonDecode(_user); });
        print(user);
        print(launchLoading);

      });
      
    });
  }
>>>>>>> Stashed changes
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
<<<<<<< Updated upstream
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
=======

    futureLocale = getFutureLocale(context);

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; print('profileEdited: $profileEdited');
>>>>>>> Stashed changes

    final userMap = jsonDecode(args.user); user = Map.from(userMap);
    
    DateTime createdAtParsed = DateTime.parse(user['createdAt']).add(Duration(hours: int.parse('8')));
    String createdAt = monthYear!.format(createdAtParsed);
    String createdAtDetail = dateTime!.format(createdAtParsed);

    final Localizations = AppLocalizations.of(context);
    if (Localizations == null) {
      print("localizations is null");
    }
<<<<<<< Updated upstream

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ProfilePage.routeName);

    return PopScope(
      canPop: true,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : Scaffold(
        appBar: MyWidgets.MyAppBar(context, isDarkMode, Localizations!.profile, appVersion: appVersion),
        
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
                                    Text('${Localizations.joined} ${createdAt}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),),                                    
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
                                  Text(Localizations.information, style: Theme.of(context).textTheme.titleMedium!.copyWith( color: Theme.of(context).colorScheme.onSecondary),),
                                  SizedBox(height: 12,),
                                
                                  ProfileWidgets.InfoTile(context, Localizations.username, subtitle: user['id']),
                                  ProfileWidgets.InfoTile(context, Localizations.fullname, subtitle: user['name']),
                                  ProfileWidgets.InfoTile(context, Localizations.mobile, subtitle: user['mobile']),
                                  ProfileWidgets.InfoTile(context, Localizations.email, subtitle: user['email']),
                                
                                  SizedBox(height: 16,),
                                  
                                  ProfileWidgets.InfoTile(context, Localizations.shipping_address, subtitle:
                                    '${user['address1']}, ${user['address2']},\n${user['address3']}, ${user['postcode']},\n${user['city']}, ${user['state']}'
                                  ),
                                
                                  SizedBox(height: 16,),
                                  
                                  ProfileWidgets.InfoTile(context, Localizations.join_at, subtitle: createdAtDetail),
                                
                                  SizedBox(height: 12,),
                                  Divider( color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),),
                                ],),

                                MyWidgets.MyTileButton(context, Localizations.log_out, icon: FontAwesomeIcons.signOut, color: Theme.of(context).primaryColor, iconSize: MySize.Width(context, 0.04),
                                  onPressed: () async {
                                    await showDialog(context: context, builder: (context) => PopUps.Default(context, Localizations.log_out,
                                      subtitle: Localizations.you_are_logging_out, warning:Localizations.progress_not_saved ),).then((res) async {
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
=======
    DateTime createdAtParsed = DateTime.parse(user['created_at']).add(Duration(hours: int.parse('8'))); print(user['created_at']);
    setState(() => createdAt = monthYear2!.format(createdAtParsed) );
    print('created:$createdAt');
    setState(() => createdAtDetail = dateTime!.format(createdAtParsed) );

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ProfilePage.routeName);

    return FutureBuilder<AppLocalizations?>(
      future: futureLocale,
      builder: (context, parentSnapshot) {
       if (parentSnapshot.connectionState == ConnectionState.waiting) {
        return MyWidgets.MyLoading2(context, isDarkMode);
      } else if (parentSnapshot.hasError) {
        return MyWidgets.MyErrorPage(context, isDarkMode);
      } else if (parentSnapshot.hasData) {
        final Localizations = parentSnapshot.data!;
      
       return PopScope(
        onPopInvoked: (didPop) async {
          if (didPop) return;
      
          Navigator.pop(context, userUpdated);
        },
        canPop: !userUpdated,
        child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: MyWidgets.MyAppBar(context, isDarkMode, Localizations.profile, appVersion: appVersion, refresh: userUpdated),
          
          body:
      
          FutureBuilder<bool?>(
            initialData: false,
            future: isRefresh,
            builder: (context, snapshot) { if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return MyWidgets.MyErrorPage(context, isDarkMode);
              } else if (snapshot.hasData) {isRefresing = snapshot.data!; print('snapshot has data: $isRefresing');
      
                if (isRefresing) {refreshPage(context, setState);}
      
                return Stack(
                  children: [
                    CustomMaterialIndicator(
                      edgeOffset: 10, backgroundColor: Colors.transparent, elevation: 0,
                      onRefresh: () async { setState(() { isLoading = true; }); await refreshPage(context, setState).whenComplete(() => setState(() { isLoading = false; })); },
                      
                      // trigger: IndicatorTrigger.trailingEdge,
                      // triggerMode: IndicatorTriggerMode.anywhere,
                
                      indicatorBuilder: (context, controller) => Icon(FontAwesomeIcons.rotateRight, size: MySize.Width(context, 0.08),),
                      child: SizedBox.expand(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths, refresh: userUpdated)),
                                
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
                                                Text('${Localizations.joined} ${createdAt}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),),
                                                MyWidgets.MyTileButton(context, Localizations.edit, icon: FontAwesomeIcons.pen, iconSize: MySize.Height(context, 0.01), buttonHeight: MySize.Height(context, 0.03),
                                                  onPressed: () async => await myPushNamed( context, setState, ProfileEditPage.routeName ,
                                                    arguments: MyArguments(token, prevPath: currentPath, user: jsonEncode(user))).then((res) { print("res: $res");
                                                      if (res == true) {
                                                        setState(() => userUpdated = res as bool);
                                                        print("profile.dart :: userUpdated: $userUpdated");
                                                      }
                                                    })),
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
                                              Text(Localizations.information, style: Theme.of(context).textTheme.titleMedium!.copyWith( color: Theme.of(context).colorScheme.onSecondary),),
                                              SizedBox(height: 12,),
                                            
                                              ProfileWidgets.InfoTile(context, Localizations.username, subtitle: user['id']),
                                              ProfileWidgets.InfoTile(context, Localizations.fullname, subtitle: user['name']),
                                              ProfileWidgets.InfoTile(context, Localizations.mobile, subtitle: user['mobile']),
                                              ProfileWidgets.InfoTile(context, Localizations.email, subtitle: user['email']),
                                            
                                              SizedBox(height: 16,),
                                              
                                              ProfileWidgets.InfoTile(context,Localizations.outlet , subtitle: listAllOutlets(outlets: outlets)),
                                
                                              SizedBox(height: 16,),
                                              
                                              ProfileWidgets.InfoTile(context, Localizations.shipping_address, subtitle:
                                                '${user['address1']}, ${user['address2']},\n${user['address3']}, ${user['postcode']},\n${user['city']}, ${user['state']}'
                                              ),
                                            
                                              SizedBox(height: 16,),
                                              
                                              ProfileWidgets.InfoTile(context, Localizations.join_at, subtitle: createdAtDetail),
                                            
                                              SizedBox(height: 12,),
                                              Divider( color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),),
                                            ],)),
                                
                                            MyWidgets.MyTileButton(context,Localizations.log_out, icon: FontAwesomeIcons.signOut, color: Theme.of(context).primaryColor, iconSize: MySize.Width(context, 0.04),
                                              onPressed: () async {
                                                await showDialog(context: context, builder: (context) => PopUps.Default(context, Localizations.logging_out,
                                                  subtitle: Localizations.you_are_logging_out, warning: Localizations.progress_not_saved),).then((res) async {
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
                    
                    MyWidgets.MyLoading(context, (isLoading || isRefresing), isDarkMode)
                  ]
                );
              } else {
                return MyWidgets.MyLoading2(context, isDarkMode);
              }} else { 
                return MyWidgets.MyLoading2(context, isDarkMode);
              }
              
            }
          )
        ))
      );
   
      }else {
      // This case handles when parentSnapshot.hasData is false and it's not in a loading state
      return MyWidgets.MyErrorPage(context, isDarkMode);
    }
      }
      
>>>>>>> Stashed changes
    );
  }
}