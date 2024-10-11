import 'dart:convert';

import 'package:bat_loyalty_program_app/page_manageoutlet/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_manageoutlet/layout/manageoutlet_add.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ManageOutletPage extends StatefulWidget {
  const ManageOutletPage({super.key});

  static const routeName = '/manage_outlet';

  @override
  State<ManageOutletPage> createState() => _ManageOutletPageState();
}

class _ManageOutletPageState extends State<ManageOutletPage> with ManageOutletComponents, MyComponents{
  
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
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context); await setAccountImages();
    
    dateTime = DateFormat('dd/MM/yyyy').add_Hms();
  }

  @override
  Future<void> refreshPage(BuildContext context, void Function(void Function() fn) setState) async {
    await super.refreshPage(context, setState).whenComplete(() async {

      await MyPrefs.init().then((prefs) async { prefs!;

        final _user = MyPrefs.getUser(prefs: prefs) ?? '{}';
        setState(() { user = jsonDecode(_user); });

        final _outlets = MyPrefs.getOutlets(prefs: prefs) ?? '{}';
        setState(() { outlets = jsonDecode(_outlets); });

      });
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context);
    
    if (launchLoading) {
      final userMap = jsonDecode(args.user); user = Map.from(userMap); print('user: $user');
      final outletsMap = jsonDecode(args.outlets); outlets = Map.from(outletsMap);
      
      setActiveCount(outlets); print("outlesMap init: $outlets");
    }
    
    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ManageOutletPage.routeName);

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        Navigator.pop(context, outletListEditted);
      },
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyWidgets.MyAppBar(context, isDarkMode, Localizations!.manage_outlet, appVersion: appVersion, canPop: canPop, refresh: outletListEditted, popDialog: popDialog),
        
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths, refresh: outletListEditted,)),
                        
                        GradientSearchBar( pageSetState: setState,
                          applyFilters: applyFilters,
                          filtersApplied: filtersApplied,
                          datas: [ accounts ],
                          
                          controller: searchController,
                          focusNode: searchFocusNode,

                          items: [
                            GradientSearchBar.filterMenu(context, title: 'Company', data: accounts, single: false,
                              applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState, first: true),
                          ],
                          onSearch: () {},
                        ),

                        Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${Localizations.active_outlets}: ${activeCount}', style: Theme.of(context).textTheme.bodyMedium),
                                  Text('${Localizations.total_outlets}: ${outlets['count']}', style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            Padding( padding: const EdgeInsets.only(bottom: 8.0), child:
                              MyWidgets.MySwitch(context, active: showInactiveOutlets, activeText:Localizations.show_past_outlets, inactiveText: Localizations.show_past_outlets,
                              activeColor: Theme.of(context).colorScheme.secondary,
                              inactiveColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                onChanged: (_value) { setState(() => showInactiveOutlets = _value); }
                              )),
                          ],
                        ),

                        Expanded(
                          child: MyWidgets.MyScrollBar1( context, controller: mainScrollController,
                            child: ListView.builder( controller: mainScrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: outlets['count'] + 1,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {

                                if (index != outlets['count']) {

                                  Map<dynamic, dynamic> outlet = outlets['rows'][index]; print(index); print("outlets['count']: ${outlets['count']}");
                                  bool show = false;

                                  if (outlet['active']) { show = true; }
                                  else if (!outlet['active'] && showInactiveOutlets) { show = true; }
                                  else { show = false; }

                                  if (show) {
                                  
                                    String imagePath = 'assets/account_images/company.png';
                                    String address = 
                                      '${outlet['address1']}, ${outlet['address2']}, ${outlet['address3']},\n${outlet['postcode']}, ${outlet['city']}, ${outlet['state']}';

                                    for (var i = 0; i < accountImages.length; i++) {
                                      if (outlet['account_id'].toString().toLowerCase() == accountImages[i]['name']) {
                                        imagePath = 'assets/account_images/${outlet['account_id'].toString().toLowerCase()}.png'; i = accountImages.length;
                                      } else {
                                        imagePath = 'assets/account_images/company.png';
                                      }
                                    }
                                    
                                    return Padding( padding: const EdgeInsets.only(bottom: 8.0), child: Stack(
                                      children: [
                                        // switch button
                                        Opacity( opacity: outlet['active'] ? 1 : 0.5, 
                                        child: Card(
                                          elevation: 2,
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12.0), 
                                            side: BorderSide(color: Theme.of(context).colorScheme.primary)
                                          ),
                                        
                                          child: Padding( padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // first row
                                              Padding( padding: const EdgeInsets.only(bottom: 8.0), child: Row(
                                                children: [
                                                  Padding( padding: const EdgeInsets.only(right: 8.0), child: SizedBox(
                                                    width: MySize.Width(context, 0.15),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Image.asset( imagePath ),
                                                    ),
                                                  )),
                                        
                                                  Column( crossAxisAlignment: CrossAxisAlignment.start, children:[
                                                    Text(outlet['outlet_id'], style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                                                    Text(outlet['name'], style: Theme.of(context).textTheme.bodyMedium),
                                                  ]),
                                                ],
                                              )),
                                        
                                              // address
                                              Padding( padding: const EdgeInsets.only(bottom: 62.0),
                                                child: Opacity( opacity: 0.5, child: Text(address, style: Theme.of(context).textTheme.bodySmall))),
                                            ],
                                          )),
                                        )),
                                        
                                        Positioned( bottom: 12, right: 12,
                                          child: Padding( padding: const EdgeInsets.only(bottom: 8.0), child:
                                            MyWidgets.MySwitch(context, active: outlet['active'], activeText: Localizations.status_assigned, inactiveText: Localizations.status_not_assigned,
                                              onChanged: (_value) async {
                                                if (activeCount == 1 && outlet['active'] == true) {
                                                  FloatingSnackBar(message: Localizations.only_active_outlet, context: context);
                                                } else {
                                                
                                                  setState(() => isLoading = true);
                                                  String subtitle;

                                                  if (outlet['active']) {
                                                    subtitle = Localizations.deactivating_status;
                                                  } else {
                                                    subtitle = Localizations.reactivating_status;
                                                  }
                                                  
                                                  await showDialog(context: context, builder: (context) => PopUps.Default(context, Localizations.changing_status,
                                                    subtitle: subtitle, ),).then((res) async {
                                                      if (res ?? false) {
                                                        updateActiveData.clear();
                                                        setState(() => outlet['active'] = _value);

                                                        updateActiveData.addEntries({ "user_id": user['id'] }.entries);
                                                        updateActiveData.addEntries({ "outlet_id": outlet['outlet_id'] }.entries);
                                                        updateActiveData.addEntries({ "active": outlet['active'] }.entries);

                                                        await Api.user_account_update_active(context, domainName, token, updateActiveData: updateActiveData).then((statusCode) async {
                                                          print({ statusCode });

                                                          if (statusCode == 200) {
                                                            await MyPrefs.init().then((prefs) async {
                                                              prefs!;
                                                              
                                                              final String cachedUser = MyPrefs.getUser(prefs: prefs)!;
                                                              final Map<String, dynamic> mappedUser = jsonDecode(cachedUser);
                                                              final String password = mappedUser['password'];
                                                              
                                                              await Api.user_self(domainName, token, password: password).then((res) async {

                                                                if (res == 200) {

                                                                  // success
                                                                  FloatingSnackBar(message:  Localizations.successful_status_change, context: context);
                                                                  await refreshPage(context, setState);
                                                                  setState(() => outletListEditted = true);
                                                                  setState(() => canPop = false);

                                                                } else {
                                                                  FloatingSnackBar(message: '${Localizations.something_went_wrong} ${statusCode}.', context: context);
                                                                }

                                                                setState(() { isLoading = false; });
                                                              });

                                                              setState(() { isLoading = false; });
                                                            });

                                                          } else {
                                                            FloatingSnackBar(message: 'Something went wrong. Error ${statusCode}.', context: context);
                                                          }
                                                          
                                                          setState(() { isLoading = false; });
                                                        });
                                                        
                                                        setActiveCount(outlets);
                                                        updateActiveData.clear();
                                                      }
                                                      
                                                      setState(() => isLoading = false);
                                                    });
                                                }
                                              }
                                            )),
                                        ),
                                      ],
                                    ));
                                  } else {
                                    return SizedBox();
                                  }

                                } else {

                                  return InkWell(
                                    onTap: () async => myPushNamed( context, setState, ManageOutletAddPage.routeName ,
                                      arguments: MyArguments(token, prevPath: currentPath, user: jsonEncode(user), outlets: jsonEncode(outlets))).then((res) { print("res: $res");
                                        if (res == true) {
                                          setState(() => outletListEditted = res as bool);
                                          setState(() => canPop = !outletListEditted);
                                        }
                                      }),
                                    
                                    child: Padding( padding: const EdgeInsets.only(bottom: 8.0), child: Card(
                                      elevation: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    
                                      child: Padding( padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), child: Row( mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.add, color: Theme.of(context).primaryColor,),
                                          Text(Localizations.add_new_outlets , style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor),)
                                        ]
                                      ))
                                    )),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                            
                        // Expanded(child: Center(child: Text('ManageOutletPage'))),
                      ],
                    ),
                  ),

                  MyWidgets.MyLoading(context, (isLoading || isRefresing), isDarkMode)
                ],
              );
            } else {
              return MyWidgets.MyLoading2(context, isDarkMode);
            }} else { 
              return MyWidgets.MyLoading2(context, isDarkMode);
            }
            
          }
        ))
    ));
  }
}