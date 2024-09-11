import 'dart:convert';
import 'package:bat_loyalty_program_app/page_track_history/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrackingHistoryPage extends StatefulWidget {
  const TrackingHistoryPage({super.key});

  static const routeName = '/tracking_history';

  @override
  State<TrackingHistoryPage> createState() => _TrackingHistoryPageState();
}

class _TrackingHistoryPageState extends State<TrackingHistoryPage>
    with TrackComponents , MyComponents{

  int loyaltyPoints = 0;

  @override
  void initState() {
    super.initState();
    initParam(context).whenComplete(() { setState(() { launchLoading = false; }); });
  }

  @override
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context);
    
    await MyPrefs.init().then((prefs) {
      prefs!;
      final _user = MyPrefs.getUser(prefs: prefs) ?? 'N/A';
      user = jsonDecode(_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: TrackingHistoryPage.routeName);

    return PopScope(
        child: launchLoading
            ? MyWidgets.MyLoading2(context, isDarkMode)
            : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
                appBar: MyWidgets.MyAppBar(context, isDarkMode, 'Tracking History', appVersion: appVersion),

                body: 

                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), child: Breadcrumb(paths: paths)),

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                        
                                GradientSearchBar( pageSetState: setState,
                                  applyFilters: applyFilters,
                                  filtersApplied: filtersApplied,
                                  datas: [ dateMap ],
                                    
                                  controller: searchController,
                                  focusNode: searchFocusNode,
                                  
                                  items: [
                                    GradientSearchBar.filterMenu(context, title: 'Date', data: dateMap, single: true,
                                      applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState, first: true),
                                  ],
                                  onSearch: () {},
                                ),
                                
                                SizedBox(
                                  height: 12,
                                ),
                                        
                                // product detail card
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      // Column to show image
                                      Column(
                                        children: [
                                          //Image.asset(imagePath),
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(23),
                                              child: Image.asset(
                                                'assets/images_examples/headphone.jpeg', // Replace with your image path
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                        
                                      SizedBox(
                                        width: 12,
                                      ),
                                        
                                      // Column for product details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //title
                                            Text(
                                              'Headphone',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        
                                            SizedBox(
                                              height: 8,
                                            ),
                                        
                                            // copy code
                                            Row(children: [
                                              Icon(
                                                FontAwesomeIcons.copy,
                                                // Icons.copy_rounded,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              
                                              Expanded(
                                                child: Text(
                                                '1A2B 3C1A 2B3C 1A2B',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            ]),
                                        
                                            SizedBox(
                                              height: 8,
                                            ),
                                        
                                            // redeemed
                                            Text(
                                              'Redeemed On',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                            ),
                                        
                                            // date
                                            Text(
                                              '5/7/2024 3:00 PM',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                     
                                     SizedBox(width: 12,),
                                      // Column to show product points
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              FaIcon(FontAwesomeIcons.database,
                                                  color: Colors.red),
                                              //Icon(Icons.price_check, color: Colors.red),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '1200 Pts',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                        
                                 
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    MyWidgets.MyLoading(context, isLoading, isDarkMode)
                  ],
                ),
              )));
  }
}
