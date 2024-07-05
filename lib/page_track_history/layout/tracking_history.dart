import 'dart:convert';
import 'package:bat_loyalty_program_app/page_track_history/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class trackingHistoryPage extends StatefulWidget {
  const trackingHistoryPage({super.key});

  static const routeName = '/tracking_history';

  @override
  State<trackingHistoryPage> createState() => _trackingHistoryPageState();
}

class _trackingHistoryPageState extends State<trackingHistoryPage>
    with TrackComponents {
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
    final List<String> paths = ['Home', 'Tracking History'];
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
        child: launchLoading
            ? MyWidgets.MyLoading2(context, isDarkMode)
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Text(
                    'Tracking History',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  actions: [
                    Stack(
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
                                      fontWeight: FontWeight.normal,
                                      fontSize: 8),
                            ))
                      ],
                    ),
                  ],
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
                            // show page path
                            Breadcrumb(paths: paths),

                            SizedBox(
                              height: 12,
                            ),

                            // search bar
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GradientTextField(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).colorScheme.tertiary,
                                    Theme.of(context).colorScheme.onSecondary,
                                  ]),
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
                                      borderRadius: BorderRadius.circular(24.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 20.0),
                                  )
                                ),
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
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          border: Border.all(
                                              color: const Color.fromARGB(255, 88, 65, 65), width: 1),
                                        ),
                                        child: Text("image")
                                      ),
                                    ],
                                  ),
                                  // Column for product details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'productName',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'productDescription',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'productDate',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Column to show product points
                                  Column(
                                    children: [
                                      Text(
                                        'Points: 1000',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
