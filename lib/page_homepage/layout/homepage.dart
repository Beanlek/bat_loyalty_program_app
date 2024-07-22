import 'dart:convert';

import 'package:bat_loyalty_program_app/l10n/l10n.dart';
import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/page_homepage/component/local_components.dart';
import 'package:bat_loyalty_program_app/page_homepage/layout/homepage_preview.dart';
import 'package:bat_loyalty_program_app/page_homepage/widget/local_widgets.dart';
import 'package:bat_loyalty_program_app/page_imagestatus/layout/imagestatus.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile.dart';
import 'package:bat_loyalty_program_app/page_track_history/layout/tracking_history.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:bat_loyalty_program_app/services/global_components.dart';
import 'package:bat_loyalty_program_app/services/routes.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:bat_loyalty_program_app/streams/general_stream.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/services/shared_preferences.dart';
import 'package:bat_loyalty_program_app/services/global_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

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
    initParam(context).whenComplete(() { setState(() { launchLoading = false; }); });
    
    super.initState();
  }

  @override
  void dispose() {
    mainScrollController.dispose();
    searchController.dispose();
    
    stickyController.dispose();
    productController.dispose();

    super.dispose();

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

  // void _toggleLocale() {
  //   setState(() {
  //     _currentLocale = _currentLocale == L10n.locals.first ? L10n.locals.last : L10n.locals.first;
  //     GeneralStreams.languageStream.add(_currentLocale);
  //   });
  // }

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
  Future<void> initParam(BuildContext context, {key, bool needToken = true}) async {
    super.initParam(context);

    await MyPrefs.init().then((prefs) async { prefs!;
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
      child: launchLoading ? MyWidgets.MyLoading2(context, isDarkMode) : GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(), child: Scaffold(
        
        key: scaffoldKey,
        appBar: HomeWidgets.MyAppBar(context, isDarkMode, appVersion: appVersion, scaffoldKey: scaffoldKey,
          onTap: () => Navigator.pushNamed( context, ProfilePage.routeName , arguments: MyArguments(token, prevPath: "/home", user: jsonEncode(user)))),

        body: 
        
        Stack(
          children: [
            CustomMaterialIndicator(
              edgeOffset: 10, backgroundColor: Colors.transparent, elevation: 0,
              onRefresh: () async { setState(() { isLoading = true; }); await refreshPage(context).whenComplete(() => setState(() { isLoading = false; })); },
              
              indicatorBuilder: (context, controller) => Icon(FontAwesomeIcons.rotateRight, size: MySize.Width(context, 0.08),),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                    
                      // product list
                      Expanded(
                        child: MyWidgets.MyScrollBar1( context, controller: mainScrollController, child: ListView.builder(
                          padding: EdgeInsets.all(9),
                          controller: mainScrollController,
                          
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                SizedBox(
                                  height: MySize.Height(context, 0.135),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Loyalty Points', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),),
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
                                              MyWidgets.MyTileButton(context, 'Tracking History', icon: Icons.history,
                                                onPressed: () => Navigator.pushNamed(context, TrackingHistoryPage.routeName, arguments: MyArguments(token, prevPath: "/home"))),
                                              MyWidgets.MyTileButton(context, 'Images Status', icon: Icons.image,
                                                onPressed: () => Navigator.pushNamed( context, ImageStatusPage.routeName , arguments: MyArguments(token, prevPath: "/home", username: user['id'] ))),
                                            ],
                                          )),
                                        ],
                                      )),
                                    ],
                                  )
                                ),
                        
                                SizedBox(height: 12,),
                                Text('Product Catalogue', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500)),
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
                                      GradientSearchBar.filterMenu(context, title: 'Brand', data: brandMap,
                                        applyFilters: applyFilters, clearFilters: clearFilters, pageSetState: setState, first: true),
                                      GradientSearchBar.filterMenu(context, title: 'Category', data: categoryMap,
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
                  ),
                ),
              ),
            ),
            
            MyWidgets.MyLoading(context, isLoading, isDarkMode)
          ],
        ),

        floatingActionButton: HomeWidgets.MyFloatingButton( context, 60, onTap: () async { setState(() { isLoading = true; });

          do {
            await takeImage().then((taken) async {
              Object? submit;
              setState(() => imageTaken = taken);

              if (imageTaken || imageRetake) {
                submit = await Navigator.pushNamed( context, HomepagePreview.routeName , arguments: MyArguments(token,
                  prevPath: "/home", receiptImage: receiptImage, username: user['id'],
                ));

                if (submit == true) { setState(() { isLoading = true; imageRetake = false; }); await refreshPage(context).whenComplete(() => setState(() { isLoading = false; })); }
                else if (submit == 'retake') { setState(() { imageRetake = true; }); }
                else { setState(() { imageRetake = false; }); }
              } else { setState(() { imageRetake = false; }); }
            });
          } while (imageRetake);

          setState(() { isLoading = false; });
        }),

        drawer: HomeWidgets.MyDrawer(context, isDarkMode, appVersion: appVersion, domainName: domainName, 
          items: [
            HomeWidgets.Item(context, icon: FontAwesomeIcons.userAlt, label: 'Profile',
              onTap: () => Navigator.pushNamed( context, ProfilePage.routeName , arguments: MyArguments(token, prevPath: "/home", user: jsonEncode(user)))),
            HomeWidgets.Item(context, icon: FontAwesomeIcons.storeAlt, label: 'Manage Outlets',
              onTap: () => false),

            Divider(color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.5),),

            HomeWidgets.Item(context, icon: FontAwesomeIcons.history, label: 'Tracking History',
              onTap: () => Navigator.pushNamed(context, TrackingHistoryPage.routeName, arguments: MyArguments(token, prevPath: "/home"))),
            HomeWidgets.Item(context, icon: FontAwesomeIcons.images, label: 'Images Status',
              onTap: () => Navigator.pushNamed( context, ImageStatusPage.routeName , arguments: MyArguments(token, prevPath: "/home", username: user['id'] ))),

            Divider(color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.5),),

            HomeWidgets.Item(context, icon: FontAwesomeIcons.gear, label: 'Settings',
              onTap: () => false),
            HomeWidgets.Item(context, icon: FontAwesomeIcons.signOut, label: 'Log Out',
              onTap: () async {
                await showDialog(context: context, builder: (context) => PopUps.Default(context, 'Logging Out',
                  subtitle: 'You are logging out. Proceed?', warning: 'Once logged out, all progress will not be saved.'),).then((res) async {
                    if (res ?? false) await Api.logout().whenComplete(() => Navigator.pushNamed( context, LoginPage.routeName ));
                  });
              }),
          ]
        )
      )),
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
                                                  context, 'Tracking History',
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
                                                  context, 'Images Status',
                                                  icon: Icons.image),
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
                            label: 'Profile',
                            onTap: () => Navigator.pushNamed(
                                context, ProfilePage.routeName,
                                arguments: MyArguments(token,
                                    prevPath: "/home",
                                    user: jsonEncode(user)))),
                        HomeWidgets.Item(context,
                            icon: FontAwesomeIcons.storeAlt,
                            label: 'Manage Outlets',
                            onTap: () => false),
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
                                context, TrackingHistoryPage.routeName,
                                arguments:
                                    MyArguments(token, prevPath: "/home"))),
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
                          await showDialog(
                            context: context,
                            builder: (context) => PopUps.Default(
                                context, 'Logging Out',
                                subtitle: 'You are logging out. Proceed?',
                                warning:
                                    'Once logged out, all progress will not be saved.'),
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
