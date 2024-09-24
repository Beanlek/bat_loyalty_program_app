import 'dart:convert';

import 'package:bat_loyalty_program_app/l10n/l10n.dart';
import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/page_homepage/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_homepage/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile.dart';
import 'package:bat_loyalty_program_app/page_track_history/layout/tracking_history.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:bat_loyalty_program_app/streams/general_stream.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  static const routeName = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with HomeComponents, MyComponents {
  List<Product> _filteredDataList = [];
  List<Product> _dataList = [];
  bool _showFilterOptions = false;
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    loyaltyPoints = 2000;

    _currentLocale = L10n.locals.first; // Initialize with the first locale
    GeneralStreams.languageStream.stream.listen((locale) {
      setState(() {
        _currentLocale = locale;
      });
    });

    initParam().whenComplete(() {
      setState(() {
        launchLoading = false;
        //futureProduct = Api.fetchProducts(domainName, token);
        //GeneralStreams.languageStream.add(const Locale('en'));
        futureProduct = _loadProducts();
        searchController.addListener(_filterData);
      });
    });
  }

  Future<List<Product>> _loadProducts() async {
    _dataList = await Api.fetchProducts(domainName, token);
    _filteredDataList = _dataList;
    return _dataList;
  }

  void _filterData() {
    String query = searchController.text.toLowerCase();
    setState(() {
      _filteredDataList = _dataList.where((products) {
        return products.name.toLowerCase().contains(query) ||
            products.brand.toLowerCase().contains(query);
      }).toList();
    });
  }

  List<Product> _filterProducts(String query) {
    return _filteredDataList = _dataList.where((products) {
      return products.name.toLowerCase().contains(query) ||
          products.name.contains(query) ||
          products.brand.toLowerCase().contains(query) ||
          products.brand.contains(query);
    }).toList();
  }

  void _toggleFilterOptions() {
    setState(() {
      _showFilterOptions = !_showFilterOptions;
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      isSearching = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _filteredDataList = _filterProducts(query);
        isSearching = false;
      });
    });
  }

  @override
  Future<void> initParam() async {
    super.initParam();

    await MyPrefs.init().then((prefs) async {
      prefs!;

      await Api.checkToken().then((res) {
        if (res) token = MyPrefs.getToken(prefs: prefs)!;

        if (!res) {
          FloatingSnackBar(message: 'Session time out.', context: context);
          Navigator.pushNamed(context, LoginPage.routeName);
        }
      });

      final _user = MyPrefs.getUser(prefs: prefs) ?? '{}';
      user = jsonDecode(_user);
      print('user: $user');
    });
  }

  @override
  void dispose() {
    GeneralStreams.languageStream.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Localizations = AppLocalizations.of(context);
    if (Localizations == null) {
      print("localizations is null");
    }

    return PopScope(
      canPop: false,
      child: launchLoading
          ? MyWidgets.MyLoading2(context, isDarkMode)
          : GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                  key: scaffoldKey,
                  appBar: HomeWidgets.MyAppBar(
                    context,
                    isDarkMode,
                    appVersion: appVersion,
                    scaffoldKey: scaffoldKey,
                    onTap: () => Navigator.pushNamed(
                        context, ProfilePage.routeName,
                        arguments: MyArguments(token,
                            prevPath: "/home", user: jsonEncode(user))),
                    selectedLocal: _currentLocale,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(                                        
                                        //'Loyalty Points',
                                        Localizations!.loyalty_points,
                                        //AppLocalizations.of(context)!.loyalty_points,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      Expanded(
                                          child: Row(
                                        children: [
                                          Expanded(
                                              child: Column(
<<<<<<< Updated upstream
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
                                                  text:
                                                      loyaltyPoints.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Theme.of(
                                                                  context)
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
                                                                    FontWeight
                                                                        .w500,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .outlineVariant))
                                                  ]))
                                            ],
                                          )),

                                          // tracking history and image status
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyWidgets.MyTileButton(
                                                  context, Localizations.tracking_history,
                                                  icon: Icons.history,
                                                  onPressed: () =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          TrackingHistoryPage
                                                              .routeName,
                                                          arguments: MyArguments(
                                                              token,
                                                              prevPath:
                                                                  "/home"))),
                                              MyWidgets.MyTileButton(
                                                  context, Localizations.image_status,
                                                  icon: Icons.image),
                                            ],
                                          )),
                                        ],
                                      )),
                                    ],
                                  )),
                              SizedBox(
                                height: 12,
=======
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(Localizations.loyalty_points, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),),
                                                  Expanded(child: Row(
                                                    children: [
                                                      Expanded(child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(user['id']!, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.normal),),
                                                          Text.rich(
                                                            TextSpan(text: user['points'].toString(), style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold,
                                                                color: Theme.of(context).colorScheme.outlineVariant),
                                                                children: [
                                                                  TextSpan(text: ' pts', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500,
                                                                  color: Theme.of(context).colorScheme.outlineVariant
                                                                )
                                                              )
                                                            ])
                                                          )
                                                        ],
                                                      )),
                                                      Expanded(child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          MyWidgets.MyTileButton(context, Localizations.tracking_history, icon: Icons.history,
                                                            onPressed: () => Navigator.pushNamed(context, TrackingHistoryPage.routeName, arguments: MyArguments(token, prevPath: "/home"))),
                                                          MyWidgets.MyTileButton(context, Localizations.image_status, icon: Icons.image,
                                                            onPressed: () => myPushNamed( context, setState, ImageStatusPage.routeName , arguments: MyArguments(token, prevPath: "/home", username: user['id'] ))),
                                                        ],
                                                      )),
                                                    ],
                                                  )),
                                                ],
                                              )
                                            ),
                                    
                                            SizedBox(height: 12,),
                                            Text(Localizations.product_catalogue, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500)),
                                          ]);
                                        } else if (index == 1) {
                                          return StickyHeader(
                                            header: Container( color: Theme.of(context).primaryColor, child: Padding( padding: const EdgeInsets.only(bottom: 3.0),
                                              child: GradientSearchBar( pageSetState: setState,
                                                applyFilters: applyFilters,
                                                filtersApplied: filtersApplied,
                                                datas: [ brandMap, categoryMap ],
                                                
                                                controller: searchController,
                                                focusNode: searchFocusNode,
                                              
                                                items: [
                                                  GradientSearchBar.filterMenu(context, title: Localizations.brand, data: brandMap,
                                                    applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState, first: true),
                                                  GradientSearchBar.filterMenu(context, title: Localizations.category , data: categoryMap,
                                                    applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState),
                                                ],
                                                onSearch: () {},
                                              )),
                                            ),
                                                
                                            content: GridView.builder(
                                            padding: const EdgeInsets.all(15),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2, // row
                                              childAspectRatio: 2.5 / 4,
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 20,
                                            ),
                                            itemCount: 12,
                                            shrinkWrap: true,
                                            
                                            physics: NeverScrollableScrollPhysics(),
                                            // controller: productController,
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
                                          );
                                        } else { return SizedBox(); }
                                      }
                                    )),
                                  ),
                                          
                                ],
>>>>>>> Stashed changes
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Localizations.product_catalogue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),

                                    //Search Bar
                                    GradientSearchBar(
                                      controller: searchController,
                                      onSearchChanged: onSearchChanged,
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
                                      ),
                                      onFilterPressed: _toggleFilterOptions,
                                      showFilterOptions: _showFilterOptions,
                                    ),

                                    // list of products
                                    Expanded(
                                        child: FutureBuilder<List<Product>>(
                                      future: futureProduct,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return MyWidgets.MyLoading2(
                                              context, isDarkMode);
                                        } else if (snapshot.hasError) {
                                          // FloatingSnackBar(message: '${snapshot.error}', context: context);
                                          return SnackBar(
                                            content: Text('${snapshot.error}'),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          // FloatingSnackBar(message: 'No product found.', context: context);
                                          return SnackBar(
                                            content: Text('No product found.'),
                                          );
                                        } else {
                                          return isSearching || isLoading
                                              ? MyWidgets.MyLoading2(
                                                  context, isDarkMode)
                                              : _filteredDataList.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                          'No matching products'))
                                                  : GridView.builder(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount:
                                                            2, // row
                                                        childAspectRatio:
                                                            2.5 / 4,
                                                        mainAxisSpacing: 20,
                                                        crossAxisSpacing: 20,
                                                      ),
                                                      itemCount:
                                                          _filteredDataList
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          AlwaysScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int i) {
                                                        final product =
                                                            _filteredDataList[
                                                                i];

                                                        return ProductCard(
                                                            imageUrl:
                                                                Image.memory(
                                                              product.imageData,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            title: product.name,
                                                            points:
                                                                product.points,
                                                            onLoveIconTap:
                                                                () {},
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                colors: [
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .tertiary,
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                                ]));
                                                      },
                                                    );
                                        }
                                      },
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton:
                      HomeWidgets.MyFloatingButton(context, 60, onTap: () {}),
                  drawer: HomeWidgets.MyDrawer(context, isDarkMode,
                      appVersion: appVersion,
                      domainName: domainName,
                      items: [
                        HomeWidgets.Item(context,
                            icon: FontAwesomeIcons.userAlt,
                            label: Localizations.profile,
                            onTap: () => Navigator.pushNamed(
                                context, ProfilePage.routeName,
                                arguments: MyArguments(token,
                                    prevPath: "/home",
                                    user: jsonEncode(user)))),
                        HomeWidgets.Item(context,
                            icon: FontAwesomeIcons.storeAlt,
                            label: Localizations.manage_outlet,
                            onTap: () => false),
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiary
                              .withOpacity(0.5),
                        ),
                        HomeWidgets.Item(context,
                            icon: FontAwesomeIcons.history,
                            label: Localizations.tracking_history,
                            onTap: () => Navigator.pushNamed(
                                context, TrackingHistoryPage.routeName,
                                arguments:
                                    MyArguments(token, prevPath: "/home"))),
                        HomeWidgets.Item(context,
                            icon: FontAwesomeIcons.images,
                            label: Localizations.image_status,
                            onTap: () => false),
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiary
                              .withOpacity(0.5),
                        ),
                        HomeWidgets.Item(context,
                            icon: FontAwesomeIcons.gear,
                            label: Localizations.settings,
                            onTap: () => false),
                        HomeWidgets.Item(context,
                            icon: FontAwesomeIcons.signOut,
                            label: Localizations.log_out, onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => PopUps.Default(
                                context, Localizations.logging_out,
                                subtitle:Localizations.you_are_logging_out,
                                warning:
                                    Localizations.progress_not_saved),
                          ).then((res) async {
                            if (res) {
                              await Api.logout().whenComplete(() =>
                                  Navigator.pushNamed(
                                      context, LoginPage.routeName));
                            }
                          });
                        }),
                      ]))),
    );
  }
}
