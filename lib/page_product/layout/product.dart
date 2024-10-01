import 'package:bat_loyalty_program_app/page_cart/layout/cart.dart';
import 'package:bat_loyalty_program_app/page_product/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bat_loyalty_program_app/page_product/widget/local_widgets.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  static const routeName = '/product';

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage>
    with ProductComponents, MyComponents {
  int _currentPage = 0;

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

    if (!launchLoading) setPath(prevPath: args.prevPath, routeName: ProductPage.routeName);

    return PopScope( 
      canPop: canPop,     
        child: launchLoading
            ? MyWidgets.MyLoading2(context, isDarkMode)
            : GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                  appBar: MyWidgets.MyAppBarCart(
                    context,
                    isDarkMode,
                    "Product",
                    appVersion: appVersion,
                    onCartTap: () => Navigator.pushNamed(
                        context, CartPage.routeName,
                        arguments: MyArguments(token, prevPath: "/product")),
                  ),
                  body: Stack(children: [
                    Column(
                      children: [
                        imgList.isEmpty
                            ? ProductWidget.buildShimmerImage(
                                context: context,
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                              )
                            : ProductWidget.buildCarousel(
                                context: context,
                                imgList: imgList,
                                currentPage: _currentPage,
                                onPageChanged: (value) {
                                  setState(() {
                                    _currentPage = value;
                                  });
                                },
                                onPageSelected: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                }),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(                            
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Logitech',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer),
                                      ),
                                      Text('Headphone X200',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500)),
                                      ProductWidget.productCartDisplay(
                                        imagePath:
                                            'assets/images_examples/icon_stock1.png',
                                        label: '82 in stocks',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outlineVariant,
                                            ),
                                      ),
                                      Text('Description',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500)),
                                      ProductWidget.buildReadMoreText(
                                        context,
                                        'This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut',
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Column(                                      
                                        children: [
                                          Row(
                                            children: [
                                              Text('Points:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(' 500 PTS',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                            ],
                                          ),
                                          ProductQuantityWidget(),
                                        ],
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ));
  }
}
