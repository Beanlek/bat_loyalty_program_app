import 'dart:convert';
// import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/page_track_history/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_track_history/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackingHistoryPage extends StatefulWidget {
  const TrackingHistoryPage({super.key});

  static const routeName = '/tracking_history';

  @override
  State<TrackingHistoryPage> createState() => _TrackingHistoryPageState();
}

class _TrackingHistoryPageState extends State<TrackingHistoryPage>
    with TrackComponents, MyComponents {
  
  @override
  void initState() {
    super.initState();
    initParam(context).whenComplete(() {
      setState(() {
        launchLoading = false;
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> initParam(BuildContext context,
      {key, bool needToken = true}) async {
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
    final Localizations = AppLocalizations.of(context)!;

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: TrackingHistoryPage.routeName);

    return PopScope(
        child: launchLoading
            ? MyWidgets.MyLoading2(context, isDarkMode)
            : GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                  appBar: MyWidgets.MyAppBar(
                      context, isDarkMode, Localizations.tracking_history,
                      appVersion: appVersion),
                  body: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                // breadcrumb path
                                child: Breadcrumb(paths: paths)),

                            GradientSearchBar(
                              pageSetState: setState,
                              applyFilters: applyFilters,
                              filtersApplied: filtersApplied,
                              datas: [dateMap],
                              controller: searchController,
                              focusNode: searchFocusNode,
                              items: [
                                GradientSearchBar.filterMenu(context,
                                    title: 'Date',
                                    data: dateMap,
                                    single: true,
                                    applyFilters: applyFilters,
                                    clearFilters: clearFilters,
                                    pageSetState: setState,
                                    first: true),
                              ],
                              onSearch: () {},
                            ),

                            // product detail card
                            // redeemed point, awb_no -> table redemption
                            //name , brand, image -> table product

                            SizedBox(
                              width: 12,
                            ),
                          
                               // product detail card
                              
                                                
                            TrackWidget.myProductItem(context,
                            '2024-10-08',
                            products: products)              
                         
                          ],
                        ),
                      ),
                      MyWidgets.MyLoading(context, isLoading, isDarkMode)
                    ],
                  ),
                )));
  }
}
