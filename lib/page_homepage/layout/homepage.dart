import 'dart:convert';
import 'package:bat_loyalty_program_app/page_homepage/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile.dart';
import 'package:bat_loyalty_program_app/page_track_history/layout/tracking_history.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/page_homepage/widget/local_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  static const routeName = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with HomeComponents {
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
      canPop: false,
      child: launchLoading
          ? MyWidgets.MyLoading2(context, isDarkMode)
          : Scaffold(
              key: scaffoldKey,
              appBar: HomeWidgets.MyAppBar(
                context,
                isDarkMode,
                appVersion: appVersion,
                scaffoldKey: scaffoldKey,
                onTap: () => Navigator.pushNamed(
                  context,
                  ProfilePage.routeName,
                  arguments: MyArguments(token, user: jsonEncode(user)),
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
                                                    trackingHistoryPage
                                                        .routeName);
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
                                // title
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
                                GradientSearchBar(
                                  controller: searchController,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [

                                      Theme.of(context).colorScheme.tertiary,
                                      Theme.of(context).colorScheme.onPrimary,
                                    ],
                                  ),
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
                                    itemBuilder: (BuildContext context, int i) {
                                      return ProductCard(
                                          imageUrl: Image.asset(
                                            'assets/images_examples/headphone.jpeg',
                                          ),
                                          title: "Headphone",
                                          points: 1000,
                                          onLoveIconTap: () {},
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ],
                                          ));
                                    },
                                  ),
                                ),

                                // floating button
                                HomeWidgets.MyFloatingButton(
                                  context,
                                  60,
                                  () {},
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
              drawer: HomeWidgets.MyDrawer(context, isDarkMode,
                  appVersion: appVersion,
                  domainName: domainName,
                  items: [
                    HomeWidgets.Item(context,
                        icon: FontAwesomeIcons.userAlt,
                        label: 'Profile',
                        onTap: () => Navigator.pushNamed(
                            context, ProfilePage.routeName,
                            arguments:
                                MyArguments(token, user: jsonEncode(user)))),
                    Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .onTertiary
                          .withOpacity(0.5),
                    ),
                    HomeWidgets.Item(context,
                        icon: FontAwesomeIcons.history,
                        label: 'Tracking History',
                        onTap: () => Navigator.pushNamed(
                              context,
                              trackingHistoryPage.routeName,
                            )),
                    HomeWidgets.Item(context,
                        icon: FontAwesomeIcons.images,
                        label: 'Images Status',
                        onTap: () => false),
                    Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .onTertiary
                          .withOpacity(0.5),
                    ),
                    HomeWidgets.Item(context,
                        icon: FontAwesomeIcons.gear,
                        label: 'Settings',
                        onTap: () => false),
                    HomeWidgets.Item(context,
                        icon: FontAwesomeIcons.signOut,
                        label: 'Log Out', onTap: () async {
                      await Api.logout().whenComplete(() =>
                          Navigator.pushNamed(context, LoginPage.routeName));
                    }),
                  ])),
    );
  }
}
