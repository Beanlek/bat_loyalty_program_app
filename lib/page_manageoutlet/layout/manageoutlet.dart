import 'dart:convert';

import 'package:bat_loyalty_program_app/page_manageoutlet/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageOutletPage extends StatefulWidget {
  const ManageOutletPage({super.key});

  static const routeName = '/manage_outlet';

  @override
  State<ManageOutletPage> createState() => _ManageOutletPageState();
}

class _ManageOutletPageState extends State<ManageOutletPage> with ManageOutletComponents, MyComponents{
  
  @override
  void initState() {
    initParam(context, needToken: false).whenComplete(() { setState(() { launchLoading = false; }); });
    
    super.initState();
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
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final outletsMap = jsonDecode(args.outlets); outlets = Map.from(outletsMap); print("outlesMap init");
    
    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ManageOutletPage.routeName);

    return PopScope(
      canPop: canPop,
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyWidgets.MyAppBar(context, isDarkMode, 'Manage Outlets', appVersion: appVersion),
        
        body:
        
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths)),
                  
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
                        child: Text('Total Outlets: ${outlets['rows'].length}', style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding( padding: const EdgeInsets.only(bottom: 8.0), child:
                        MyWidgets.MySwitch(context, active: showInactiveOutlets, activeText: 'Show Past Outlets', inactiveText: 'Show Past Outlets',
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
                        itemCount: outlets['rows'].length + 1,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == outlets['rows'].length) {
                            return InkWell(
                              onTap: () {},
                              
                              child: Padding( padding: const EdgeInsets.only(bottom: 8.0), child: Card(
                                elevation: 2,
                                color: Theme.of(context).colorScheme.secondary,
                              
                                child: Padding( padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), child: Row( mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.add, color: Theme.of(context).primaryColor,),
                                    Text('Add new outlet', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor),)
                                  ]
                                ))
                              )),
                            );
                          } else {
                            Map<dynamic, dynamic> outlet = outlets['rows'][index];
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
                                Opacity( opacity: activeTemp ? 1 : 0.5, child: Card(
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
                                    MyWidgets.MySwitch(context, active: activeTemp, activeText: 'Status: Employee', inactiveText: 'Status: Not a employee',
                                      onChanged: (_value) { setState(() => activeTemp = _value); }
                                    )),
                                ),
                              ],
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                      
                  // Expanded(child: Center(child: Text('ManageOutletPage'))),
                ],
              ),
            ),

            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ],
        ),),
    ));
  }
}