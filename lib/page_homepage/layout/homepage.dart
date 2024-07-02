import 'dart:convert';
import 'package:bat_loyalty_program_app/page_homepage/component/home_components.dart';
import 'package:bat_loyalty_program_app/page_track_history/layout/tracking_history.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/services/theme.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  static const routeName = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with HomeComponents{

// move in component 
  List<String> products = [
    "Product 1",
    "Product 2",
    "Product 3",

  ];
  Future<List<dynamic>>? futureProduct;

  final FocusNode searchFocusNode = FocusNode();

  bool launchLoading = true;

  int loyaltyPoints = 0;



  @override
  void initState() {

    loyaltyPoints = 2000;
    initParam().whenComplete(() {
      setState(() {
        launchLoading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  late String domainName;
  late String appVersion;
  late String deviceID;
  late Map<String, dynamic> user = {};

  Future<void> initParam() async {
    await MyPrefs.init().then((prefs) {
      prefs!;

      domainName = MyPrefs.getDomainName(prefs: prefs)!;
      appVersion = MyPrefs.getAppVersion(prefs: prefs) ?? 'N/A';
      deviceID = MyPrefs.getDeviceID(prefs: prefs) ?? 'N/A';
      final _user = MyPrefs.getUser(prefs: prefs) ?? 'N/A';
      user = jsonDecode(_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      child: launchLoading
          ? MyWidgets.MyLoading2(context, isDarkMode)
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.language,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                    child: CircleAvatar(
                      backgroundColor: MyColors.greyImran2,
                      child: Icon(
                        Icons.person,
                        color: MyColors.greyImran,
                      ),
                    ),
                  ),
                ],
                title: Stack(
                  children: [
                    SizedBox(
                      width: MySize.Width(context, 0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.asset(
                          isDarkMode
                              ? 'assets/logos/logo_bat_v002.png'
                              : 'assets/logos/logo_bat.png',
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Text(
                          'Version 0.0.1',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 8),
                        ))
                  ],
                ),
              ),
              body: Stack(
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
                                  Text(
                                    'Loyalty Points',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['id']!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.normal),
                                          ),
                                          Text.rich(TextSpan(
                                              text: loyaltyPoints.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outlineVariant),
                                              children: [
                                                TextSpan(
                                                    text: ' pts',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outlineVariant))
                                              ]))
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            child: TextButton.icon(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    trackingHistoryPage.routeName);
                                              },
                                              label: Text('Tracking History',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary)),
                                              icon: Icon(Icons.history,
                                                  size: MySize.Width(
                                                      context, 0.05),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  // color: IconTheme.of(context).color
                                                  ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                            child: TextButton.icon(
                                              onPressed: () {},
                                              label: Text('Images Status',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary)),
                                              icon: Icon(Icons.image,
                                                  size: MySize.Width(
                                                      context, 0.05),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  )),
                                ],
                              )),
                          SizedBox(
                            height: 12,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Catalogue',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),

                                SizedBox(
                                  height: 12,
                                ),

                                // search bar
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.search),
                                          onPressed: () {},
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.tune_rounded),
                                          onPressed: () {},
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 20.0),
                                      )),
                                ),

                                SizedBox(
                                  height: 12,
                                ),

                                // product list
                                Expanded(
                                  child: GridView.builder(
                                    padding: const EdgeInsets.all(15),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // row
                                      childAspectRatio: 2.5 / 4,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20, 
                                    ),
                                    itemCount: 6,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int i) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                        ),
                                        
                                      );
                                    },
                                  ),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
