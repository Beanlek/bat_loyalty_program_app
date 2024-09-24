import 'dart:convert';
// import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/page_track_history/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_track_history/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
>>>>>>> Stashed changes
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackingHistoryPage extends StatefulWidget {
  const TrackingHistoryPage({super.key});

  static const routeName = '/tracking_history';

  @override
  State<TrackingHistoryPage> createState() => _TrackingHistoryPageState();
}

class _TrackingHistoryPageState extends State<TrackingHistoryPage>
    with TrackComponents, MyComponents {
  int loyaltyPoints = 0;
  bool _showFilterOptions = false;

  @override
  void initState() {
    initParam().whenComplete(() {
      setState(() {
        launchLoading = false;
      });
    });
    super.initState();
  }

  void _toggleFilterOptions() {
    setState(() {
      _showFilterOptions = !_showFilterOptions;
    });
  }

  @override
  Future<void> initParam() async {
    super.initParam();

    await MyPrefs.init().then((prefs) {
      prefs!;
      final _user = MyPrefs.getUser(prefs: prefs) ?? 'N/A';
      user = jsonDecode(_user);
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context);

    final Localizations = AppLocalizations.of(context);
    if (Localizations == null) {
      print("localizations is null");
    }

    if (!launchLoading)setPath(prevPath: args.prevPath, routeName: TrackingHistoryPage.routeName);

    return PopScope(
        child: launchLoading
            ? MyWidgets.MyLoading2(context, isDarkMode)
            : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
<<<<<<< Updated upstream
                appBar: MyWidgets.MyAppBar(
                    context, isDarkMode,Localizations!.tracking_history,
                    appVersion: appVersion),
                body: Stack(
=======
                appBar: MyWidgets.MyAppBar(context, isDarkMode, Localizations!.tracking_history, appVersion: appVersion),

                body: 

                Stack(
>>>>>>> Stashed changes
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
                            controller: searchController,
                            onSearchChanged: (value) {},
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .tertiary,
                                Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                              ],
                            ),
                            onFilterPressed: _toggleFilterOptions,
                            showFilterOptions: _showFilterOptions,
                          ),
                                
                          // product detail card
                          // redeemed point, awb_no -> table redemption
                          //name , brand, image -> table product
                                
                          Expanded(
                            child: MyWidgets.MyScrollBar1(
                              context,
                              controller: scrollController,
                              thumbVisibility: true,
                              child: ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                physics:
                                    AlwaysScrollableScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final date = products.keys
                                      .elementAt(
                                          index); // Get the date
                                  List<Map<dynamic, dynamic>>
                                      productList = products[date];
                                  
                                  return TrackWidget.myProductItem(
                                      context, date,
                                      products: productList);
                                },
                              ),
                                                 
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
