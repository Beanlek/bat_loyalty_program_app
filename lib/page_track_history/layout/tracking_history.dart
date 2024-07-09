import 'dart:convert';
import 'package:bat_loyalty_program_app/page_track_history/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                                  ? 'assets/logos/bat-logo-white.png'
                                  : 'assets/logos/bat-logo-default.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                body: Expanded(
                  child: MyWidgets.MyScroll1(
                    context,
                    controller: scrollController,
                    child: Stack(
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

                                GradientSearchBar(
                                  controller: searchController,
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.tertiary,
                                      Theme.of(context).colorScheme.onPrimary,
                                    ],
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
                                              GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text:"1A2B 3C1A 2B3C 1A2B"));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Copied to clipboard')),
                                                  );
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons.copy,
                                                  // Icons.copy_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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

                                      SizedBox(
                                        width: 12,
                                      ),
                                      // Column to show product points
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 2,
                                                color: Colors.red,
                                              ),

                                              SizedBox(
                                                width: 7,
                                              ),

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
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
