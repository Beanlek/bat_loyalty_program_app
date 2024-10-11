import 'package:bat_loyalty_program_app/page_cart/layout/cart.dart';
import 'package:bat_loyalty_program_app/page_product/component/local_components.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
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
  
  
  @override
  void initState() {
    super.initState();

    productFuture = Future.delayed(Duration.zero, () => null); 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshPage(context, setState);
    });

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
  Future<void> refreshPage(
      BuildContext context, void Function(void Function() fn) setState) async {
    await super.refreshPage(context, setState).whenComplete(() async {
      await MyPrefs.init().then((prefs) async {
        prefs!;
        final args = ModalRoute.of(context)!.settings.arguments as MyArguments;
        setState(() {
          productFuture = Api.fetchProductsByID(domainName, args.TOKEN, args.productId);
          isLoadingProduct = false; // Stop loading once the future is set
          
        });
      });
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
                  body: FutureBuilder<bool?>(
                      initialData: false,
                      future: isRefresh,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return MyWidgets.MyErrorPage(context, isDarkMode);
                          } else if (snapshot.hasData) {
                            isRefresing = snapshot.data!;
                            print('snapshot has data: $isRefresing');
                            if (isRefresing) {
                              refreshPage(context, setState);
                            }
                            return FutureBuilder(
                                future: productFuture,
                                builder: (context, snapshot) {
                                  if (isLoadingProduct) {
                                    //return MyWidgets.MyLoading2(context, isDarkMode);
                                    return ProductWidget.buildSkeletonLoader(context);
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Loading state
                                    //return MyWidgets.MyLoading2(context, isDarkMode);
                                    return ProductWidget.buildSkeletonLoader(context);
                                  } else if (snapshot.hasError) {
                                    // Error state
                                    return MyWidgets.MyErrorTextField(
                                        context, snapshot.error.toString());
                                  } else if (snapshot.hasData) {
                                    // Data fetched successfully
                                    final product = snapshot.data!;
                                    return GestureDetector(
                                      onTap: () => FocusManager
                                          .instance.primaryFocus
                                          ?.unfocus(),
                                      child: Scaffold(
                                        body: ProductWidget.buildProductDetails(
                                          context,
                                          imgList, // imgList or product.images
                                          currentPage,
                                          (value) {
                                            setState(() {
                                              currentPage = value;
                                            });
                                          },
                                          (index) {
                                            setState(() {
                                              currentPage = index;
                                            });
                                          },
                                          productName: product.name,
                                          productModel: product.brand,
                                          stockLabel: '82 in stocks',
                                          descriptionTitle: 'Description',
                                          description:
                                              'This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut This is the brand description you need to depict as however you want but it needs to be in smaller font and also not overflowed but still you can do it just adjust apa yang patut',
                                          pointsLabel: 'Points:',
                                          pointsValue: '${product.points} PTS',
                                        ),
                                      ),
                                    );
                                  } else {
                                    return MyWidgets.MyErrorTextField(context, "Error fetching data");
                                  }
                                }
                              );
                          } else {
                            //return MyWidgets.MyLoading2(context, isDarkMode);
                            return ProductWidget.buildSkeletonLoader(context);
                          }
                        } else {
                          //return MyWidgets.MyLoading2(context, isDarkMode);
                          return ProductWidget.buildSkeletonLoader(context);
                        }
                      }),
                )));
  }
}
