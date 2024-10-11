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

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: CartPage.routeName);

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
                                    // Expanded(
                                    //   child: Text(
                                    //     'Lot 2R-37, Jalan Yap Ah Shak 2C, Rantau Abang 71464, Bentong Pahang Malaysia',
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .titleMedium!
                                    //         .copyWith(
                                    //             color: Theme.of(context)
                                    //                 .colorScheme
                                    //                 .onPrimaryContainer,
                                    //             fontWeight: FontWeight.w400),
                                    //     maxLines:
                                    //         2, // Allow the text to wrap to a second line if needed
                                    //     overflow: TextOverflow
                                    //         .ellipsis, // Clips the text if it exceeds the max lines
                                    //   ),
                                    // ),

                                    SizedBox(
                                      width: 5,
                                    ),
                                    // Icon(Icons.arrow_forward_ios, size: 15),
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
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // Example data for each item (replace with real data)
                                  String imagePath = 'assets/images_examples/headphone.jpeg';
                                  String productName = 'Headphone X200';
                                  String brandName = 'Logitech';
                                  String points = '500 PTS';
                                  int count = 1;
                                  // isLoading = true;                                                                    
                                  return isLoading
                                  ?CartWidget.buildProductListItemShimmer(context: context, imageWidth: 100, imageHeight:100,)                                  
                                  :CartWidget.buildProductListItem(
                                    context,
                                    imagePath: imagePath,
                                    productName: productName,
                                    brandName: brandName,
                                    points: points,
                                    count: count,
                                    onAddPressed: () {
                                      setState(() {
                                        // Increment logic here
                                      });
                                    },
                                    onRemovePressed: () {
                                      setState(() {
                                        // Decrement logic here
                                      });
                                    },
                                    onClearPressed: () {
                                      // Clear action
                                    },
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
                                      CartWidget.MyButton1(
                                          context, 150, 'Redeem', () {}),
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
