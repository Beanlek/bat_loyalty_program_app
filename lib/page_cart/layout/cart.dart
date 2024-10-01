import 'package:bat_loyalty_program_app/page_cart/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const routeName = '/cart';

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> with MyComponents {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Localizations = AppLocalizations.of(context)!;

    if (!launchLoading)setPath(prevPath: args.prevPath, routeName: CartPage.routeName);

    return PopScope(
        canPop: canPop,
        child: launchLoading
            ? MyWidgets.MyLoading2(context, isDarkMode)
            : GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                  appBar: MyWidgets.MyAppBar(
                    context,
                    isDarkMode,
                    "Cart",
                    appVersion: appVersion,
                  ),
                  body: Stack(children: [
                    Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            child: Column(
                              children: [
                                Breadcrumb(paths: paths),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 20),
                                    const SizedBox(width: 5),
                                    Text('Shipping Address',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Lot 2R-37, Jalan Yap Ah Shak 2C, Rantau Abang 71464, Bentong Pahang Malaysia',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                                fontWeight: FontWeight.w400),
                                        maxLines:
                                            2, // Allow the text to wrap to a second line if needed
                                        overflow: TextOverflow
                                            .ellipsis, // Clips the text if it exceeds the max lines
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 15),
                                  ],
                                )
                              ],
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: MyWidgets.MyScrollBar1(
                              context,
                              controller: mainScrollController,
                              child: ListView.builder(
                                controller: mainScrollController,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: 10,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
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
                                              Text('Headphone X200',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600)),
                                              // brand
                                              Text(
                                                'Logitech',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              // points
                                              Text(' 500 PTS',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600)),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          width: 10,
                                        ),
                                        // count button
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    // + button
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.add_circle),
                                                      onPressed:
                                                          () {}, // Calls the increment method from the mixin
                                                      iconSize: 30,
                                                    ),
                                                    // count
                                                    Text(
                                                      '1',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),

                                                    // - button
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.remove_circle),
                                                      onPressed:
                                                          () {}, // Calls the decrement method from the mixin
                                                      iconSize: 30,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                       
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Total Points',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '1500 PTS',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      CartWidget.MyButton1(context, 150, 'Redeem', () {}),                                  
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                  ]),
                ),
              ));
  }
}
